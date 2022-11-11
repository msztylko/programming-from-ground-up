helloworld-nolib: helloworld-nolib.o
	ld -m elf_i386 helloworld-nolib.o -o helloworld-nolib
helloworld-nolib.o: helloworld-nolib.s
	as --32 helloworld-nolib.s -o helloworld-nolib.o
clean:
	rm *.o helloworld-nolib
