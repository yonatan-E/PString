        .section        .rodata
        .align      8
l0_str:     .string     "first pstring length: %d, second pstring length: %d\n"
l2_str:     .string     "old char: %c, new char: %c, first string: %s, second string: %s\n"
l3_str:     .string     "length: %d, string: %s\n"
l5_str:     .string     "compare result: %d\n"
invalid_option_str:     .string     "invalid option!\n"
scanf_format:       .string     "%d"
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
        leaq    -50(%rdi), %rcx
        cmpq    $10, %rcx
        jg      .L6
        jmp     *.L10(, %rcx, 8)
.L0:
        leaq    -2(%rsp), %rsp

        movq    %rsi, %rdi
        call    pstrlen
        movb    %al, 1(%rsp)

        movq    %rdx, %rdi
        call    pstrlen
        movb    %al, (%rsp)

        movsbq  (%rsp), %rdx
        movsbq  1(%rsp), %rsi
        leaq    2(%rsp), %rsp
        movq    $l0_str, %rdi
        movq    $0, %rax
        call    printf

        ret
.L2:    
        pushq   %rbx
        pushq   %r12
        movq    %rsi, %rbx
        movq    %rdx, %r12
        subq    $2, %rsp

        leaq    1(%rsp), %rsi
        movq    $scanf_format, %rdi
        movq    $0, %rax
        call    scanf
        movq    %rsp, %rsi
        movq    $scanf_format, %rdi
        movq    $0, %rax
        call    scanf

        movsbq  (%rsp), %rdx
        movsbq  1(%rsp), %rsi
        movq    %rbx, %rdi
        call    replaceChar
        movq    %rax, %rbx

        movsbq  (%rsp), %rdx
        movsbq  1(%rsp), %rsi
        movq    %r12, %rdi
        call    replaceChar
        movq    %rax, %r12

        movq    %r12, %rcx
        movq    %rbx, %rdx
        movsbq  (%rsp), %rsi
        movsbq  1(%rsp), %rdi
        movq    $0, %rax
        call printf

        addq    $2, %rsp
        popq    %r12
        popq    %rbx

        ret
.L3:
        pushq   %rbx
        pushq   %r12
        movq    %rsi, %rbx
        movq    %rdx, %r12
        leaq    -2(%rsp), %rsp

        leaq    1(%rsp), %rsi
        movq    $scanf_format, %rdi
        movq    $0, %rax
        call    scanf
        movq    %rsp, %rsi
        movq    $scanf_format, %rdi
        movq    $0, %rax
        call    scanf

        movsbq  (%rsp), %rcx
        movsbq  1(%rsp), %rdx
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

        leaq    2(%rsp), %rsp
        popq    %r12
        popq    %rbx

        ret
.L4:
        movq    %rsi, %rdi
        call    swapCase
        pushq   %rax
        movq    %rdx, %rdi
        call    swapCase
        pushq   %rax

        movq    8(%rsp), %rdi
        call    pstrlen
        movq    8(%rsp), %rdx
        movq    %rax, %rsi
        movq    $l3_str, %rdi
        movq    $0, %rax
        call printf

        movq    (%rsp), %rdi
        call    pstrlen
        movq    (%rsp), %rdx
        movq    %rax, %rsi
        movq    $l3_str, %rdi
        movq    $0, %rax
        call printf

        leaq    16(%rsp), %rsp

        ret
.L5:
        pushq   %rsi
        pushq   %rdx
        leaq    -2(%rsp), %rsp

        leaq    1(%rsp), %rsi
        movq    $scanf_format, %rdi
        movq    $0, %rax
        call    scanf
        movq    %rsp, %rsi
        movq    $scanf_format, %rdi
        movq    $0, %rax
        call    scanf

        movsbq  (%rsp), %rcx
        movsbq  1(%rsp), %rdx
        leaq    2(%rsp), %rsp
        popq    %rsi
        popq    %rdi
        call    pstrijcmp

        movq    %rax, %rsi
        movq    $l5_str, %rdi
        movq    $0, %rax
        call    printf

        ret
.L6:
        movq    $invalid_option_str, %rdi
        movq    $0, %rax
        call    printf
        