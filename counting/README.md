# Counting Like a Computer

### XOR trick

Processors execute different instructions at different speed. XOR operation is faster than the loading operation and this fact is used for loading register with zero:

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

## The Program Status Register

**program status register** - holds information about what happens in a computation.

## Other Numbering Systems

The way a computer handles decimals is by storing them at a fixed precision (number of significant bits).  A computer stores decimal numbers in two parts - the *exponent* and the *mantissa*.


For example, 12345.2 is stored as 1.23452 * 10^4. The mantissa is 1.23452 and the exponent is 4. All numbers are stored as X.XXXXX * 10^XXXX. The number 1 is stored as 1.00000 * 10^0.

Negative numbers could be represented with the first bit singaling the sign. However, such representation has mamy complications for numeric operations and instread we use **two’s complement** representation.

To get the negative representation of a number in two’s complement form, you must perform the following steps:  
1. Perform a NOT operation on the number
2. Add one to the resulting number

So, to get the negative of 00000000000000000000000000000001, you wouldfirst do a NOT operation, which gives 11111111111111111111111111111110, and then add one, giving 11111111111111111111111111111111.   
To get negative two, first take 00000000000000000000000000000010. The NOT of that number is 11111111111111111111111111111101. 
Adding one gives 11111111111111111111111111111110.

Also, the first digit still carries the sign bit, making it simple to determine whether or not the number is positive or negative. Negative numbers will always have a 1 in the leftmost bit.

When you increase the size of a signed quantity in two’s complement representation, you have to perform **sign extension**. 
Sign extension means that you have to pad the left-hand side of the quantity with whatever digit is in the sign digit when you add bits.

## Octal and Hexadecimal Numbers

What makes octal nice is that every 3 binary digits make one octal digit (there is no such grouping of binary digits into decimal). 
So 0 is 000, 1 is 001, 2 is 010, 3 is 011, 4 is 100, 5 is 101, 6 is 110, and 7 is 111.

Permissions in Linux are done using octal. This is because Linux permissions are based on the ability to read, write and execute. The first bit is the read permission, the second bit is the write permission, and the third bit is the execute permission.

In octal, each digit represented three bits. In hexadecimal, each digit represents four bits. Every two digits is a full byte, and eight digits is a 32-bit word.

## Order of Bytes in a Word

One thing that confuses many people when dealing with bits and bytes on a low level is that, when bytes are written from registers to memory, their bytes are written out least-significant-portion-first. 
What most people expect is that if they have a word in a register, say 0x5d 23 ef ee (the spacing is so you can see where the bytes are), the bytes will be written to memory in that order. 
However, on x86 processors, the bytes are actually written in reverse order. 
In memory the bytes would be 0xee ef 23 5d on x86 processors. 
The bytes are written in reverse order from what they would appear conceptually, but the bits within the
bytes are ordered normally.

Not all processors behave this way. The x86 processor is a little-endian processor, which means that it stores the "little end", or least-significant byte of its words first.

![image](https://user-images.githubusercontent.com/39266310/201521613-7163b4a9-31e4-48dc-9030-cfba5cf0a147.png)

Other processors are big-endian processors, which means that they store the "big end", or most significant byte, of their words first, the way we would naturally read a number.

![image](https://user-images.githubusercontent.com/39266310/201521652-6f6ea27c-05d6-43b3-bde0-72f6a52dcdf8.png)


## Converting Numbers for Display
