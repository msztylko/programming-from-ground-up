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
   
   
# Only numbers
>When reading a piece of paper, you can stop when you run out of
numbers. However, the computer only contains numbers, so it has no idea when it
has reached the last of your numbers.  

This is why we use null character to end strings in C and we need to specify the number of elements we want to work with. There are only numbers.

## Second Assembly Program - Maximum Number
...

## Assembly debugging with GDB

based on [broken_maximum.s](./broken_maximum.s)

```assembly
.section .data

data_items:
 .long 3, 12, 54, 23, 95, 115, 234, 51, 20, 0

 .section .text

 .globl _start
_start:
 movl $0, %edi
 movl data_items(,%edi,4), %eax
 movl %eax, %ebx

start_loop:
 cmpl $0, %eax
 je loop_exit
 # incl %edi    # omitted for debugging demo 
 movl data_items(,%edi,4), %eax
 cmpl %ebx, %eax
 jle start_loop

 movl %eax, %ebx
 jmp start_loop

loop_exit:
 movl $1, %eax
 int $0x80
```

First, include debugging information in the executable.

```bash
as --gstabs broken_maximum.s -o broken_maximum.o
```
linking is the same as before.

Now you can run this program under debugger
```bash
gdb ./broken_maximum
```

You can now run your program by typing `run`. It will keep running in an infinite loop, use control-c to stop it by sending `SIGINIT` signal
```bash
Starting program: /home/marcin/code/programming-from-ground-up/first-programs/broken_maximum 
^C
Program received signal SIGINT, Interrupt.
start_loop () at broken_maximum.s:29
29	 cmpl $0, %eax
```
Program is now stopped and you can step through it with `stepi` (step instruction)
```bash
(gdb) stepi
30	 je loop_exit
(gdb) stepi
32	 movl data_items(,%edi,4), %eax
(gdb) stepi
33	 cmpl %ebx, %eax
(gdb) stepi
34	 jle start_loop
(gdb) stepi
29	 cmpl $0, %eax
(gdb) stepi
30	 je loop_exit
(gdb) stepi
32	 movl data_items(,%edi,4), %eax
(gdb) stepi
33	 cmpl %ebx, %eax
```

Here condition for exiting loop is not triggered, we can check if the content of registers is as expected with `into register` command.

```bash
(gdb) info register
rax            0x3	3
rbx            0x3	3
rcx            0x0	0
rdx            0x0	0
rsi            0x0	0
rdi            0x0	0
rbp            0x0	0x0
rsp            0x7fffffffdd90	0x7fffffffdd90
r8             0x0	0
r9             0x0	0
r10            0x0	0
r11            0x0	0
r12            0x0	0
r13            0x0	0
r14            0x0	0
r15            0x0	0
rip            0x4000bf	0x4000bf <start_loop>
eflags         0x246	[ PF ZF IF ]
cs             0x33	51
ss             0x2b	43
ds             0x0	0
es             0x0	0
fs             0x0	0
gs             0x0	0
```

If we are interested in only one register, we can do it with `print`
```bash
(gdb) print/d $eax
$1 = 3
(gdb) print $eax
$2 = 3
```
`print` shows value in hexadecial, `print/d` in decimal.

To debug program that doesn't run in infinite loop or cannot be stopped with control-c you need to use **breakpoints**. You need to set breakpoints before program starts running.

```bash
break <line-number>
```

While debugging I find myself recompiling and linking my files again and again. That part can be automated with a `makefile`:

```bash
minimum: minimum.o
    ld -o minimum minimum.o
minimum.o: minimum.s
    as -o minimum.o minimum.s
clean:
    rm *.o minimum
```
