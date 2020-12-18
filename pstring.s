        .section        .rodata
invalid_input_str:     .string     "invalid input!\n"

        .text
# this function gets the length of a given pstring.
# params:
# %rdi holds the address of the pstring
# return val:
# %rax holds the length of the pstring
.globl  pstrlen
        .type	pstrlen, @function
pstrlen:
        # setting the return value to be the length of the pstring. the length of the pstring is located at the first byte of the pstring
        movzbq  (%rdi), %rax
        ret

# this function replaces all of the instances of a given char in a given pstring with another char.
# params:
# %rdi holds the address of the pstring
# %rsi holds the old char
# %rdx holds the new char
# return val:
# %rax holds the address of the pstring
.globl  replaceChar
        .type   replaceChar, @function
replaceChar:
        # getting the length of the pstring
        call    pstrlen
        # %rcx holds the iterated index
        xorq    %rcx, %rcx
loop_1:
        # checking if the char at the current place is the old char
        cmpb    1(%rdi, %rcx, ), %sil
        jne     not_equals
        # if the char at the current place is the old char, then overriding it with the new char
        movb    %dl, 1(%rdi, %rcx, )
not_equals:
        # incrementing the index and checking if the end of pstring has been reached
        incb    %cl
        cmpb    %cl, %al
        ja      loop_1
        # setting the return value to be the address of the pstring
        movq    %rdi, %rax
        ret

# this function copies a substring of a given pstring to another given pstring.
# params:
# %rdi holds the address of the destination pstring
# %rsi holds the address of the source pstring
# %rdx holds the first index of the substring
# %rcx holds the last index of the substring
# return val:
# %rax holds the address of the destination pstring
.globl  pstrijcpy
        .type   pstrijcpy, @function
pstrijcpy:
        # saving the old %rbx
        pushq   %rbx
        # saving %rdi at %rbx
        movq    %rdi, %rbx

        # checking if the given indices are in the range of the destination pstring
        call    pstrlen
        cmpb    %al, %dl
        jae      index_out_of_range_1
        cmpb    %al,  %cl
        jae      index_out_of_range_1

        # checking if the given indices are in the range of the source pstring
        movq    %rsi, %rdi
        call    pstrlen
        cmpb    %al, %dl
        jae      index_out_of_range_1
        cmpb    %al,  %cl
        jae      index_out_of_range_1

        cmpb    %cl, %dl
        ja      done_1
loop_2:
        # copying the char at the current place at the source pstring to the same place at the destination pstring
        movb    1(%rsi, %rdx, ), %al
        movb    %al, 1(%rbx, %rdx, )
        # incrementing the index and checking if the end of the pstring has been reached
        incb    %dl
        cmpb    %cl, %dl
        jbe     loop_2
done_1:
        # setting the return value to be the address of the pstring
        movq    %rbx, %rax
        # restoring the old %rbx
        popq    %rbx
        ret
index_out_of_range_1:
        # printing an error message
        movq    $invalid_input_str, %rdi
        movq    $0, %rax
        call    printf
        jmp     done_1

# this function replaces all of the upper case letters in a given pstring to normal case letters.
# params:
# %rdi holds the address of the pstring
# return val:
# %rax holds the address of the pstring
.globl  swapCase
        .type   swapCase, @function
swapCase:
        # getting the length of the pstring
        call    pstrlen
        # %rcx holds the iterated index
        xorq    %rcx, %rcx
loop_3:
        # checking if the char at the current place is an upper case letter
        movb    1(%rdi, %rcx, ), %dl
        cmpb    $65, %dl
        jl      not_upper_case
        cmpb    $90, %dl
        jg      not_upper_case
        # if the char at the current place is an upper case letter, then overriding it with a normal case letter
        addb    $32, %dl
        movb    %dl, 1(%rdi, %rcx, )
not_upper_case:
        # incrementing the index and checking if the end of the pstring has been reached
        incb    %cl
        cmpb    %cl, %al
        ja      loop_3
        # setting the return value to be the address of the pstring
        movq    %rdi, %rax
        ret

# this function compares lexicographily between substrings of two given pstrings.
# params:
# %rdi holds the address of the first pstring
# %rsi holds the address of the second pstring
# %rdx holds the first index of the substrings
# %rcx holds the last index of the substrings
# return val:
# %rax holds 0 if the pstring are equal, 1 if the first pstring is bigger, -1 if the second pstring is bigger, and -2 if an error has occured
.globl  pstrijcmp
        .type   pstrijcmp, @function
pstrijcmp:
        # saving the old %rbx
        pushq   %rbx
        # saving %rdi at %rbx
        movq    %rdi, %rbx

        # checking if the given indices are in the range of the first pstring
        call    pstrlen
        cmpb    %al, %dl
        jae     index_out_of_range_2
        cmpb    %al,  %cl
        jae      index_out_of_range_2

        # checking if the given indices are in the range of the second pstring
        movq    %rsi, %rdi
        call    pstrlen
        cmpb    %al, %dl
        jae      index_out_of_range_2
        cmpb    %al,  %cl
        jae      index_out_of_range_2

        cmpb    %cl, %dl
        ja      equals
loop_4:
        # comparing between the char at the current place in the first pstring and in the second pstring
        movb    1(%rsi, %rdx, ), %al
        cmpb    %al, 1(%rbx, %rdx, )
        jg      s1_is_greater
        jl      s2_is_greater
        # incrementing the index and checking if the end of the pstring has been reached
        incb    %dl
        cmpb    %cl, %dl
        jbe     loop_4
equals:
        # if equals, then setting the return value to be 0
        movq    $0, %rax
        jmp     done_2
s1_is_greater:
        # if the first is bigger, then setting the return value to be 1
        movq    $1, %rax
        jmp     done_2
s2_is_greater:
        # if the second is bigger, then setting the return value to be -1
        movq    $-1, %rax
        jmp     done_2
index_out_of_range_2:
        # printing an error message
        movq    $invalid_input_str, %rdi
        movq    $0, %rax
        call    printf
        # if an error has occured, then setting the return value to be -2
        movq    $-2, %rax
done_2:
        # restoring the old %rbx
        popq    %rbx
        ret
