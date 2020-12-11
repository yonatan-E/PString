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
loop:
        xorb    $1(%rdi, %al, ), %sil
        jne     not_equals
        movb    %dl, 1(%rdi, %al, )
not_equals:
        incb    %cl
        cmpb    %cl, %al
        jg      loop

        movq    %rdi, %rax
        ret

# this function copies a substring of a given string to another given string
        .type   pstrijcpy, @function
pstrijcpy:
        call    pstrlen
        cmpb    %al, %dl
        jg      index_out_of_range
        cmpb    %al,  %cl
        jg      index_out_of_range

        pushq   %rdi
        movq    %rsi, %rdi
        call    pstrlen
        popq    %rdi
        cmpb    %al, %dl
        jg      index_out_of_range
        cmpb    %al,  %cl
        jg      index_out_of_range

        cmpb    %cl, %dl
        jg      done
loop:
        movb    1(%rsi, %dl, ), 1(%rdi, %dl, )
        incb    %dl
        cmpb    %cl, %dl
        jle     loop
done:
        movq    %rdi, %rax
        ret
index_out_of_range:
        movq    $invalid_input_str, %rdi
        movq    $0, %rax
        call    printf
        jmp     done

# this function replaces all of the upper case letters in a given string to normal case 
        .type   swapCase, @function
swapCase:
        call    pstrlen
        xorb    %sil, %sil
loop:
        movb    1(%rdi, %sil, ), %dl
        cmpb    %dl, $65
        jg      not_upper_case
        cmpb    $90, %dl
        jg      not_upper_case
        addb    $32, %dl
        movb    %dl, $1(%rdi, %sil, )
not_upper_case:
        incb    %sil
        cmpb    %sil, %al
        jg      loop

        movq    %rdi, %rax
        ret

# this function compares lexicographily between substrings of two given strings 
        .type   pstrijcmp, @function
pstrijcmp:
        call    pstrlen
        cmpb    %al, %dl
        jg      index_out_of_range
        cmpb    %al,  %cl
        jg      index_out_of_range

        pushq   %rdi
        movq    %rsi, %rdi
        call    pstrlen
        popq    %rdi
        cmpb    %al, %dl
        jg      index_out_of_range
        cmpb    %al,  %cl
        jg      index_out_of_range

        cmpb    %cl, %dl
        jg      done
loop:
        cmpb    1(%rsi, %dl, ), 1(%rdi, %dl, )
        jg      s1_is_greater
        jl      s2_is_greater

        incb    %dl
        cmpb    %cl, %dl
        jle     loop
done:
        movq    $0, %rax
        ret
s1_is_greater:
        movq    $1, %rax
        ret
s1_is_greater:
        movq    $-1, %rax
        ret
index_out_of_range:
        movq    $invalid_input_str, %rdi
        movq    $0, %rax
        call    printf
        movq    $-2, %rax
        ret
