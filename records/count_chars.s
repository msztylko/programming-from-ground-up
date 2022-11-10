# PURPOSE: Count the characters until a null byte is reached.

# INPUT: The address fo the character string

# OUTPUT: Return the count in %eax

# PROCESS:
#   Registers used:
#       %ecx - character count
#       %al - current character
#       %edx - current character address

.type count_chars, @function
.globl count_chars

# This is where our one parameter is on the stack
.equ ST_STRING_START_ADDRESS, 8
count_chars:
 pushl %ebp
 movl %esp, %ebp

 
 movl $0, %ecx # count starts at zero
 movl ST_STRING_START_ADDRESS(%ebp), %edx # starting address of data

count_loop_begin:
 # grab the current character
 movb (%edx), %al
 cmpb $0, %al # is it null?
 je count_loop_end # if yes go to end
 # otherwise, increment the counter and the pointer
 incl %ecx
 incl %edx
 # go back to the beginning of the loop
 jmp count_loop_begin

count_loop_end:
 movl %ecx, %eax # move the count into %eax
 popl %ebp
 ret
