# Dealing with Files

UNIX files, no matter what program created them, can all be accessed as a sequential stream of bytes.
When you access a file, you start by opening it by name. The operating
system then gives you a number, called a file descriptor, which you use to refer to
the file until you are through with it. You can then read and write to the file using
its file descriptor.

## Working with files

1. Request the file
    - tell Linux the name of the file and the mode
    - open system call (filename, number representing the mode, permission set)
        - %eax - the system call number (5)
        - %ebx - the address of the first character of the filename
        - %ecx - number representing the read/write intentions (0 - read, 03101 - write)
        - %edx - the permission set stored as a number (0666 etc)
2. Linux returns a file descriptor in %eax, use it to refer to this file throughout your program.
3. Read or write to file
    - read
        - %eax - the system call number (3)
        - %ebx - the file descriptor
        - %ecx - the address of a buffer for storing the data that is read
        - %edx - the size of the buffer
        - `read` will return with either the number of characters read from the file, or an error code (negative number)
    - write
        - %eax - the system call number (4)
        - %ebx - the file descriptor
        - %ecx - the address of a buffer that is filled with the data to write out
        - %edx - the size of the buffer
        - `write` wil return the number of bytes written in %eax or an error code
4. Close the file
    - the system call number (6)
    - the file descriptor (in %ebx)

## Buffers and .bss

A buffer is a continuous block of bytes used for bulk data transfer. The OS needs to have a place to store the data it reads and this is what buffer is for:  
    - buffers are fixed size  
    - you need to reserve static or dynamic storage for buffer
    
    
`.bss` use this section to reserve storage (it's like data section, but it doesn't take up space in the executable)

```assembly
.section .bss

.lcomm my_buffer, 500
```

`.lcomm` directive will create a symbol, my_buffer, that refers to a 500-byte storage location.
If we opened a file for reading and have placed the file descriptor in %ebx we can do

```assembly
movl $my_buffer, %ecx
movl 500, %edx
movl 3, %eax
int $0x80
```
We use `$my_buffer` to put the address of the buffer into %ecx. `my_buffer` instead would use direct addressing mode and would put value pointed by `my_buffer` instead of the address.

## Standard and Special Files

Linux programs usually have at least three open file descriptors whey they begin.

1. STDIN - *standard input*. Read-only file, and usually represents your keyboard. This is always file descriptor 0.
2. STDOUT - *standard output*. Write-only file, and usually represnts your screen display. This is always file descriptor 1.
3. STDERR - *standard error*. Write-only file, and usually represents your screen display and is mostly used for error messages. This is always file descriptor 2.

Any of these "files" can be redirected form or to a real file. UNIX-based operating systems treat all input/output systems as files:  
    - network connections  
    - serial port  
    - audio devices  

## Using Files in a Program

`.equ` directive - assign names to numbers.

```assembly
.equ LINUX_SYSCALL, 0x80
int $LINUX_SYSCALL
```

## `tolower` program breakdown

[tolower.s](./tolower.s)

### Constants

```assembly
.section .data
    # syscalls
    .equ OPEN_SYSCALL, 5
    .equ CLOSE_SYSCALL, 6
    .equ READ_SYSCALL, 3
    .equ WRITE_SYSCALL, 4
    .equ EXIT_SYSCALL, 1

    .equ STDIN, 0
    .equ STDOUT, 1
    .equ STDERR, 2

    .equ LINUX_SYSCALL, 0x80
    .equ EOF, 0

    .equ O_RDONLY, 0
    .equ O_CREAT_WRONLY_TRUNC, 03101
```
This is a bigger program, so no way to remember all numeric values used in different places. Better to put majority of them in the one place at the beginning of the program.

### Buffer allocation

```assembly
.section .bss
    .equ BUFFER_SIZE, 500 
    .lcomm BUFFER_DATA, BUFFER_SIZE

```
Again, it's useful to define constants to values we're going to refer to later.

### `convert_to_lower` function

```assembly
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

    movl ST_BUFFER(%ebp), %eax
    movl ST_BUFFER_LEN(%ebp), %ebx
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
```

Constants are useful for defining stack positions we're going to refer to frequently `ST_BUFFER_LEN` and `ST_BUFFER`.

```assembly
    cmpl $0, %ebx
    je end_convert_loop
```
sanity check to make sure that we don't have a buffer with size 0.

`%cl` - first part of %ecx

Conversion goes byte-by-byte.

### Working with files

General pattern for working with files is:
1. Allocate space for file descriptors
2. For each file you work with:
    - open file with syscall
    - store file descriptor

```assembly
    movl %esp, %ebp
    subl $ST_SIZE_RESERVE, %esp
```
Allocates 8 bytes for file descriptors.

```assembly
open_fd_in:
    movl $OPEN_SYSCALL, %eax
    movl ST_ARGV_1(%ebp), %ebx
    movl $O_RDONLY, %ecx
    movl $0666, %edx
    int $LINUX_SYSCALL
```
Open system call for input file.

```assembly
store_fd_in:
    movl %eax, ST_FD_IN(%ebp)
```
Store file descriptor on the stack. After making the system call, the file descriptor of the newly-opened file is stored in %eax.

```assembly
open_fd_out:
    movl $OPEN_SYSCALL, %eax
    movl ST_ARGV_2(%ebp), %ebx
    movl $O_CREAT_WRONLY_TRUNC, %ecx
    movl $0666, %edx
    int $LINUX_SYSCALL

store_fd_out:
    movl %eax, ST_FD_OUT(%ebp)
```
The same steps for output file.

Getting file names from the command line is easy, becaue when a Linux program begins, all pointers to command-line arguments are stored on the stack. That's why we can say:

```assembly
      .equ ST_ARGC, 0 # Number of arguments
      .equ ST_ARGV_0, 4 # Name of program
      .equ ST_ARGV_1, 8 # Input file name
      .equ ST_ARGV_2, 12 # Output file name
```

for this to work we also need to store the current stack pointer in %ebp and we do it at the beginning of the program:

```assembly
_start:
    movl %esp, %ebp
```

`.equ O_CREAT_WRONLY_TRUNC, 03101` mode we use to open output file is write-only, create-if-doesn’t-exist, truncate-if-does-exist mode.

### Read/write loop

1. Read into buffer
    - check for EOF  

```assembly
    # read into buffer
    movl $READ_SYSCALL, %eax
    movl ST_FD_IN(%ebp), %ebx
    movl $BUFFER_DATA, %ecx
    movl $BUFFER_SIZE, %edx
    int  $LINUX_SYSCALL
    # check for EOF
    cmpl $EOF, %eax
    je exit_loop
```

2. Process buffer 
    - call `convert` function (push params in reverse order)
    - cleanup after call (reset %esp)

```assembly
    pushl $BUFFER_DATA
    pushl %eax          # this seems to be important as it comes from actual system call
    call convert_to_lower
    popl %eax           # get the size back
    addl $4, %esp       # reset %esp
```

3. Write buffer to output file

```assembly
    movl %eax, %edx
    movl $WRITE_SYSCALL, %eax
    movl ST_FD_OUT(%ebp), %ebx
    movl $BUFFER_DATA, %ecx
    int $LINUX_SYSCALL

    jmp read_loop_start
```
