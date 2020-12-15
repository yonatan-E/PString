		.section        .rodata
scanf_format_string:       .string     "%s"
scanf_format_int8:       .string     " %hhd"

		.text

.globl	run_main
		.type run_main, @function
run_main:
		pushq	%rbp
		movq	%rsp, %rbp

		subq	$520, %rsp	# allocation memory for the both strings, and also changing the alignment of %rsp to 16

		leaq	-256(%rbp), %rsi
		movq	$scanf_format_int8, %rdi
		movq	$0, %rax
		call	scanf
		leaq	-255(%rbp), %rsi
		movq	$scanf_format_string, %rdi
		movq	$0, %rax
		call	scanf

		leaq	-512(%rbp), %rsi
		movq	$scanf_format_int8, %rdi
		movq	$0, %rax
		call	scanf
		leaq	-511(%rbp), %rsi
		movq	$scanf_format_string, %rdi
		movq	$0, %rax
		call	scanf

		movq	%rsp, %rsi
		movq	$scanf_format_int8, %rdi
		movq	$0, %rax
		call	scanf

		leaq	-512(%rbp), %rdx
		leaq	-256(%rbp), %rsi
		movsbq	(%rsp), %rdi
		call	run_func

		leave
		ret