# PURPOSE: Program for computing the value
#          2^3 + 5^2 with functions

# No data section, everything is stored in registers
.section .data

.section .text

.globl _start

_start:
 # function call for 2^3
 pushl $3           # push second argument
 pushl $2           # push first argument
 call power         # call the function
 addl $8, %esp      # move the stack pointer back
 pushl %eax         # save the first result

 # function call for 5^2
 pushl $2
 pushl $5
 call power
 addl $8, %esp

 popl %ebx          # pop answer into %ebx
                    # first answer is saved in %eax

 addl %eax, %ebx    # add two answers together
                    # the result is saved in %ebx
 movl $1, %eax
 int $0x80

# PURPOSE: Compute the value of a number raised to a power.

# INPUT:   first arg - base
#          second arg - exponent

# NOTES:   the power must be 1 or greater

# VARIABLES:
#           %ebx - holds the base number
#           %ecx - holds the power
#           -4(%ebp) - holds the current result

#           %eax is used for temporary storage
.type power, @function
power:
 pushl %ebp             # save old base point
 movl %esp, %ebp        # make stack pointer the base pointer
 subl $4, %esp          # get room for our local storage

 movl 8(%ebp), %ebx     # put first argument in %eax
 movl 12(%ebp), %ecx    # put second argument in %ecx

 movl %ebx, -4(%ebp)    # store current result

power_loop_start:
 cmpl $1, %ecx          # if the power is 1, finish
 je end_power
 movl -4(%ebp), %eax    # move the current result into %eax
 imull %ebx, %eax       # multiply the current result by 
                        # the base number
 movl %eax, -4(%ebp)    # store the current result

 decl %ecx              # decrease the power
 jmp power_loop_start

end_power:
 movl -4(%ebp), %eax    # return value goes into %eax
 movl %ebp, %esp        # restore the stack pointer
 popl %ebp              # restore the base pointer
 ret

