# PURPOSE:      This program finds the maximum number of a
#               set of data items.
#
# VARIABLES:    The registers have the following uses:
#
# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# %eax - Current data item
#
# The following memory locations are used:
# data_items - contains the item data. A 0 is used 
#              to terinate the dat 
#

.section .data

data_items:
 .long 3, 12, 54, 23, 95, 115, 234, 51, 20, 0

 .section .text

 .globl _start
_start:
 movl $0, %edi
 movl data_items(,%edi,4), %eax
 movl %eax, %ebx

start_loop:
 cmpl $0, %eax
 je loop_exit
 # incl %edi    # omitted for debugging demo 
 movl data_items(,%edi,4), %eax
 cmpl %ebx, %eax
 jle start_loop

 movl %eax, %ebx
 jmp start_loop

loop_exit:
 movl $1, %eax
 int $0x80
