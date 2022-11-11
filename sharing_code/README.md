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

