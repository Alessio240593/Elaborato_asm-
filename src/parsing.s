.section .data

.section .text
	.global parsing

parsing:
	movl $-1, %ecx # inizializzazione a -1 dato che poi incremento subito

	movl 12(%esp), %edi # sposto inidrizzo del puntatore passato come argomento dalla funzione c in esi stack(esp->pc_postfix , pc c function, input, output)

	movl 8(%esp), %esi # sposto inidrizzo del puntatore passato come argomento dalla funzione c in esi stack(esp->pc_postfix , pc c function, input, output)
	
# conversione ascii intero	
parse:

	incl %ecx # incremento ecx per usarlo con l'indirizzamento con spiazzamento 

	movb (%ecx,%esi), %bl # utilizzo l'indirizzamneto con spiazzamento sfruttando esi(contiene l'indirizzo di memoria della stringa passata) ed ecx che aumenta di 1 ad ogni ciclo

	cmp $0, %bl # controllo che il carattere non sia EOF

	je end

	cmp $10, %bl # controllo che il carattere non sia a capo

	je error_msg

	cmp $48, %bl # compare per vedere se è un numero >= 0

	jge is_number_

	cmp $32, %bl # compare per vedere se è uno spazio

	je double

	cmp $42, %bl # compare per vedere se è op *

	je parse

	cmp $43, %bl # compare per vedere se è op +

	je parse

	cmp $45, %bl # compare per vedere se è op -

	je parse

	cmp $47, %bl # compare per vedere se è op /

	je parse

	jmp error_msg


is_number_:

	cmp $57, %bl # compare per vedere se è un numero <= 9

	jle parse

	jmp error_msg # ADD
	

double:
	incl %ecx # incremento ecx per usarlo con l'indirizzamento con spiazzamento 

	movb (%ecx,%esi), %bl

	cmp $32, %bl # compare per vedere se dopo lo spazio c'è un altro spazio

	je error_msg

	decl %ecx

	jmp parse


error_msg:         # stampo messaggio di errore

	movb $'I',  (%edi)

	movb $'n', 1(%edi)

	movb $'v', 2(%edi)

	movb $'a', 3(%edi)

	movb $'l', 4(%edi)

	movb $'i', 5(%edi)

	movb $'d', 6(%edi) 
	
	movb $0, 7(%edi)

	movl $1, %eax # alzo flag errore

	ret

end:				# ritorno al programma chiamante dato che la stringa è valida
	ret
