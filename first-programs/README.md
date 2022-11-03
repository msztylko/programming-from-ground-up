# First programs

## First assembly program

[exit.s](./exit.s)

```assembly

.section .data

.section .text
.globl _start
_start:
 movl $1, %eax
 movl $0, %ebx
 int $0x80
```

We need 2 steps to be able to run this program:
1. Assemble - transform the human-readable file into a machine-readable one.

```bash
as exit.s -o exit.o

file exit.o
exit.o: ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
```
`exit.o` is an *object file*. An object file is code in the machine's language.

2. Link - put together object files.

```bash
ld exit.o -o exit

file exit
exit: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, not stripped
```

## Breakdown of the First assembly program

```assembly
.section .data
```
Instructions to assembler, called *assembler directives* or *pseudo-operations*.  

Anything starting with a period isn't directly translated into a machine instruction:  
 - `.section` breaks your program up into sections.  
 - `.section .data` - starts data section, list of any memory storage you will need for data.

```assembly
.section .text
```
Starts text section with the actual program instructions.

```assembly
.globl _start
```
`_start` is a *symbol*, which means it is going to be replaced by something else either during assembly or linking.  
Symbols are used to refer to programs or data, by name instead of the location number.  
`.globl` means that assembler shouldn't discard this symbol after assembly, because the linker will need it.  
`_start` is a special symbol that always needs to be marked with `.globl` because it marks the location of the start of the program.

**Without marking this location in this way, when the computer loads your program
it won’t know where to begin running your program.**

```assembly
_start:
```
defines the value of the `_start` label.  
**label** - symbol followed by a colon. Labels define a symbol's value.

```assembly
movl $1, %eax
```
transfer the number 1 into the %eax register.  

`movl` instruction has 2 operands - *source* and *destination*.  

*Operands* can be:
 * numbers
 * memory location references
 * registers

General-purpose registers on x86, that we can use as *operands*:
* %eax
* %ebx
* %ecx
* %edx
* %edi
* %esi

Speical-purpose registers:
* %ebp
* %esp
* %eip
* %eflags

`movl $1, %eax` - `movl` instruction moves the number 1 into `%eax`.  
The dollar-sign indicates that we want to use **immediate mode** addressing.  
Without the dollar-sign it would do **direct addressing** loading whatever number is at address 1.
We want actual number and for that we need to use immediate mode.

Why do we move 1 into %eax?  

To make a system call.  
1 - the number of the `exit` *system call*. When you make a system call, the system call number has to be loaded into %eax. To make a system call, operating systen requires various parameters that are stored in registers. For `exit` system call, the OS requires a status code to be loaded into %ebx.

```assembly
movl $0, %ebx
```
move 0 into %ebx register. `exit` system call uses the content of %ebs register as a exit status value.
We can change it to ` movl $42, %ebx` and after running this program exit status will be 42.

```assembly
int $0x80
```
int stands for **interrupt**. `0x80` is the interrupt number to use. (0x80 instead of 80, because it's hexadecimal).

### System Call Review
1. OS features are accessed through **system calls**.
2. They are invoked by
   * setting up the registers in a special way
   * issuing the instruction `int $0x80`
3. Linux knows which system call to use from %eax register value.
4. Each system call has different requierments about contents of other registers.
   * for example `exit` system call has number 1 and requires status code to be placed in %ebx.
