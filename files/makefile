toupper: toupper.o
	ld -m elf_i386 toupper.o -o toupper
toupper.o: toupper.s
	as --32 toupper.s -o toupper.o
clean:
	rm *.o toupper
