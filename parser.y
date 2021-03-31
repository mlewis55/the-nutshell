%{
#include <stdio.h>
int yylex();
int yyparse();
int* num;
void yyerror(char* e) {

}

%}
%union{
        int num;
}

%token <num> NUM
%token ADD

%%

addition:
        NUM ADD NUM {printf("Sum is %d", $1 + $3);};