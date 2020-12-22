        # 213192875 Yonatan Ehrenreich

        .section        .rodata
l0_str:     .string     "first pstring length: %d, second pstring length: %d\n"
l2_str:     .string     "old char: %c, new char: %c, first string: %s, second string: %s\n"
l3_str:     .string     "length: %d, string: %s\n"
l5_str:     .string     "compare result: %d\n"
invalid_option_str:     .string     "invalid option!\n"
scanf_format_two_chars:       .string     " %c %c"
scanf_format_int8:       .string     " %hhd"
        .align      8
# the jump table for the switch-case
.L10:
        .quad       .L0         # case 50
        .quad       .L6         # case 51 - invalid
        .quad       .L2         # case 52
        .quad       .L3         # case 53
        .quad       .L4         # case 54
        .quad       .L5         # case 55
        .quad       .L6         # case 56 - invalid
        .quad       .L6         # case 57 - invalid
        .quad       .L6         # case 58 - invalid
        .quad       .L6         # case 59 - invalid
        .quad       .L0         # case 60

        .text
# this function calls a specific pstring function according to the input.
# params:
# %rdi holds the number of the option
# %rsi holds the address of the first pstring
# %rdx holds the address of the second pstring
.globl  run_func
        .type   run_func, @function
run_func:
        # saving the old %rbp
        pushq   %rbp
        # setting %rbp to the start of the current stack frame
        movq    %rsp, %rbp

        # jumping to a label according to the option number, using the jump table
        leaq    -50(%rdi), %rcx
        cmpq    $10, %rcx
        ja      .L6
        jmp     *.L10(, %rcx, 8)
.L0:
        # allocating memory on the stack
        leaq    -2(%rsp), %rsp

        # getting the length of the first pstring
        movq    %rsi, %rdi
        call    pstrlen
        movb    %al, 1(%rsp)
        # getting the length of the second pstring
        movq    %rdx, %rdi
        call    pstrlen
        movb    %al, (%rsp)

        # printing "first pstring length: %d, second pstring length: %d\n"
        movzbq  (%rsp), %rdx
        movzbq  1(%rsp), %rsi
        movq    $l0_str, %rdi
        movq    $0, %rax
        call    printf
        
        jmp done
.L2:    
        # allocating memory on the stack, while keeping the alignment of %rsp to be 16
        leaq    -16(%rsp), %rsp

        # saving the old %rbx and %r12
        pushq   %rbx
        pushq   %r12
        # saving %rsi at %rbx, and %rdx at %r12
        movq    %rsi, %rbx
        movq    %rdx, %r12

        # scanning the old char and the new char
        leaq    -2(%rbp), %rdx
        leaq    -1(%rbp), %rsi
        movq    $scanf_format_two_chars, %rdi
        movq    $0, %rax
        call    scanf

        # calling replaceChar with the first pstring, and with the scanned old char and new char
        movsbq  -2(%rbp), %rdx
        movsbq  -1(%rbp), %rsi
        movq    %rbx, %rdi
        call    replaceChar
        movq    %rax, %rbx
        # calling replaceChar with the second pstring, and with the scanned old char and new char
        movsbq  -2(%rbp), %rdx
        movsbq  -1(%rbp), %rsi
        movq    %r12, %rdi
        call    replaceChar
        movq    %rax, %r12

        # printing "old char: %c, new char: %c, first string: %s, second string: %s\n"
        leaq    1(%r12), %r8
        leaq    1(%rbx), %rcx
        movsbq  -2(%rbp), %rdx
        movsbq  -1(%rbp), %rsi
        movq    $l2_str, %rdi
        movq    $0, %rax
        call    printf

        # restoring the old %r12 and %rbx
        popq    %r12
        popq    %rbx
        
        jmp     done
.L3:
        # allocating memory on the stack, while keeping the alignment of %rsp to be 16
        leaq    -16(%rsp), %rsp

        # saving the old %rbx and %r12
        pushq   %rbx
        pushq   %r12
        # saving %rsi at %rbx, and %rdx at %r12
        movq    %rsi, %rbx
        movq    %rdx, %r12

        # scanning the first index and the last index of the substring
        leaq    -1(%rbp), %rsi
        movq    $scanf_format_int8, %rdi
        movq    $0, %rax
        call    scanf
        leaq    -2(%rbp), %rsi
        movq    $scanf_format_int8, %rdi
        movq    $0, %rax
        call    scanf

        # calling pstrijcpy with the first pstring as the destination, the second pstring as the source, and with the scanned indices
        movzbq  -2(%rbp), %rcx
        movzbq  -1(%rbp), %rdx
        movq    %r12, %rsi
        movq    %rbx, %rdi
        call    pstrijcpy
        movq    %rax, %rbx

        # printing "length: %d, string: %s\n" for the first pstring
        movq    %rbx, %rdi
        call    pstrlen
        leaq    1(%rbx), %rdx
        movq    %rax, %rsi
        movq    $l3_str, %rdi
        movq    $0, %rax
        call    printf
        # printing "length: %d, string: %s\n" for the second pstring
        movq    %r12, %rdi
        call    pstrlen
        leaq    1(%r12), %rdx
        movq    %rax, %rsi
        movq    $l3_str, %rdi
        movq    $0, %rax
        call    printf

        # restoring the old %r12 and %rbx
        popq    %r12
        popq    %rbx
        
        jmp     done
.L4:
        # saving the old %rbx and %r12
        pushq   %rbx
        pushq   %r12
        # saving %rsi at %rbx, and %rdx at %r12
        movq    %rsi, %rbx
        movq    %rdx, %r12

        # calling swapCase with the first pstring
        movq    %rbx, %rdi
        call    swapCase
        movq    %rax, %rbx
        # calling swapCase with the second pstring
        movq    %r12, %rdi
        call    swapCase
        movq    %rax, %r12

        # printing "length: %d, string: %s\n" for the first pstring
        movq    %rbx, %rdi
        call    pstrlen
        leaq    1(%rbx), %rdx
        movq    %rax, %rsi
        movq    $l3_str, %rdi
        movq    $0, %rax
        call    printf
        # printing "length: %d, string: %s\n" for the second pstring
        movq    %r12, %rdi
        call    pstrlen
        leaq    1(%r12), %rdx
        movq    %rax, %rsi
        movq    $l3_str, %rdi
        movq    $0, %rax
        call    printf

        # restoring the old %r12 and %rbx
        popq    %r12
        popq    %rbx

        jmp     done
.L5:
        # allocating memory on the stack, while keeping the alignment of %rsp to be 16
        leaq    -16(%rsp), %rsp

        # saving %rsi and %rdx on the stack
        pushq   %rsi
        pushq   %rdx

        # scanning the first index and the last index of the substrings
        leaq    -1(%rbp), %rsi
        movq    $scanf_format_int8, %rdi
        movq    $0, %rax
        call    scanf
        leaq    -2(%rbp), %rsi
        movq    $scanf_format_int8, %rdi
        movq    $0, %rax
        call    scanf

        # calling pstrijcmp with the first pstring, the second pstring, and the scanned indices
        movzbq  -2(%rbp), %rcx
        movzbq  -1(%rbp), %rdx
        popq    %rsi
        popq    %rdi
        call    pstrijcmp

        # printing "compare result: %d\n"
        movq    %rax, %rsi
        movq    $l5_str, %rdi
        movq    $0, %rax
        call    printf

        jmp     done
.L6:
        # printing an error message
        movq    $invalid_option_str, %rdi
        movq    $0, %rax
        call    printf
done:
        # deallocating the memory of the current stack frame and restoring the previous %rbp
        leave
        ret
