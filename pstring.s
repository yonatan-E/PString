            .section        .rodata
invalid_string:     .string         "invalid input!\n"
            
            .text

# this function calculates the length of a given string
            .type	pstrlen, @function
pstrlen:
            movb    (%rdi), %al
            ret

# this function replaces all of the instances of a given char in a given string with another char
            .type replaceChar, @function
replaceChar:
            call    pstrlen
            xorb    %cl, %cl
loop:
            xorb    $1(%rdi, %al, ), %sil
            jne     not_equals
            movb    %dl, $1(%rdi, %al, )
not_equals:
            incb    %cl
            cmpb    %cl, %al
            jg      loop

            movq    %rdi, %rax
            ret

# this function copies a range of a given string to another string
            .type pstrijcpy, @function
pstrijcpy:
            call    pstrlen
            cmpb    %al, %dl
            jg      invalid
            cmpb    %al,  %cl
            jg      invalid

            pushq   %rdi
            movq    %rsi, %rdi
            call    pstrlen
            popq    %rdi
            cmpb    %al, %dl
            jg      invalid
            cmpb    %al,  %cl
            jg      invalid

            cmpb    %cl, %dl
            jg      done
loop:
            movb    $-1(%rsi, %dl, ), $-1(%rdi, %dl, )
            incb    %dl
            cmpb    %cl, %dl
            jle     loop
done:
            movq    %rdi, %rax
            ret
invalid:
            movq    $invalid_string, %rdi
            movq    $0, %rax
            call    printf
            ret

# this function replaces all of the upper case letters in a given string to normal case 
            .type swapCase, @function
swapCase:
            call    pstrlen
            xorb    %sil, %sil
loop:
            movb    $1(%rdi, %sil, ), %dl
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
