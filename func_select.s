        .section        .rodata
l0_str:     .string     "first pstring length: %d, second pstring length: %d\n"
l2_str:     .string     "old char: %c, new char: %c, first string: %s, second string: %s\n"
l3_str:     .string     "length: %d, string: %s\n"
l5_str:     .string     "compare result: %d\n"
invalid_option_str:     .string     "invalid option!\n"
scanf_format_char:       .string     " %c"
scanf_format_int8:       .string     " %hhd"
        .align      8
.L10:
        .quad       .L0
        .quad       .L6
        .quad       .L2
        .quad       .L3
        .quad       .L4
        .quad       .L5
        .quad       .L6
        .quad       .L6
        .quad       .L6
        .quad       .L6
        .quad       .L0

        .text
# this function calls a specific function according to the input
        .globl  run_func
        .type   run_func, @function
run_func:
        pushq   %rbp
        movq    %rsp, %rbp

        leaq    -50(%rdi), %rcx
        cmpq    $10, %rcx
        jg      .L6
        jmp     *.L10(, %rcx, 8)
.L0:
        subq    $2, %rsp

        movq    %rsi, %rdi
        call    pstrlen
        movb    %al, 1(%rsp)

        movq    %rdx, %rdi
        call    pstrlen
        movb    %al, (%rsp)

        movsbq  (%rsp), %rdx
        movsbq  1(%rsp), %rsi
        movq    $l0_str, %rdi
        movq    $0, %rax
        call    printf
        
        jmp done
.L2:    
        subq    $16, %rsp

        pushq   %rbx
        pushq   %r12

        movq    %rsi, %rbx
        movq    %rdx, %r12

        leaq    -1(%rbp), %rsi
        movq    $scanf_format_char, %rdi
        movq    $0, %rax
        call    scanf
        leaq    -2(%rbp), %rsi
        movq    $scanf_format_char, %rdi
        movq    $0, %rax
        call    scanf

        movsbq  -2(%rbp), %rdx
        movsbq  -1(%rbp), %rsi
        movq    %rbx, %rdi
        call    replaceChar
        movq    %rax, %rbx

        movsbq  -2(%rbp), %rdx
        movsbq  -1(%rbp), %rsi
        movq    %r12, %rdi
        call    replaceChar
        movq    %rax, %r12

        movq    %r12, %r8
        movq    %rbx, %rcx
        movsbq  -2(%rbp), %rdx
        movsbq  -1(%rbp), %rsi
        movq    $l2_str, %rdi
        movq    $0, %rax
        call printf

        popq    %r12
        popq    %rbx
        
        jmp done
.L3:
        subq    $16, %rsp

        pushq   %rbx
        pushq   %r12

        movq    %rsi, %rbx
        movq    %rdx, %r12

        leaq    -1(%rbp), %rsi
        movq    $scanf_format_int8, %rdi
        movq    $0, %rax
        call    scanf
        leaq    -2(%rbp), %rsi
        movq    $scanf_format_int8, %rdi
        movq    $0, %rax
        call    scanf

        movsbq  -2(%rbp), %rcx
        movsbq  -1(%rbp), %rdx
        movq    %r12, %rsi
        movq    %rbx, %rdi
        call    pstrijcpy
        movq    %rax, %rbx

        movq    %rbx, %rdi
        call    pstrlen
        movq    %rbx, %rdx
        movq    %rax, %rsi
        movq    $l3_str, %rdi
        movq    $0, %rax
        call printf

        movq    %r12, %rdi
        call    pstrlen
        movq    %r12, %rdx
        movq    %rax, %rsi
        movq    $l3_str, %rdi
        movq    $0, %rax
        call printf

        popq    %r12
        popq    %rbx
        
        jmp done
.L4:
        pushq   %rbx
        pushq   %r12

        movq    %rsi, %rbx
        movq    %rdx, %r12

        movq    %rbx, %rdi
        call    swapCase
        movq    %rax, %rbx
        movq    %r12, %rdi
        call    swapCase
        movq    %rax, %r12

        movq    %rbx, %rdi
        call    pstrlen
        movq    %rbx, %rdx
        movq    %rax, %rsi
        movq    $l3_str, %rdi
        movq    $0, %rax
        call printf

        movq    %r12, %rdi
        call    pstrlen
        movq    %r12, %rdx
        movq    %rax, %rsi
        movq    $l3_str, %rdi
        movq    $0, %rax
        call printf

        popq    %r12
        popq    %rbx

        jmp done
.L5:
        subq    $16, %rsp

        pushq   %rsi
        pushq   %rdx

        leaq    -1(%rbp), %rsi
        movq    $scanf_format_int8, %rdi
        movq    $0, %rax
        call    scanf
        leaq    -2(%rbp), %rsi
        movq    $scanf_format_int8, %rdi
        movq    $0, %rax
        call    scanf

        movsbq  -2(%rbp), %rcx
        movsbq  -1(%rbp), %rdx
        popq    %rsi
        popq    %rdi
        call    pstrijcmp

        movq    %rax, %rsi
        movq    $l5_str, %rdi
        movq    $0, %rax
        call    printf

        jmp done
.L6:
        movq    $invalid_option_str, %rdi
        movq    $0, %rax
        call    printf
done:
        leave
        ret
