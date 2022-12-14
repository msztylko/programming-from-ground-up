.include "linux.s"
.include "record-def.s"

# PURPOSE: This function writes a record to the given file descriptor
#
# INPUT: The file descriptor and a buffer
# 
# OUTPUT: This function produces a status code

# Stack loca variables
.equ ST_WRITE_BUFFER, 8
.equ ST_FD, 12

.section .text
.globl write_record
.type write_record, @function

write_record:
 pushl %ebp
 movl %esp, %ebp

 pushl %ebx # no idea why we need that?
 movl $SYS_WRITE, %eax
 movl ST_FD(%ebp), %ebx
 movl ST_WRITE_BUFFER(%ebp), %ecx
 movl $RECORD_SIZE, %edx
 int $LINUX_SYSCALL

 popl %ebx # no idea why we need that?
 movl %ebp, %esp
 popl %ebp
 ret
