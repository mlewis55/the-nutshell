%{
#include "PARSER.tab.h"
%}

DIGIT [0-9]
ADDSIGN [+]

%%

{DIGIT}         {yylval.num=atoi(yytext); return NUM;}
{ADDSIGN}       return ADD;