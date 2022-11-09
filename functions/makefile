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
my_factorial: my_factorial.o
	ld -m elf_i386 my_factorial.o -o my_factorial
my_factorial.o: my_factorial.s
	as --gstabs --32 my_factorial.s -o my_factorial.o
maximum_function: maximum_function.o
	ld -m elf_i386 maximum_function.o -o maximum_function
maximum_function.o: maximum_function.s
	as --gstabs --32 maximum_function.s -o maximum_function.o
clean:
	rm *.o power my_function factorial my_factorial maximum_function
