.include "linux.s"
.include "record-def.s"

.section .data
file_name:
 .ascii "test.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.section .text
.globl _start
_start:
# These are the locations on the stack where
# we will store the input and output fd
# we can also use .data section instead

.equ ST_IN_FD, -4
.equ ST_OUT_FD, -8

movl %esp, %ebp
subl $8, %esp

movl $SYS_OPEN, %eax
movl $file_name, %ebx
movl $0, %ecx   # open read-only
movl $0666, %edx
int $LINUX_SYSCALL

movl %eax, ST_IN_FD(%ebp)

movl $STDOUT, ST_OUT_FD(%ebp)

record_read_loop:
 pushl ST_IN_FD(%ebp)
 pushl $record_buffer
 call read_record
 addl $8, %esp

 cmpl $RECORD_SIZE, %eax
 jne finished_reading

 pushl $RECORD_FIRSTNAME + record_buffer
 call count_chars
 addl $4, %esp

 movl %eax, %edx
 movl ST_OUT_FD(%ebp), %ebx
 movl $SYS_WRITE, %eax
 movl $RECORD_FIRSTNAME + record_buffer, %ecx
 int $LINUX_SYSCALL

 pushl ST_OUT_FD(%ebp)
 call write_newline
 addl $4, %esp

 jmp record_read_loop

finished_reading:
 movl $SYS_EXIT, %eax
 movl $0, %ebx
 int $LINUX_SYSCALL
