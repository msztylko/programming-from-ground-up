helloworld-nolib: helloworld-nolib.o
	ld helloworld-nolib.o -o helloworld-nolib
helloworld-nolib.o: helloworld-nolib.s
	as helloworld-nolib.s -o helloworld-nolib.o
helloworld-lib: helloworld-lib.o
	ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 \
		-o helloworld-lib helloworld-lib.o -lc
helloworld-lib.o: helloworld-lib.s
	as --32 helloworld-lib.s -o helloworld-lib.o
clean:
	rm *.o helloworld-nolib
