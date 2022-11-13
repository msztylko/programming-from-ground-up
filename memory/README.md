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


Virtual memory can be mapped to more than just physical memory; it can be mapped to disk as well. On Linux, swap partitions are used for that.

x86 processors cannot run instructions directly from disk, nor can they access data directly from disk. This requires the help of the operating system.

### Memory access on Linux:
1. The program tries to load memory from a virtual address.
2. The processor, using tables supplied by Linux, transforms the virtual memory address into a physical memory address on the fly.
3. If the processor does not have a physical address listed for the memory address, it sends a request to Linux to load it.
4. Linux looks at the address. If it is mapped to a disk location, it continues on to the next step. Otherwise, it terminates the program with a segmentation fault error.
5. If there is not enough room to load the memory from disk, Linux will move another part of the program or another program onto disk to make room.
6. Linux then moves the data into a free physical memory address.
7. Linux updates the processor’s virtual-to-physical memory mapping tables to reflect the changes.
8. Linux restores control to the program, causing it to re-issue the instruction which caused this process to happen.
9. The processor can now handle the instruction using the newly-loaded memory and translation tables.

To make the process more efficient, memory is separated out into groups called **pages**. When running Linux on x86 processors, a page is 4096 bytes of memory. All of the memory mappings are done a page at a time.
## Getting More Memory 

If you try to access a piece of virtual memory that hasn’t been mapped yet, it triggers an error known as a  **segmentation fault**, which will terminate your program.

If you need more memory, you can just tell Linux where you want the new break point to be, and Linux will map all the memory you need between the current and new break point, and then move the break point to the spot you specify. The way we tell Linux to move the break point is through the `brk` system call.

`brk`:
 * system call number 45, which will be in %eax
 * requested breakpoint should be loaded in %ebx
 * call it with `int $0x80`
 * new break point will be returned in %eax
 
The new break point might actually be larger than what you asked for, because Linux rounds up to the nearest page.

A **memory manager** is a set of routines that takes care of the dirty work of getting your program memory for you. Most memory managers have two basic functions - allocate and deallocate, `malloc` and `free` in C, respectively. When you need memory you call `allocate` and when you are done you call `deallocate` - this pattern of memory management is called **dynamic memory allocation**. The pool of memory used by memory managers is commonly referred to as the **heap**. 

Memory manager:
 * marks each block of memory in the heap as being used or unused
 * when you request memory, the memory manger
   * checks to see if there are any unused blocks of the appropiate size
   * if not, it calls the `brk` system call to request more memory
* when you free memory it marks the block as unused

