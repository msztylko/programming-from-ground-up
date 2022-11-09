.section .data

data_items:
 .long  1, 9, 4, 5, 7, 2, 8, 6

# %ebx ref to data
# %ecx index
# %edx current value
# -4(%ebp) current max
# -8(%ebp) num items to process

.section .text
.globl _start
_start:
 # 1 push paramas
 pushl $8 # number of element to process
 pushl $data_items
 # 2 call function
 call maximum
 # 8 exit
 movl %eax, %ebx
 movl $1, %eax
 int $0x80

.type maximum, @function 
maximum:
 # 3 save ebp
 pushl %ebp
 movl %esp, %ebp
 # 4 reserve space
 subl $4, %esp
 # 5 load params
 movl 12(%ebp), %eax
 movl %eax, -8(%ebp)
 movl 8(%ebp), %ebx
 movl $0, %ecx
 movl (%ebx, %ecx, 4), %edx
 movl %edx, -4(%ebp)
 # 6 process
loop:
 cmpl %ecx, -8(%ebp)
 je loop_exit
 
 incl %ecx  # increment index
 decl -8(%ebp)
 movl (%ebx, %ecx, 4), %edx # new current value
 
 cmpl -4(%ebp), %edx
 jle loop

 movl %edx, -4(%ebp)

 # 7 exit function 
loop_exit:
 movl -4(%ebp), %eax
 movl %ebp, %esp
 popl %ebp
 ret
 
