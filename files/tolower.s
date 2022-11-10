.section .data
    # syscalls
    .equ OPEN_SYSCAL, 5
    .equ CLOSE_SYSCAL, 6
    .equ READ_SYSCAL, 3
    .equ WRITE_SYSCAL, 4
    .equ EXIT_SYSCALL, 1

    .equ STDIN, 0
    .equ STDOUT, 1
    .equ STDERR, 2

    .equ LINUX_SYSCALL, 0x80
    .equ EOF, 0

    .equ O_RDONLY, 0
    .equ O_CREAT_WRONLY_TRUN, 03101

.section .bss
    .equ BUFFER_SIZE, 500
    .lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

# STACK POSITIONS
    .equ ST_SIZE_RESERVE, 8
    .equ ST_FD_IN, -4
    .equ ST_FD_OUT, -8
    .equ ST_ARGC, 0 #Number of arguments
    .equ ST_ARGV_0, 4 #Name of program
    .equ ST_ARGV_1, 8 #Input file name
    .equ ST_ARGV_2, 12 #Output file name

.globl _start
_start:
# allocate space for file descriptors
    movl %esp, %ebp
    subl $ST_SIZE_RESERVE, %esp

# open files
open_fd_in:
    movl $OPEN_SYSCALL,     %eax
    movl $ST_ARGV_1(%ebp),  %ebx
    movl $O_RDONLY,         %ecx
    movl $0666,             %edx
    int $LINUX_SYSCALL

store_fd_in:
    movl %eax, ST_FD_IN(%ebp)

open_fd_out:
    movl $OPEN_SYSCALL, %eax
    movl $ST_ARGV_2(%ebp), %ebx
    movl $O_CREAT_WRONLY_TRUNC, %ecx
    movl $0666, %edx
    int $LINUX_SYSCALL

store_fd_out:
    movl %eax, ST_FD_OUT(%ebp)

# read/write buffers
read_loop_start:
    # read into buffer
    movl $READ_SYSCALL, %eax
    movl $ST_FD_IN(%ebp), %ebx
    movl $BUFFER_DATA, %ecx
    movl $BUFFER_SIZE, %edx
    int  $LINUX_SYSCALL
    # check for EOF
    cmpl $EOF, %eax    
    je exit_loop

read_loop_continue:
    # convert
    pushl $BUFFER_DATA
    pushl %eax          # this seems to be important as it comes from actual system call
    call convert_to_lower
    popl %eax           # get the size back
    addl $4, %esp       # reset %esp
    # write buffer
    movl %eax, %edx
    movl $WRITE_SYSCALL, %eax
    movl $ST_FD_OUT, %ebx
    movl $BUFFER_DATA, %ecx
    int $LINUX_SYSCALL

    jmp read_loop_start
    
exit_loop:
    
    movl $CLOSE_SYSCALL, %eax
    movl $ST_FD_OUT(%ebp), %ebx
    int $LINUX_SYSCALL
    movl $CLOSE_SYSCALL, %eax
    movl $ST_FD_IN(%ebp), %ebx
    int $LINUX_SYSCALL

    movl $EXIT_SYSCALL, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL
#########################
# VARIABLES:
# %eax - beginning of buffer
# %ebx - length of buffer
# %edi - current buffer offset
# %cl - current byte being examined
# (first part of %ecx)
# conver to lower
    .equ UPPERCASE_A, 'A'
    .equ UPPERCASE_Z, 'Z'
    .equ LOWER_CONVERSION, 'a' - 'A'
    .equ ST_BUFFER_LEN, 8
    .equ ST_BUFFER, 12

convert_to_lower:
    pushl %ebp
    movl %esp, %ebp

    movl $ST_BUFFER(%ebp), %eax
    movl $ST_BUFFER_LEN(%ebp), %ebx
    movl $0, %edi

    cmpl $0, %ebx
    je end_convert_loop

convert_loop:
    movb (%eax, %edi, 1), %cl
    cmpb $UPPERCASE_A, %cl
    jl next_byte
    cmpb $UPPERCASE_Z, %cl
    jg next_byte

    addb $LOWER_CONVERSION, %cl
    movb %cl, (%eax, %edi, 1)

next_byte:
    incl %edi
    cmpl %edi, %ebx
    jne convert_loop

end_convert_loop:
    movl %ebp, %esp
    popl %ebp
    ret
