# First programs

## Conpects
1. `%eax` - holds the system call number
2. `%ebx` - holds the return status
3. `int $0x80` - wakes up the kernel to run

## First assembly program
```assembly
exit.s

.section .data

.section .text
.globl _start
_start:
 movl $1, %eax
 movl $0, %ebx
 int $0x80
```

line `movl $0, %ebx` corresponds to return number. We can change it to ` movl $42, %ebx` 
and after running this program exit status will be 42.

We need 2 steps to be able to run this program
1. Assemble - transforms the human-readable file into a machine-readable one.

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
### Breakdown of the First assembly program

```assembly
.section .data
```
Instructions to assembler, called *assembler directives* or *pseudo-operations*.
Anything starting with a period isn't directly translated into a machine instruction.
`.section` breaks your program up into secitons.
`.section .data` - starts data section, list of any memory storage you will need for data.

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
