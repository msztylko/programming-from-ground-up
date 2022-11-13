# Counting Like a Computer

Basic information about binary system

### XOR trick

Processors execute different instructions as different speed. XOR operation is faster than the loading operation and this fact is used for loading register with zero:

```assembly
movl $0, %eax
```
is often replaced by
```assembly
xorl %eax, %eax
```
### Shift and rotate

```
Shift left 10010111 = 00101110
```
A left shift moves each digit of a binary number one space to the left, puts a zero in the ones spot, and chops off the furthest digit to the left. 

```
Rotate left 10010111 = 00101111
```
 A left rotate does the same thing, but takes the furthest digit to the left and puts it in the ones spot.
 
 Why do we use these operations? To interpret binary numbers by *shifting* and *masking*.
 **Masking** - process of eliminating everything you don’t want. Masking is accomplished by doing an AND with a
number that has the bits we are interested in set to 1.

When a number represents a set of options for a function or system call, the individual true/false elements are called flags. Many system calls have numerous options that are all set in the same register using a mechanism like we’ve described.  

Flags for open system call:
 * O_WRONLY - This flag is 0b00000000000000000000000000000001 in binary, or 01 in octal (or any number system for that matter). This says to open the file in write-only mode.
 * O_RDWR - This flag is 0b00000000000000000000000000000010 in binary, or 02 in octal. This says to open the file for both reading and writing.
 * O_CREAT - This flag is 0b00000000000000000000000001000000 in binary, or 0100 in octal. It means to create the file if it doesn’t already exist.
 * O_TRUNC - This flag is 0b00000000000000000000001000000000 in binary, or 01000 in octal. It means to erase the contents of the file if the file already exists.
 * O_APPEND - This flag is 0b00000000000000000000010000000000 in binary, or 02000 in octal. It means to start writing at the end of the file rather than at the beginning.

To use these flags, you simply OR them together in the combination that you want. For example, to open a file in write-only mode, and have it create the file if it doesn’t exist, I would use O_WRONLY (01) and O_CREAT (0100). OR’d together, I would have 0101.

