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
