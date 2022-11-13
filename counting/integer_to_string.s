# PURPOSE: Convert an integer number to a decimal string for display

# INPUT: A buffer large enough to hold the largest possible number
#        An integer to convert
#
# OUTPUT: The buffer will be overwritten with the decimal string
# 
# Variables:
# 
# %ecx will hold the count of characters processed
# %eax will hold the current value
# %edi will hold the base(10)
# 
.equ ST_VALUE, 8
.equ ST_BUFFER, 12

.globl integer2string
.type integer2string, @function

integer2string:
    pushl %ebp
    movl %esp, %ebp
    
    movl $0, %ecx               # current character count
    movl ST_VALUE(%ebp), %eax   # move the value into position

    # when we divide by 10, the 10 must be in a register or memory location
    movl $10, %edi

conversion_loop:
    # division is actually performed on the combined %edx:%eax register,
    # so first clear out %edx
    movl $0, %edx

    # divide %edx:%eax (which are implied) by 10. Store the quotient in
    # %eax and the remainder in %edx (both of which are implied).
    divl %edi

    # Quotient is in the right place. %edx has the remainder, which now needs to
    # be converted into a number. So, %edx has a number that is 0 through 9
    # You couldbalso interpret this as an index on the ASCII table starting from
    # the character '0'. The ascii code for '0' plus zero is still the ascii
    # code for '0'. The ascii code for '0' plus 1 is the ascii doe for the 
    # character '1'. Therefore, the following instruction will give us the 
    # character for the number stored in %edx
    addl $'0', %edx

    # Now we will take this value and push it on the stack. This way, when we
    # are done, we can just pop off the characters one-by-one and they will
    # be in the right order. Note that we are pushing the whole register, but
    # we only need the byte in %dl (the last byte of the %edx register)
    # for the character.
    pushl %edx

    incl %ecx               # increment the digit count

    # Check to see fi %eax is zero yet, go to next step if so
    cmpl $0, %eax
    je end_conversion_loop

    # %eax already has its new value

    jmp conversion_loop

end_conversion_loop:
    # The string is now on the stack, if we pop it off a character at a time
    # we can copy it into the buffer adn be done.

    movl ST_BUFFER(%ebp), %edx  # get the pointer to the buffer in %edx

copy_reversing_loop:
    # We pushed a whole register, but we only need the last byte. So we are going to
    # pop off to the entire %eax register, but then only move the small part (%al) 
    # into the character string.
    popl %eax
    movb %al, (%edx)

    decl %ecx   # decreasing %ecx so we know when we are finished
    # increasing %edx so that it will be pointing to the next byte
    incl %edx

    # check to see if we are finished
    cmpl $0, %ecx
    # if so, jump to the end of the function
    je end_copy_reversing_loop
    # otherwise, repeat the loop
    jmp copy_reversing_loop

end_copy_reversing_loop:
    # done copying. Now write a null byte and return
    movb $0, (%edx)

    movl %ebp, %esp
    popl %ebp
    ret
