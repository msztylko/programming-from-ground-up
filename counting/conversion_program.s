.include "linux.s"

.section .data

# this is where it will be stored
tmp_buffer:
    .ascii "\0\0\0\0\0\0\0\0\0\0\0"

.section .text
.globl _start

_start:
    movl %esp, %ebp

    # storage for the result
    pushl $tmp_buffer
    pushl $824      # number to convert
    call integer2string
    addl $8, %esp

    # get the character count for out system call
    pushl $tmp_buffer
    call count_chars
    addl $4, %esp

    # the count goes in %edx for SYS_WRITE
    movl %eax, %edx

    # make the system call
    movl $SYS_WRITE, %eax
    movl $STDOUT, %ebx
    movl $tmp_buffer, %ecx
    int $LINUX_SYSCALL

    # Write a carriage return
    pushl $STDOUT
    call write_newline

    # exit
    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL
