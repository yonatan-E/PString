		.section        .rodata
scanf_format_string:       .string     "%s"
scanf_format_int8:       .string     " %hhd"

		.text
# this function scans two pstrings and an option number, and calls run_func with those arguments.
.globl	run_main
		.type run_main, @function
run_main:
		# saving the old %rbp
		pushq	%rbp
		# setting %rbp to the start of the current stack frame
		movq	%rsp, %rbp

		# allocation memory for the both pstrings
		leaq	-512(%rsp), %rsp

		# scaning the length and the content of the first pstring
		leaq	-256(%rbp), %rsi
		movq	$scanf_format_int8, %rdi
		movq	$0, %rax
		call	scanf
		leaq	-255(%rbp), %rsi
		movq	$scanf_format_string, %rdi
		movq	$0, %rax
		call	scanf

		# scaning the length and the content of the second pstring
		leaq	-512(%rbp), %rsi
		movq	$scanf_format_int8, %rdi
		movq	$0, %rax
		call	scanf
		leaq	-511(%rbp), %rsi
		movq	$scanf_format_string, %rdi
		movq	$0, %rax
		call	scanf

		# allocating memory for the option variable, while keeping the alignment of %rsp to be 16
		leaq	-16(%rsp), %rsp

		# scaning the number of the option
		movq	%rsp, %rsi
		movq	$scanf_format_int8, %rdi
		movq	$0, %rax
		call	scanf

		# calling run_func with the scanned option number and pstrings
		leaq	-512(%rbp), %rdx
		leaq	-256(%rbp), %rsi
		movzbq	(%rsp), %rdi
		call	run_func

		# deallocating the memory of the current stack frame and restoring the previous %rbp
		leave
		ret
