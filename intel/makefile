ASMBIN=nasm
CC=gcc

all: asm cc link

asm: 
	$(ASMBIN) -f elf32 func.asm -o func.o

cc: 
	$(CC) -m32 -c main.c -o main.o
	
link: 
	$(CC) -m32 main.o func.o -o test
