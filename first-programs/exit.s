# PURPOSE:  Simple program that exits and returns a
#           status code back to the Linux kernel
#

# INPUT:    none
#

# OUTPUT:   returns a status code. This can ve viewed
#           by typing
#
#           echo $?
#

# VARIABLES:
#           %eax holds the system call number
#           %ebx holds the return status
.section .data

.section .text
.globl _start
_start:
 mov1 $1, %eax
 mov1 $0, %ebx
 int $0x80
