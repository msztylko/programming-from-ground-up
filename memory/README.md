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


