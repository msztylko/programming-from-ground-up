.include "linux.s"
.include "record-def.s"

.section .data

input_file_name:
.ascii "test.dat\0"

output_file_name:
.ascii "testout.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

# Stack offsets for local variables
.equ ST_IN_FD, -4
.equ ST_OUT_FD, -8

.section .text
.globl _start
_start:
movl %esp, %ebp
subl $8, %esp

# open file for reading
movl $SYS_OPEN, %eax
movl $input_file_name, %ebx
movl $0, %ecx
movl $0666, %edx
int $LINUX_SYSCALL

movl %eax, ST_IN_FD(%ebp)

# open file for writing
movl $SYS_OPEN, %eax
movl $output_file_name, %ebx
movl $0101, %ecx
movl $0666, %edx
int $LINUX_SYSCALL

movl %eax, ST_OUT_FD(%ebp)

loop_begin:
    pushl ST_IN_FD(%ebp)
    pushl $record_buffer
    call read_record
    addl $8, %esp

    # returns the number of bytes read. If no the same number we
    # requested, the either EOF or error, so we're quitting
    cmpl $RECORD_SIZE, %eax
    jne loop_end

    incl record_buffer + RECORD_AGE

    # write the record out
    pushl ST_OUT_FD(%ebp)
    pushl $record_buffer
    call write_record
    addl $8, %esp

    jmp loop_begin

loop_end:
    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL
