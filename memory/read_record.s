.include "record-def.s"
.include "linux.s"

# PURPOSE: This function reads a record from the file descriptor
#
# INPUT: The file descriptor and a buffer
# 
# OUTPUT: This function writes the data to the buffer
#         and returns a status code.

# Stack local variables
.equ ST_READ_BUFFER, 8
.equ ST_FD, 12

.section .text
.global read_record
.type read_record, @function 

read_record:
 pushl %ebp
 movl %esp, %ebp

 pushl %ebx
 movl ST_FD(%ebp), %ebx
 movl ST_READ_BUFFER(%ebp), %ecx
 movl $RECORD_SIZE, %edx
 movl $SYS_READ, %eax
 int $LINUX_SYSCALL

 popl %ebx

 movl %ebp, %esp
 popl %ebp
 ret
