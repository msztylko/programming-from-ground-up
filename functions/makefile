power: power.o
	ld -m elf_i386 power.o -o power
power.o: power.s
	as --32 power.s -o power.o
my_function: my_function.o
	ld -m elf_i386 my_function.o -o my_function
my_function.o: my_function.s
	as --32 my_function.s -o my_function.o
factorial: factorial.o
	ld -m elf_i386 factorial.o -o factorial
factorial.o: factorial.s
	as --32 factorial.s -o factorial.o
clean:
	rm *.o power my_function
