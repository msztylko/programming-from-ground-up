# NOTE - assume that the register %ebx holds
#        my dad's preferences

movl %ebx, %eax # This copies the information into %eax so
                # we don't lose the original data
shrl $1, %eax   # This is the shift ooperator. It stands
                # for Shift Right Long. This first number
                # is the number of postions to shift, 
                # and the second is the register to shift

# This does the masking
andl  $0b00000000000000000000000000000001, %eax

# check to see if the result is 1 or 0
cmpl  $0b00000000000000000000000000000001, %eax

je  yes_he_likes_dressy_clothes

jmp no_he_doesnt_like_dressy_clothes
