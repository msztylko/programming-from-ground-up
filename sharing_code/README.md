#  Sharing Functions with Code Libraries

Shared libraries are also know as *shared objects, dynamic-link libraries, DLLs, or .so files*

## Upgrade to 64-bit assembly

`movl` -> `movq` q for quad  
`%eax` -> `%rax`

[helloworld-nolib.s](./helloworld-nolib.s)

### Dynamic linking technicalities
The book uses 32-bit assembly and I follow it this way on my 64-bit Linux using emulation to 32-bit version. However, libc.so is needed for dynamic linking and I only had 64-bit version of this library. 32-bit version can installed with:
```bash
apt-get install libc6:i386 libc6-dev-i386
```

## Using a Shared Library

```makefile
helloworld-lib32: helloworld-lib32.o
    ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 helloworld-lib32.o -lc -o helloworld-lib32
helloworld-lib32.o: helloworld-lib32.s
    as --32 helloworld-lib32.s -o helloworld-lib32.o
```

`-lc` option says to link to the c library, named `libc.so` Given library name (c) linker:
* prepends the string lib to the beginning of the library name  
* appends .so to the end of it   
to form the library's name.

## How Shared Libraries Work

*statically-linked executable* - program with all the code contained within the source file.  
*dynamically-linked executable* - program that uses external libraries.

Any symbols that are not defined within our program are looked up in dynamically linked libraries.
When dynamicall-linked program begins execution:
1. The dynamic linker (/lib/ld-linux.so.2) is loaded first.
2. It search for and loads dynamically linked libraries (libc.so)
3. Finally, it replaces all the needed symbols with the actual location in the dynamic library 

```bash
ldd helloworld-nolib

not a dynamic executable
```

```bash
ldd helloworld-lib32

    linux-gate.so.1 (0xf7f6e000)
	libc.so.6 => /lib/i386-linux-gnu/libc.so.6 (0xf7d71000)
	/lib/ld-linux.so.2 (0xf7f6f000)
```

`ldd` shows shared object dependencies

## Finding Information about Libraries

Useful data types:  
 * `int` - integer number, 4 bytes on x86 processor
 * `long` - integer number, 4 bytes on x86 processor
 * `long long` -integer number, 8 bytes on x86 processor
 * `short` - integer number, 2 bytes on x86 processor
 * `char` - single-byte integer number. Used for storing character data
 * `float` - floating-point number, 4 bytes on x86 processor
 * `double` - floating-point number, 8 bytes on x86 processor
 * `unsigned` - modifier used for the above types which keeps them from being used as signed quantities.
 * `*` - a pointer to a location holding the given value (4 bytes on x86 processor). 
 * `struct` - set of data items that have been put together under a name.  

```C
struct teststruct {
	int a;
	char *b;
};
```

 * `typedef` - allows you to rename a type

## Useful Functions
 
From the c library:
 * `size_t strlen (const char *s)` - calculates the size of null-terminated strings
 * `int strcmp (const char *s1, const char *s2)` - compares two strings alphabetically
 * `char * strdup (const char *s)` - takes the pointer to a string, and creates a new copy in a new location, and returns the new location
 * `FILE * fopen (const char *filename, const char *opentype)` - opens a managed, buffered file (allows easier reading and writing than using file descriptors directly)
 * `int fclose (FILE *stream)` - closes a file opened with fopen
 * `char * fgets (char *s, int count, FILE *stream)` - fetches a line of characters into string s
 * `int fputs (const char *s, FILE *stream)` - writes a string to the given open file
 * `int fprintf (FILE *stream, const char *template, ...)` - like printf, but it uses an open file rather than defaulting to using standard output

## Building a Shared Library

```bash
ld -shared write-record.o read-record.o -o librecord.so

as write-records.s -o write-records
ld -L . -dynamic-linker /lib/ld-linux.so.2 \
	-o write-records -lrecord write-records.o
```

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
