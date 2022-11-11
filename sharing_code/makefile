helloworld-nolib: helloworld-nolib.o
	ld helloworld-nolib.o -o helloworld-nolib
helloworld-nolib.o: helloworld-nolib.s
	as helloworld-nolib.s -o helloworld-nolib.o
helloworld-lib32: helloworld-lib32.o
	ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 helloworld-lib32.o -lc -o helloworld-lib32
helloworld-lib32.o: helloworld-lib32.s
	as --32 helloworld-lib32.s -o helloworld-lib32.o
clean:
	rm *.o helloworld-nolib helloworld-lib32
