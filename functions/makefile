power: power.o
	ld -m elf_i386 power.o -o power
power.o: power.s
	as --32 power.s -o power.o
clean:
	rm *.o power
