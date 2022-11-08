.section .text

.globl _start

_start:
 # 1. push args in revers
 pushl $2
 pushl $9
 # 2. call function
 call power
 # 8. full exit
 movl %eax, %ebx
 movl $1,  %eax
 int $0x80

# %ecx - base, %edx - power, -4(%ebp) - current result
.type power, @function
power:
 # 3. save %ebp
 pushl %ebp
 movl %esp, %ebp
 # 4. reservse space
 subl $4, %esp
 # 5. prep vars
 movl 8(%ebp), %ecx
 movl 12(%ebp), %edx
 movl %ecx, -4(%ebp)
 # 6. process

power_loop:
 cmpl $1, %edx
 je power_exit
 
 movl -4(%ebp), %eax
 imull %ecx, %eax
 movl %eax, -4(%ebp)

 decl %edx
 jmp power_loop

 # 7. function exit
power_exit:
 movl -4(%ebp), %eax
 movl %ebp, %esp
 popl %ebp
 ret 
