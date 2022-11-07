# PURPOSE: compute 6^3 using function call in C convention
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
 pop %ebp
 # return and set instruction pointer back to caller 
 ret
