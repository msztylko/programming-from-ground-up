.include "linux.s"
.include "record-def.s"

.section .data
# Constant data fo the records we want to write
# Each text data item is padded to the proper length with null

# .rept is used to pad each item.  .rep tells the assembler
# to repeat the section between .reprt and .endr the number
# of time specifed. This is used in this program to add extra null
# characters at the end of each field to fill it up

record1:
 .ascii "Fredrick\0"
 .rept 31 # Padding to 40 bytes
 .byte 0
 .endr

 .ascii "Bartlett\0"
 .rept 31 # Padding to 40 bytes
 .byte 0
 .endr

 .ascii "4242 S Prairie\nTulsa, OK 55555\0"
 .rept 209 # Padding to 240 bytes
 .byte 0
 .endr

 .long 45

record2:
 .ascii "Marilyn\0"
 .rept 32 # Padding to 40 bytes
 .byte 0
 .endr

 .ascii "Taylor\0"
 .rept 33 # Padding to 40 bytes
 .byte 0
 .endr

 .ascii "2224 S Johannan St\nChicago, IL 12345\0"
 .rept 203 # Padding to 240 bytes
 .byte 0
 .endr

 .long 29

record3:
 .ascii "Derrick\0"
 .rept 32 # Padding to 40 bytes
 .byte 0
 .endr
 
 .ascii "McIntire\0"
 .rept 31 # Padding to 40 bytes
 .byte 0
 .endr

 .ascii "500 W Oakland\nSan Diego, CA 54321\0"
 .rept 206 # Padding to 240 bytes
 .byte 0
 .endr

 .long 36

file_name:
 .ascii "test.dat\0"

.section .text
.equ ST_FILE_DESCRIPTOR , -4
.globl _start

_start:
 movl %esp, %ebp
 subl $4, %esp  # space for the fd

 # open the file
 movl $SYS_OPEN, %eax
 movl $file_name, %ebx
 movl $0101, %ecx # this says to create if it doesn't exist, and open for writting
 movl $0666, %edx
 int $LINUX_SYSCALL

 movl %eax, ST_FILE_DESCRIPTOR(%ebp) # stor the fd
 
 # write the first record
 pushl ST_FILE_DESCRIPTOR(%ebp)
 pushl $record1
 call write_record
 addl $8, %esp

 # write the second record
 pushl ST_FILE_DESCRIPTOR(%ebp)
 pushl $record2
 call write_record
 addl $8, %esp

 # write the third record
 pushl ST_FILE_DESCRIPTOR(%ebp)
 pushl $record3
 call write_record
 addl $8, %esp

 # close the fd
 movl $SYS_CLOSE, %eax
 movl ST_FILE_DESCRIPTOR(%ebp), %ebx
 int $LINUX_SYSCALL

 # EXIT
 movl $SYS_EXIT, %eax
 movl $0, %ebx
 int $LINUX_SYSCALL  

