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
