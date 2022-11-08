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
  
 ![image](https://user-images.githubusercontent.com/39266310/200245952-83ae0b7e-adf3-48bb-9e31-9030ea80a1d7.png)  
 
https://flint.cs.yale.edu/cs421/papers/x86-asm/asm.html

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
Pop off all of the parameters we pushed onto the stack in order to get the stack pointer back where it was. We pushed 2 arguments, each 4 bytes long, so we simply add 4 * 2 (number of parameters) to %esp.

```assembly
pushl %eax
```
Save the first answer before calling the next function.

```assembly
 pushl $2
 pushl $5
 call power
 addl $8, %esp
```
Second function call - again, push arguments in reverse order, call function, move the stack pointer back.

```assembly
popl %ebx
```
The **second** answer is in %eax (this is where return value goes from the function). The **first** answer was saved on the stack (`pushl %eax`), so now we can pop it into %ebx.
%eax holds the second answer, %ebx holds the first answer.

```assembly
addl %eax, %ebx
```
Add them together, the result is in %ebx.

```assembly
 movl $1, %eax
 int $0x80
```
Exit, return code (%ebx) holds the result.

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
load both arguments into specified registers

```assembly
movl %ebx, -4(%ebp)   
```
store current result, we start we the first value in %ebx and we use `-4(%ebp)` location for storing current result.

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
compute power in a loop

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

This seems to be a general pattern for returning from a function:
```assembly
movl %ebp, %esp
popl %ebp
ret
```
*At this point, you should consider all local variables to be disposed of.* You moved stack pointer back, so future stack pushes will likely overwrite everything you put there.

## The C Calling Convention

[my_function.s](./my_function.s)

```assembly
.section .text

.globl _start
_start:
# 1. Push parameters in reverse order
pushl $3
pushl $6
# 2. call your function
# this call is responsible for 2 things:
#   - push return address onto the stack
#   - move %eip pointer to point to function code
call power
# 8. get return value, cleanup parameters
 # get return value from %eax
 movl %eax, %ebx
 # get rid of parameters by reseting the stack pointer 
 addl $8, %esp
 # exit sys call
 movl $1, %eax
 int $0x80

# PURPOSE: power(base, exp)
#
# VARIABLES: 
#          %eax - base
#          %ecx - exponent
#          -4(%ebp) - current result

.type power, @function
power:
# 3. save %ebp on the stack and copy the stack pointer to %ebp
pushl %ebp
movl %esp, %ebp
# 4. reserve space for local variables
#    only on use in this function, so reserve 4 space
subl $4, %esp
# 5. prepare variables
movl 8(%ebp), %eax  # load base
movl 12(%ebp), %ecx # load exponent
movl %eax, -4(%ebp) # set current result to base
# 6. processing
power_loop:
 cmpl $1, %ecx
 je exit
 movl -4(%ebp), %edx
 imull %eax, %edx
 movl %edx, -4(%ebp)
 decl %ecx
 jmp power_loop

# 7. exit
exit:
 # move result to %eax
 movl -4(%ebp), %eax
 # reset stack pointer
 movl %ebp, %esp 
 popl %ebp
 # return and set instruction pointer back to caller 
 ret
```

1. Push function parameters in the reverse order.
2. Call the function:
    - pushes return address onto the stack
    - moves %eip (Extended Instruction Pointer) to correct address)
 3. (Enter Function) Save %ebp on the stack and copy the stack pointer to %ebp.  
 This is used to create a fixed reference to the stack frame.
 4. Reserve space for the local variables.
 5. Prepare variables - initialize them to correct parameters
 6. Function processing
 7. Exit function:
    - move result to %eax
    - reset stack pointer
    - `ret` - return control flow to the caller, by setting %eip
 8. (Back to caller code)
    - get return value from %eax
    - reset stack pointer - move back from parameters we initially pushed
    
## Recursive Function - Factorial 5!

[my_factorial.s](./my_factorial.s)

```assembly
.section  .text
.globl _start
_start:
 pushl $5
 call factorial
 addl $4, %esp

 movl %ecx, %ebx
 movl $1, %eax
 int $0x80

.type factorial, @function
factorial:
 pushl %ebp
 movl %esp, %ebp

 movl 8(%ebp), %ecx
 
 cmpl $1, %ecx
 je factorial_exit
 
 decl %ecx
 pushl %ecx
 call factorial
 movl 8(%ebp), %edx
 
 imull %edx, %ecx

factorial_exit:
 movl %ebp, %esp
 popl %ebp
 ret 
```

### Breakdown

```assembly
 pushl $5
```
Push arguments onto the stack, this time only one.

```assembly
 call factorial
 ```
Call the funtion.

```assembly
 pushl %ebp
 movl %esp, %ebp
```
(Inside function) Save %ebp.  
No need to reserve storage for local variables in this function.

```assembly
 movl 8(%ebp), %ecx
```
Initialize variables, %ecx holds n.

```assembly
 cmpl $1, %ecx
 je factorial_exit
```
Base case - if current n = 1, return.

```assembly
 decl %ecx
 pushl %ecx
 call factorial
```
Decreament n, push it onot the stack and call factorial. That corresponds to the recursive call factorial(n-1).

```assembly
 movl 8(%ebp), %edx
```
Load orignal n to %edx this time. 

```assembly
 imull %edx, %ecx
```
n * factorial(n-1). %ecx will hold the final result.

```assembly
factorial_exit:
 movl %ebp, %esp
 popl %ebp
 ret 
```
Standard exit.

```assembly
 movl %ecx, %ebx
 movl $1, %eax
 int $0x80
```
Also mostly standard system call to exit, just not that we are using %ecx to hold the result.
