# Simple Makefile

CC=/home/monica/nutshell

all:  flex-config bison-config nutshparser nutshscanner nutshell nutshell-out

flex-config:
	flex LEXER.l

bison-config:
	bison -d PARSER.y

LEXER:  lex.yy.c
	$(CC) -c lex.yy.c -o LEXER.lex.o

PARSER:  PARSER.tab.c
	$(CC) -c PARSER.tab.c -o PARSER.y.o

MAIN:  MAIN.c
	$(CC) -g -c MAIN.c -o MAIN.o 

MAIN-out:
	$(CC) -o MAIN MAIN.o LEXER.lex.o PARSER.y.o -ll -lm -lfl
