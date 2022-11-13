# Counting Like a Computer

Basic information about binary system

### XOR trick

Processors execute different instructions as different speed. XOR operation is faster than the loading operation and this fact is used for loading register with zero:

```assembly
movl $0, %eax
```
is often replaced by
```assembly
xorl %eax, %eax
```
