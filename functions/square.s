.section .text

.globl _start
_start:
 pushl $8
 call square
 addl $4, %esp
 movl %eax, %ebx
 movl $1, %eax
 int $0x80

# %ebx - counter, %ecx - orignal n,  -4(%ebp) current result
.type square, @function
square:
 pushl %ebp
 movl %esp, %ebp

 subl $4, %esp
 movl 8(%ebp), %ebx
 movl %ebx, %ecx
 movl %ebx, -4(%ebp)

loop:
 cmpl $1, %ebx
 je exit

 addl %ecx, -4(%ebp)
 decl %ebx
 jmp loop

exit:
 movl -4(%ebp), %eax
 movl %ebp, %esp
 popl %ebp
 ret
