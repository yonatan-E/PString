        .section        .rodata
invalid_input_str:     .string     "invalid input!\n"
            
        .text
# this function calculates the length of a given string
        .type	pstrlen, @function
pstrlen:
        movsbq  (%rdi), %rax
        ret

# this function replaces all of the instances of a given char in a given string with another char
        .type   replaceChar, @function
replaceChar:
        call    pstrlen
        xorb    %cl, %cl
loop_1:
        xorb    1(%rdi, %rax, ), %sil
        jne     not_equals
        movb    %dl, 1(%rdi, %rax, )
not_equals:
        incb    %cl
        cmpb    %cl, %al
        jg      loop_1

        movq    %rdi, %rax
        ret

# this function copies a substring of a given string to another given string
        .type   pstrijcpy, @function
pstrijcpy:
        movq    %rdi, %r8
        movq    %rsi, %r9

        call    pstrlen
        cmpb    %al, %dl
        jg      index_out_of_range_1
        cmpb    %al,  %cl
        jg      index_out_of_range_1

        movq    %rsi, %rdi
        call    pstrlen
        cmpb    %al, %dl
        jg      index_out_of_range_1
        cmpb    %al,  %cl
        jg      index_out_of_range_1

        cmpb    %cl, %dl
        jg      done_1
loop_2:
        movb    1(%r9, %rdx, ), %dil
        movb    %dil, 1(%r8, %rdx, )
        incb    %dl
        cmpb    %cl, %dl
        jle     loop_2
done_1:
        movq    %r8, %rax
        ret
index_out_of_range_1:
        movq    $invalid_input_str, %rdi
        movq    $0, %rax
        call    printf
        jmp     done_1

# this function replaces all of the upper case letters in a given string to normal case 
        .type   swapCase, @function
swapCase:
        call    pstrlen
        xorb    %sil, %sil
loop_3:
        movb    1(%rdi, %rsi, ), %dl
        cmpb    $65, %dl
        jl      not_upper_case
        cmpb    $90, %dl
        jg      not_upper_case
        addb    $32, %dl
        movb    %dl, 1(%rdi, %rsi, )
not_upper_case:
        incb    %sil
        cmpb    %sil, %al
        jg      loop_3

        movq    %rdi, %rax
        ret

# this function compares lexicographily between substrings of two given strings 
        .type   pstrijcmp, @function
pstrijcmp:
        movq    %rdi, %r8
        movq    %rsi, %r9

        call    pstrlen
        cmpb    %al, %dl
        jg      index_out_of_range_2
        cmpb    %al,  %cl
        jg      index_out_of_range_2

        movq    %rsi, %rdi
        call    pstrlen
        cmpb    %al, %dl
        jg      index_out_of_range_2
        cmpb    %al,  %cl
        jg      index_out_of_range_2

        cmpb    %cl, %dl
        jg      done_2
loop_4:
        movb    1(%r9, %rdx, ), %dil
        cmpb    %dil, 1(%r8, %rdx, )
        jg      s1_is_greater
        jl      s2_is_greater

        incb    %dl
        cmpb    %cl, %dl
        jle     loop_4
done_2:
        movq    $0, %rax
        ret
s1_is_greater:
        movq    $1, %rax
        ret
s2_is_greater:
        movq    $-1, %rax
        ret
index_out_of_range_2:
        movq    $invalid_input_str, %rdi
        movq    $0, %rax
        call    printf
        movq    $-2, %rax
        ret
