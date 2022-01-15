.section .data

is_neg:
	.byte 0

tmp:
	.ascii "00000000000000"     # temporary string

.section .text

 	.global postfix

postfix:
	call parsing # controllo validità stringa

	cmp $1, %eax # controllo flag restituito dalla funzione parsing (stringa valida o non valida)

	je end # se è a 1 termino il programma

# azzero i registri
	movl $-1, %ecx

	movl $0, %ebx

	movl $0, %eax

	movl $0, %edi

	movl 4(%esp), %esi # sposto inidrizzo del puntatore passato come argomento dalla funzione c in esi stack(esp-> pc c function, input, output)

	movl 8(%esp), %edi # sposto indirizzo output in ebp stack(esp-> pc c function, input, output)


# processo la stringa	
read_input:
	incl %ecx

	movl $0, %eax

	movb (%ecx,%esi), %bl # utilizzo l'indirizzamneto con spiazzamento sfruttando esi(contiene l'indirizzo di memoria della stringa passata) ed ecx che aumenta di 1 ad ogni ciclo

	cmp $0, %bl # controllo se EOF

	je fine

	cmp $10, %bl # controllo se a capo

	je fine

	cmp $43, %bl

	je sum

	cmp $45, %bl

	je subtraction

multiply:
	cmp $42, %bl

	je multiplication

divide:
	cmp $47, %bl

	je division

is_number:

	subb $48, %bl

	movl $10, %edx 

	imul %edx, %eax # passo alla cifra successiva

	addb %bl, %al

	incl %ecx # incremento ecx per sfruttare lo spiazzamento 

	movb (%ecx,%esi), %bl # accedo al carattere successivo

	cmp $32, %bl # controllo se il carattere successivo è uno spazio

	je insert

	jmp is_number

insert:
	cmp $1, is_neg

	je negative 

	push %eax

	jmp read_input

negative:
	imul $-1, %eax

	push %eax

	movl $0, is_neg

	jmp read_input

sum:
	popl %ebx

	popl %eax

	addl %eax, %ebx

 	pushl %ebx

	inc %ecx # incremento ecx per sfruttare lo spiazzamento 

	jmp read_input


subtraction:
	incl %ecx

	movb (%ecx,%esi), %bl

	cmp $48, %bl	# controllo se dopo il segno - c'è un numero allora il segno - si riferisce al numero e non è un operando

	jge negative_token

	decl %ecx

	popl %ebx

	popl %eax

	movl %ebx, %edx

	subl %ebx, %eax

	pushl %eax

	jmp read_input


negative_token:	#alzo una flag per segnare il numero come negativo
	movl $1, is_neg

	jmp is_number


multiplication:
	popl %edx

	popl %eax

	imul %edx, %eax

	pushl %eax

	inc %ecx # incremento ecx per sfruttare lo spiazzamento 

	jmp read_input


division:
	movl $0, %edx;
	
	popl %ebx

	popl %eax

	idiv %ebx

	pushl %eax

	inc %ecx # incremento ecx per sfruttare lo spiazzamento 

	jmp read_input


fine:
	popl %eax

	cmp $0, %eax

	jl sign

	jmp write

sign:				# caso in cui il risultato è negativo (cambio il segno) e aggiungo il simbolo - i testa alla stringa
	movl $10, %ebx

	imul $-1, %eax

	movb $'-', (%edi)

	incl %edi

	jmp write

write:

	movl $10, %ebx             # carica 10 in EBX (usato per le divisioni)

	movl $0, %ecx              # azzera il contatore ECX

	leal tmp, %esi          # carica l'indirizzo di 'numtmp' in ESI


continua_a_dividere:

	movl $0, %edx              # azzera il contenuto di EDX

	divl %ebx                  # divide per 10 il numero ottenuto

	addb $48, %dl              # aggiunge 48 al resto della divisione

	movb %dl, (%ecx,%esi)    # sposta il contenuto di DL in tmp

	inc %ecx                   # incrementa il contatore ECX

	cmp $0, %eax               # controlla se il contenuto di EAX è 0

	jne continua_a_dividere

	movl $0, %ebx              # azzera un secondo contatore in EBX


ribalta:

	movb -1(%ecx,%esi), %al  # carica in AL il contenuto dell'ultimo byte di 'tmp'
	
	movb %al, (%ebx,%edi)    # carica nel primo byte di OUTPUT il contenuto di AL

	inc %ebx                   # incrementa il contatore EBX

	loop ribalta


movb $0, (%ebx,%edi)    # aggiungo il terminatore a fine stringa

ret # ritono alla funzione chiamante 

end:
	ret
