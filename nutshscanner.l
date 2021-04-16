%{
#include "nutshparser.tab.h"
#include <string.h>
#include "global.h"
#include <pwd.h>
char* subAliases(char* name){
    for (int i = 0; i < aliasIndex; i++) {
        if(strcmp(aliasTable.name[i], name) == 0) {
            return aliasTable.word[i];
        }
    }
    return name;
}
bool ifAlias(char* name){
    for (int i = 0; i < aliasIndex; i++) {
        if(strcmp(aliasTable.name[i], name) == 0) {
            return true;
        }
    }
    return false;
}

char* subEnv(char* name){
        char newName[strlen(name) - 3];
        strncpy(newName, &name[2], strlen(name) - 3);
        for(int i = 0; i < varIndex; i++) {
                if (strcmp(varTable.var[i], newName) == 0) {
                        return varTable.word[i];
                }
        }
        return name;
}

char* tildeSub(char* name){
        struct passwd* pwfile;
        char noTilde[100];
        strncpy(noTilde, &name[1], 100);
        strcat(noTilde, "/");
        int i = 0;
        char split[3][100];
        char* newString;
        newString = strtok(noTilde, "/");
        while (newString != NULL)
        {
            strncpy(split[i], newString, 100);
            i++;
            newString = strtok(NULL, "/");
        }
        pwfile = getpwnam(split[0]);
        if (pwfile == NULL) {
            return varTable.word[1];
        }
        return pwfile->pw_dir;
}


%}
%array
%option noyywrap
%x string_condition
%option yylineno

CHAR               [.:A-Za-z0-9!\/_-][.:A-Za-z0-9!\/_-]*
ANYCHAR            [)(*&%$#@!`;,\.a-zA-Z0-9'/*_=~ -][)(*&%$#@!`;,\.a-zA-Z0-9'/*_=~ -]*

%%

<string_condition>{ANYCHAR}+     {strncpy(argumentHelper[argumentCounter], yytext, 100);
                                  arguments[argumentCounter] = argumentHelper[argumentCounter];
                                  arguments[argumentCounter + 1] = NULL;
                                  argumentCounter++; yylval.string = strdup(yytext); return STRING;}
<string_condition>[\"]          {BEGIN(INITIAL);}

&                               {background = 1; catchup = 1;}
[<]                             {ioCount++; yylval.string = strdup(yytext); return IN; }
[>]{2}                          {ioCount++; yylval.string = strdup(yytext); return OUT2; }
[>]                             {ioCount++; yylval.string = strdup(yytext); return OUT1; }
[2][>][A-Za-z0-9!\/_-]+         {ioCount++; strncpy(ioerr[0], &yytext[2], 100); yylval.string = strdup(yytext); return IOERR; }
2>&1                            {ioCount++; return IOERR; }
[$][{][A-Za-z0-9!\/_-]+[}]      { char *yycopy = strdup( subEnv(yytext) );
                                if (strcmp(yycopy, yytext) == 0) {
                                        return ERROR;
                                }
                                for ( int i = strlen(subEnv(yytext)) - 1; i >= 0; --i )
                                        unput( yycopy[i] );
                                free( yycopy );}
[~][A-Za-z0-9_-]*               { char *yycopy = strdup(tildeSub(yytext));
                                if (strcmp(yycopy, yytext) == 0) {
                                        return ERROR;
                                } else {
                                        for ( int i = strlen(tildeSub(yytext)) - 1; i >= 0; --i )
                                                unput( yycopy[i] );
                                free( yycopy );}}
[ ]                     { }
bye                     { return BYE; }
cd                      {argumentCounter++; return CD;}
alias                   { argumentCounter++; yylval.string = strdup(yytext); return ALIAS; }
unalias                 { argumentCounter++; return UNALIAS; }
setenv                  { argumentCounter++; return SETENV; }
printenv                { argumentCounter++; yylval.string = strdup(yytext); return PRINTENV; }
unsetenv                { argumentCounter++; return UNSETENV; }
"\n"                    { return END; }
[\"]                    { BEGIN(string_condition); }
{CHAR}+                 {if(argumentCounter == 0) {
                        if(ifAlias(yytext)) {
                           char *yycopy = strdup( subAliases(yytext) );
                           for ( int i = strlen(subAliases(yytext)) - 1; i >= 0; --i )
                               unput( yycopy[i] );
                           free( yycopy );
                           if (aliasLoopCounter == 20) {
                                YY_FLUSH_BUFFER;
                                return ERROR;
                        }
			            aliasLoopCounter++;
                        } else {
                        strncpy(argumentHelper[argumentCounter], yytext, 100);
                        arguments[argumentCounter] = argumentHelper[argumentCounter];
                        arguments[argumentCounter + 1] = NULL;
                        argumentCounter++;
                        command = argumentHelper[0];
                        yylval.string = strdup(yytext);
                        return STRING;
                        }
                        }
                        else {
                            if (ioCount == 0) {
                            strncpy(argumentHelper[argumentCounter], yytext, 100);
                            arguments[argumentCounter] = argumentHelper[argumentCounter];
                            arguments[argumentCounter + 1] = NULL;
                            argumentCounter++;
                            }
                            if (ioCount > 0) { ioCount--; }
                            yylval.string = strdup(yytext);
                            return STRING;
                       };
                       }
%%
