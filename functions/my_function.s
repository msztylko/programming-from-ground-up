# PURPOSE: compute 6^3 using function call in C convention
.section .text

.globl _start
_start:
# 1. Push parameters in revers order
pushl $3
pushl $6
# 2. call your function
call power
# 8. get return value, cleanup parameters
 movl %eax, %ebx
 addl $8, %esp
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
# 3. save %ebp on the stack and point %esp to it
pushl %ebp
movl %esp, %ebp
# 4. reserve space for local variables
subl $4, %esp
# 5. prepare variables
movl 8(%ebp), %eax
movl 12(%ebp), %ecx
movl %eax, -4(%ebp)
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
 movl -4(%ebp), %eax
 movl %ebp, %esp 
 pop %ebp
 ret
