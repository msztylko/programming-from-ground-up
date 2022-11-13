# High-Level Languages

## C versus Assembly

```C
#include <stdio.h>

int main(int argc, char **argv) {
    puts("Hello World!\n");
    return 0;
}
```

What do we get in C that we have to do manually in Assembly:
 * function arguments without worrying where they are on the stack
 * loading values in and out of registers
 * `main` instead of `_start`
 * funciton calls without the need for pushing arguments onto the stack
