        .section        .rodata
invalid_input_str:     .string     "invalid input!\n"
s:      .string     "%c %c\n"
        .text
# this function calculates the length of a given string
.globl  pstrlen
        .type	pstrlen, @function
pstrlen:
        movsbq  (%rdi), %rax
        ret

# this function replaces all of the instances of a given char in a given string with another char
.globl  replaceChar
        .type   replaceChar, @function
replaceChar:
        call    pstrlen
        xorq    %rcx, %rcx
loop_1:
        cmpb    1(%rdi, %rcx, ), %sil
        jne     not_equals
        movb    %dl, 1(%rdi, %rcx, )
not_equals:
        incb    %cl
        cmpb    %cl, %al
        jg      loop_1

        movq    %rdi, %rax
        ret

# this function copies a substring of a given string to another given string
.globl  pstrijcpy
        .type   pstrijcpy, @function
pstrijcpy:
        call    pstrlen
        cmpb    %al, %dl
        jg      index_out_of_range_1
        cmpb    %al,  %cl
        jg      index_out_of_range_1

        pushq   %rdi
        movq    %rsi, %rdi
        call    pstrlen
        popq    %rdi
        cmpb    %al, %dl
        jg      index_out_of_range_1
        cmpb    %al,  %cl
        jg      index_out_of_range_1

        cmpb    %cl, %dl
        jg      done_1
loop_2:
        movb    1(%rsi, %rdx, ), %al
        movb    %al, 1(%rdi, %rdx, )
        incb    %dl
        cmpb    %cl, %dl
        jle     loop_2
done_1:
        movq    %rdi, %rax
        ret
index_out_of_range_1:
        movq    $invalid_input_str, %rdi
        movq    $0, %rax
        call    printf
        jmp     done_1

# this function replaces all of the upper case letters in a given string to normal case 
.globl  swapCase
        .type   swapCase, @function
swapCase:
        call    pstrlen
        xorq    %rcx, %rcx
loop_3:
        movb    1(%rdi, %rcx, ), %dl
        cmpb    $65, %dl
        jl      not_upper_case
        cmpb    $90, %dl
        jg      not_upper_case
        addb    $32, %dl
        movb    %dl, 1(%rdi, %rcx, )
not_upper_case:
        incb    %cl
        cmpb    %cl, %al
        jg      loop_3

        movq    %rdi, %rax
        ret

# this function compares lexicographily between substrings of two given strings
.globl  pstrijcmp
        .type   pstrijcmp, @function
pstrijcmp:
        call    pstrlen
        cmpb    %al, %dl
        jg      index_out_of_range_2
        cmpb    %al,  %cl
        jg      index_out_of_range_2

        pushq   %rdi
        movq    %rsi, %rdi
        call    pstrlen
        popq    %rdi
        cmpb    %al, %dl
        jg      index_out_of_range_2
        cmpb    %al,  %cl
        jg      index_out_of_range_2

        cmpb    %cl, %dl
        jg      done_2
loop_4:
        movb    1(%rsi, %rdx, ), %al
        cmpb    %al, 1(%rdi, %rdx, )
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
