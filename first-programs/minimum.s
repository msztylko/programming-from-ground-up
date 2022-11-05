# PURPOSE: Find minimum value in a specified list of numbers
#
# VARIABLES:
# 
# %eax - current position
# %ebx - minimum number  
# %ecx - value from the current position
#
# end of list specified with 256 value

.section .data

data_list:
 .long 9, 7, 3, 1, 2, 8, 4, 6, 256

.section .text

.globl _start

_start:                         # initialize registers
 movl $0, %eax                  # initialize current position to 0
 movl data_list(,%eax,4), %ecx  # load first value into %exc
 movl %ecx, %ebx                # set minimal value to the first found value

start_loop:     # iterate over all items
    # if -1 exit
    cmpl $256, %ecx
    je loop_exit
    incl %eax                   # increment %eax register (point to data), by one word (that comes from type .long ?)
    movl data_list(,%eax,4), %ecx
    cmpl %ebx, %ecx             # compare next value with the current minimal value
    jge start_loop              # if next ge current min, next iteration loop

    movl %ecx, %ebx             # ELSE
    jmp start_loop
loop_exit:      # end the program and put smallest number in the exit code
    # prep for exit
    movl $1, %eax
    # %ebx has to be set to minimum number, but it already holds it!
    int $0x80
