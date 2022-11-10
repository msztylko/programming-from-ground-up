write_records: write_record.o write_records.o
	ld -m elf_i386 write_record.o write_records.o -o write_records
write_records.o: write_records.s
	as --32 write_records.s -o write_records.o
write_record.o: write_record.s
	as --32 write_record.s -o write_record.o
