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
