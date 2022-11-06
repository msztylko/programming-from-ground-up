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

```assembly
.section .data
```

```assembly
.section .text

.globl _start

_start:
```

```assembly
 pushl $3           
 pushl $2 
```

```assembly
 call power    
```

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

```assembly
.type power, @function
power:
```

```assembly
pushl %ebp
```

```assembly
movl %esp, %ebp
```

```assembly
subl $4, %esp
```

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





