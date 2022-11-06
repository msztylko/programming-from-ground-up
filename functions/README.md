# All About Functions

Functions are composed of:
1. function name - a symbol that represents the address where the function's code starts.
2. function parameters - data items explicitly given to the function for processing.
3. local variables - data storage that a function uses while processing that is thrown away when it returns.
4. static variables - data storage that a function uses while processing that is **not** thrown away afterwards.
It's reused for every time the function's code is activated.
5. global variables - data storage that a function uses for processing which are managed outside the function.
6. return address - parameter which tells the function where to resume executing after the function is completed.
7. return value - main method of transferring data back to the main program.

These piece are present in most programming languages, but they can obey different **calling conventions**.

## Assembly-Language Functions using the C Calling Convention

### Memory stack
* lives at the top address of memory
* you can push values onto the top of the stack with `pushl`
* top is actually the bottom - the stack starts at the top of the memory and grows downward.
* you can pop values using `popl`
* `%esp` register always contains a pointer to the current top of the stack
  * when we push to stack (pushl) %esp gets subtracted by 4 (so that it points to the new top of the stack)
  * when we remove from stack (popl), 4 is added to %esp

Acccess the value on the top of the stack without removing it:
```assembly
movl (%esp), %eax
```
use the %esp register in indirect addressing mode to move top value into %eax.

```assembly
movl %esp, %eax
```
would make %eax hold the pointer to the top of the stack tather than the value at the top.

Access the value right below the top of the stack:
```assembly
movl 4(%esp), %eax
```
base pointer addressing mode, adds 4 to %esp before looking up the value being pointed to.

The **stack** is the key element for implementing C language calling convention.

## Function power(a, b) i.e. 2^3 + 5^2

```assembly
.section .data

.section .text

.globl _start

_start:
 pushl $3           
 pushl $2           
 call power         
 addl $8, %esp      
 pushl %eax         

 pushl $2
 pushl $5
 call power
 addl $8, %esp

 popl %ebx          
                    
 addl %eax, %ebx    
                    
 movl $1, %eax
 int $0x80

.type power, @function
power:
 pushl %ebp             
 movl %esp, %ebp        
 subl $4, %esp          

 movl 8(%ebp), %ebx     
 movl 12(%ebp), %ecx    

 movl %ebx, -4(%ebp)    

power_loop_start:
 cmpl $1, %ecx          
 je end_power
 movl -4(%ebp), %eax    
 imull %ebx, %eax        
                        
 movl %eax, -4(%ebp)    

 decl %ecx              
 jmp power_loop_start

end_power:
 movl -4(%ebp), %eax    
 movl %ebp, %esp        
 popl %ebp              
 ret
```

### Program breakdown

**MAIN**
```assembly
.section .data
```
Everything in this program is stored in registers, so no need for `.data`.

```assembly
.section .text

.globl _start

_start:
```
Standard start.

```assembly
 pushl $3           
 pushl $2 
```
Push arguments to function `power` in reverse order. We want to compute power(2,3) so we're pushing first 3 and then 2.

```assembly
 call power    
```
`call` instruction with the name of the function we want to start. call does 2 things:
1. push address of the next instruction (return address) onto the stack.
2. modify the instruction pointer (%eip) to point to the start of the function.

At the time the function starts, the stack looks like this:
```
Parameter #N
...
Parameter 2
Parameter 1
Return Address <--- (%esp)
```
So in preparation for function execution all parameters are push onto the stack and at the top we have the return address. GO TO POWER FUNCTION.

```assembly
addl $8, %esp
```

```assembly
pushl %eax
```

```assembly
 pushl $2
 pushl $5
 call power
 addl $8, %esp
```

```assembly
popl %ebx
```

```assembly
addl %eax, %ebx
```

```assembly
 movl $1, %eax
 int $0x80
```

**POWER FUNCTION**
```assembly
.type power, @function
power:
```

```assembly
pushl %ebp
```
Save the current base pointer register %ebp. %ebp is used for accessing function parameters and local variables.

```assembly
movl %esp, %ebp
```
Copy the stack pointer to %ebp. This allows you to be able to access the function parameters as fixed indexes from the base pointer. %ebp will always be where the stack pointer was at the beginning of the function, so it is more or less a constant reference to the **stack frame** (all of the stack variables used within a function: parameters, local variables and the return address). At this step stack looks like:
```
Parameter #N <--- N*4+4(%ebp)
...
Parameter 2 <--- 12(%ebp)
Parameter 1 <--- 8(%ebp)
Return Address <--- 4(%ebp)
Old %ebp <--- (%esp) and (%ebp)
```

```assembly
subl $4, %esp
```
Reserve space on the stack for local variables. In this case, move stack pointer down one word, because we're going to use -4(%ebp) to hold the current result. Now stack looks like:
```
Parameter #N <--- N*4+4(%ebp)
...
Parameter 2 <--- 12(%ebp)
Parameter 1 <--- 8(%ebp)
Return Address <--- 4(%ebp)
Old %ebp <--- (%ebp)
Local Variable 1 <--- -4(%ebp) and (%esp)
```
so now we can access all the data we need for this function with base pointer addressing using different offsets from %ebp. %ebp was made specifically for this purpose, which is why it is called the *base pointer*.

```assembly
 movl 8(%ebp), %ebx     
 movl 12(%ebp), %ecx  
```

```assembly
movl %ebx, -4(%ebp)   
```

```assembly
power_loop_start:
 cmpl $1, %ecx          
 je end_power
 movl -4(%ebp), %eax    
 imull %ebx, %eax        
                        
 movl %eax, -4(%ebp)    

 decl %ecx              
 jmp power_loop_start
```

```assembly
end_power:
 movl -4(%ebp), %eax    
 movl %ebp, %esp        
 popl %ebp              
 ret
```

`movl -4(%ebp), %eax` - store the return value in %eax
`movl %ebp, %esp` and `popl %ebp` - reset the stack to what is was when it was called
`ret` - return control back to wherever it was was called from. ret instruction pops whatever value is at the top of the stack, and sets the instruction pointer %eip to that value.
