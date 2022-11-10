toupper: toupper.o
	ld -m elf_i386 toupper.o -o toupper
toupper.o: toupper.s
	as --32 toupper.s -o toupper.o
tolower: tolower.o
	ld -m elf_i386 tolower.o -o tolower
tolower.o: tolower.s
	as --32 tolower.s -o tolower.o
clean:
	rm *.o toupper tolower
