; Number guessing game

%include		'functions.asm'
%include		'random.asm'

SECTION .data
msg_intro		db		'Tervetuloa Selema-numeronarvauspeliin!', 0h
msgPrompt		db		'Syötä luku välillä 1-1000: ', 0h
msgLeft 		db		'Arvauksia jäljellä: ', 0h
msg_smaller		db		'Oikea vastaus on pienempi.', 0h
msg_bigger		db		'Oikea vastaus on isompi.', 0h
msg_game_over	db		'Peli loppui. Oikea vastaus olisi ollut: ', 0h
msg_hooraa		db		'******************************', 0h
msg_win			db		'Arvasit oikein! Onneksi olkoon! ', 0h
msg_empty		db		'', 0h
try				dd		0	
secret_num 		dd 		0 	; Reserve 4 bytes (doubleword) for random number that needs to be guessed
tries			dd		10

SECTION .bss
sinput:			resb	4	; Reserve 4 byte space in memory for reading number 

SECTION .text
global	_start

_start:
	; Generate random number
	mov		eax, secret_num		; move address of secret_num to eax
	call	gen_rand_int

	; print random number
;	mov		eax, [secret_num]
;	call	iprint

	; tulosta introteksti
	mov		eax, msg_intro
	call	sprintLF
	mov		eax, msg_empty
	call	sprintLF

guessing:
	mov		eax, [tries]
	cmp		eax, 0h
	jz		game_over

	; print tries left 
	mov		eax, msgLeft
	call	sprint
	mov		eax, [tries]
	call	iprintLF
	; prompt user
	mov		eax, msgPrompt
	call	sprint
	mov     edx, 4          ; number of bytes to read
    mov     ecx, sinput     ; reserved space to store our input (known as a buffer)
    mov     ebx, 0          ; read from the STDIN file
    mov     eax, 3          ; invoke SYS_READ (kernel opcode 3)
    int     80h

	; compare
	mov		eax, sinput		; move input's address to eax
	call	atoi
	cmp		eax, [secret_num]
	jg		too_big
	jl		too_small
	je		win
too_big:
	mov		eax, msg_smaller	
	call	sprintLF
	jmp		decrease_tries
too_small:
	mov		eax, msg_bigger
	call	sprintLF
	jmp		decrease_tries

decrease_tries:
	mov		eax, msg_empty
	call	sprintLF
	mov		ebx, tries		; store tries address
	mov		eax, [tries]	
	dec		eax	
	mov		[ebx], eax
	
	jmp 	guessing

game_over:
	mov		eax, msg_game_over
	call	sprint
	mov		eax, [secret_num]
	call	iprintLF
	call	quit
win:
	mov		eax, msg_hooraa
	call	sprintLF
	mov		eax, msg_win
	call	sprintLF
	mov		eax, msg_hooraa
	call	sprintLF
	call	quit
