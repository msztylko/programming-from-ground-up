# Intermediate Memory Topics

A computer looks at memory as a long sequence of numbered storage locations. A sequence of *millions* of numbered storage locations. Everything is stored in these locations. Your programs are stored there, your data is stored there, everything. Each storage location looks like every other one. **The locations holding your program are just like the ones holding your data.** In fact, the computer has no idea which are which, except that the executable file tells it where to start executing.

The instruction:
```assembly
movl data_items(,%edi,4), %ebx
```
takes up 7 storage locations:
 * 2 hold the instruction
 * 1 tells which registers to use
 * 4 hold the storage location of data_items

**byte** - the size of a storage location. Usually 8 bits.  
**word** - the size of a normal register. On 64-bit machines it should correspond to 64 bits and to 32 bits on 32-bit machines.  
**address** - a number that refers to a byte in memory. We normally don't use numeric values, but rather use labels.

```assembly
.section .data
my_data:
.long 2, 3, 4
```
**pointer** - a register or memory word whose value is an address.

## The Memory Layout of a Linux Program

When you program is loaded into memory, each .section is loaded into its own region of memory.  
The actual instructions (the .text section) are loaded at the address 0x08048000.  
The .data section is loaded immediately after that, followed by the .bss section.  
The last byte that can be addressed on Linux is location 0xbfffffff. Linux starts the stack here and grows it downward toward the other sections.

Stack from the bottom:
 - word of memory that is zero
 - null-terminated name of the program using ASCII characters
 - program's environment variables
 - command-line arguments 

Stack pushes:
```assembly
pushl %eax
```
is equivalent to
```assembly
movl %eax, (%esp)
subl $4, %esp
```
and for pops
```assembly
popl $eax
```
is the same as
```assembly
movl (%esp), %eax
addl $4, %esp
```

Your program’s data region starts at the bottom of memory and goes up. The stack starts at the top of memory, and moves downward with each push. This middle part between the stack and your program’s data sections is inaccessible memory. The last accessible memory address to your program is called the **system break** (also called the current break or just the break).

![image](https://user-images.githubusercontent.com/39266310/201473623-64e0ecc1-e90b-4df0-add7-694838eba2b3.png)

## Every Memory Address is a Lie

**Physical memory** refers to the actual RAM chips inside your computer and what they contain. If we talk about a physical memory address, we are talking about where exactly on these chips a piece of memory is located.   
**Virtual memory** is the way your program thinks about memory. Before loading your program, Linux finds an empty physical memory space large enough to fit your program, and then tells the processor to pretend that this memory is actually at the address 0x0804800 to load your program into.

Each program gets its own sandbox to play in. Every program running on your computer thinks that it was loaded at memory address 0x0804800, and that it’s stack starts at 0xbffffff. The address that a program believes it uses is called the virtual address, while the actual address on the chips that it refers to is called the physical address. The process of assigning virtual addresses to physical addresses is called **mapping**.
