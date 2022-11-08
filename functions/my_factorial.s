# PURPOSE: compute 4! using recursive function

.section  .text

.globl _start
_start:
 # 1. push args, reverse order
 pushl $5
 # 2. call function 
 call factorial
 addl $4, %esp

 movl %ecx, %ebx
 movl $1, %eax
 int $0x80

# PURPOSE: compute n!
# %ecx - n
.type factorial, @function
factorial:
 # 3. prep %ebp
 pushl %ebp
 movl %esp, %ebp
 # 4. reserve space (no need, keep in registers) 
 # 
 # 5. load vars
 movl 8(%ebp), %ecx
 
 # 6. processing
 cmpl $1, %ecx
 je factorial_exit
 
 decl %ecx
 pushl %ecx
 call factorial
 movl 8(%ebp), %edx
 
 imull %edx, %ecx

# 7. exit function  
factorial_exit:
 movl %ebp, %esp
 popl %ebp
 ret
