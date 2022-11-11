# Reading and Writing Simple Records

Persistent data:
1. Structured - has internal structure, is divided up into fields and records.
2. Unstructured - text files etc.

**Database** is basically a program which handles persistent structured data. You don’t
have to write the programs to read and write the data to disk, to do lookups, or even to do
basic processing.

## Common definitions

For working we records we use separate programs for [reading](./read_record.s) and [writing](./write_record.s). We need a way to ensure that definitions of records stay consistent between these programs and for that we can put shared code in a separate file, [record-def.s](./record-def.s):
```assembly
.equ RECORD_FIRSTNAME, 0
.equ RECORD_LASTNAME, 40
.equ RECORD_ADDRESS, 80
.equ RECORD_AGE, 320
.equ RECORD_SIZE, 324
```

Then we can use this file with `.include` directive:
```assembly
.include "record-def.s"
.include "linux.s"
```

## Records

```assembly
.include "linux.s"
.include "record-def.s"

.section .data

record1:
.ascii "Fredrick\0"
.rept 31 # Padding to 40 bytes
.byte 0
.endr

.ascii "Bartlett\0"
.rept 31 # Padding to 40 bytes
.byte 0
.endr

.ascii "4242 S Prairie\nTulsa, OK 55555\0"
.rept 209 # Padding to 240 bytes
.byte 0
.endr

.long 45
```

`.rept` is used to pad each item. It repeats the section between .rept and .endr the number of times specified.

```assembly
.ascii "Fredrick\0"
.rept 31 # Padding to 40 bytes
.byte 0
.endr
```
First name + padding to fill 40 bytes as we assigned them for the first name.

`.long 45` corresponds to age field.

`.include "linux.s"` is a text substition, so contents of "linux.s" will be pasted right there in the code.

We don't need to do similar substitions with functions:  
`ld -m elf_i386 read_record.o count_chars.o write_newline.o read_records.o -o read_records`  
as long as they are defined with `.globl` linker will be able to use them.
