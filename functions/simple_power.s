# PURPOSE: compute 2^6, without functions

# VARIABLES:
#           %eax - base
#           %ebx - current result
#           %ecx - power

.section .text
.globl _start
_start:
 movl $2, %eax
 movl %eax, %ebx
 movl $6, %ecx

loop:
 cmpl $1, %ecx
 je exit

 imul %eax, %ebx
 decl %ecx
 jmp loop

exit:
 movl $1, %eax
 int $0x80
