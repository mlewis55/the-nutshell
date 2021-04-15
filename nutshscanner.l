%{
#include "nutshparser.tab.h"
#include <string.h>
#include <dirent.h>
#include "global.h"

char* subAliases(char* name)
{
    for (int i = 0; i < aliasIndex; i++) {
        if(strcmp(aliasTable.name[i], name) == 0) {
            return aliasTable.word[i];
        }
    }
    return name;
}
bool ifAlias(char* name)
{
    for (int i = 0; i < aliasIndex; i++) {
        if(strcmp(aliasTable.name[i], name) == 0) {
            return true;
        }
    }
    return false;
}
%}

%array
%option noyywrap
%x string_condition

CHAR            [.:A-Za-z0-9!\/_-][.:A-Za-z0-9!\/_-]*
ANYCHAR         [)(*&%$#@!`;,\.a-zA-Z0-9'/\*_=~ -][)(*&%$#@!`;,\.a-zA-Z0-9'/\*_=~ -]*
%%

<string_condition>{ANYCHAR}+        {strncpy(argumentHelper[argumentCounter], yytext, 100);
                                        arguments[argumentCounter] = argumentHelper[argumentCounter];
                                        arguments[argumentCounter + 1] = NULL;
                                        argumentCounter++; 
                                        yylval.string = strdup(yytext);
                                        return STRING;}
<string_condition>[\"]              {BEGIN(INITIAL);}

[ ]                     { }
bye                     { return BYE; }
cd                      { argumentCounter++; return CD;}
alias                   { argumentCounter++; return ALIAS; }
unalias                 { argumentCounter++; return UNALIAS; }
setenv                  { argumentCounter++; return SETENV; }
printenv                { return PRINTENV; }
unsetenv                { argumentCounter++; return UNSETENV; }
"\n"                    { return END; }
[\"]                    { BEGIN(string_condition); }
{CHAR}+                 {if(argumentCounter == 0) {
                        if(ifAlias(yytext)) {
                        printf("yytext: %s\n", yytext);
                        //source: https://www.cs.princeton.edu/~appel/modern/c/software/flex/flex.html
                           char *yycopy = strdup( subAliases(yytext) );
                           for ( int i = strlen(subAliases(yytext)) - 1; i >= 0; --i )
                               unput( yycopy[i] );
                           free( yycopy );
                           if (aliasLoopCounter == 20) {
                                printf("Infinite aliasing loop detected.\n");
                                YY_FLUSH_BUFFER;
                                return ERROR;
                           }
                           aliasLoopCounter++;
                        } else 
                        {
                            strncpy(argumentHelper[argumentCounter], yytext, 100);
                            arguments[argumentCounter] = argumentHelper[argumentCounter];
                            arguments[argumentCounter + 1] = NULL;
                            argumentCounter++;
                            command = argumentHelper[0];
                            printf("yytext: %s\n", yytext);
                            yylval.string = strdup(yytext);
                            return STRING;
                        }
                        }
                        else {
                            strncpy(argumentHelper[argumentCounter], yytext, 100);
                            arguments[argumentCounter] = argumentHelper[argumentCounter];
                            arguments[argumentCounter + 1] = NULL;
                            argumentCounter++;
                            printf("yytext: %s\n", yytext);
                            yylval.string = strdup(yytext);
                            return STRING;
                        };
                        }
%%
