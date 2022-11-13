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
