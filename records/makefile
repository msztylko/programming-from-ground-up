write_records: write_record.o write_records.o
	ld -m elf_i386 write_record.o write_records.o -o write_records
write_records.o: write_records.s
	as --32 write_records.s -o write_records.o
write_record.o: write_record.s
	as --32 write_record.s -o write_record.o
read_records: read_record.o count_chars.o write_newline.o read_records.o
	ld -m elf_i386 read_record.o count_chars.o write_newline.o read_records.o -o read_records
read_record.o: read_record.s
	as --32 read_record.s -o read_record.o
count_chars.o: count_chars.s
	as --32 count_chars.s -o count_chars.o
write_newline.o: write_newline.s
	as --32 write_newline.s -o write_newline.o
read_records.o: read_records.s
	as --32 read_records.s -o read_records.o
clean:
	rm *.o write_records read_records
