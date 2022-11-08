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

Any of these "files" can be redirected form or to a real file. UNIX-based operating systems treat all input/output systems as files.
    - network connections
    - serial port
    - audio devices
