AS = as --32
GCC = gcc -m32
FLAGS = -gstabs

bin/postfix: src/main.c obj/postfix.o obj/parsing.o
	$(GCC) src/main.c obj/postfix.o obj/parsing.o -o bin/postfix

obj/postfix.o: src/postfix.s
	$(AS) src/postfix.s -o obj/postfix.o
 
obj/parsing.o: src/parsing.s
	$(AS) src/parsing.s -o obj/parsing.o

clean:
	rm -rf bin/* && rm -rf obj/*	 
