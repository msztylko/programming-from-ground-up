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
