gen_rand_int:
	push 	eax
	push	ebx
	push	ecx
	push	edx
	mov		ecx, eax
	rdtsc

.range_check:
	cmp		eax, 1
	jge		.number_positive
	mov		ebx, -1
	mul		ebx

.number_positive:
	cmp		eax, 1000
	jle		.finished
	xor		edx, edx
	mov		ebx, 10
	div		ebx
	jmp		.range_check

.finished:
	mov		[ecx], eax
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	ret
