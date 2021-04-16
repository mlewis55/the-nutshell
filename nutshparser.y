%{
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>
#include <string.h>
#include "global.h"

int yylex(void);
int yyerror(const char *s);
int runCD(char* arg);
int runSetAlias(char *name, char *word);
int nonBuiltIn();
int displayAlias();
int removeAlias(char* arg);
int goHome();
int setEnv(char *var, char *word);
int printEnv();
int unsetEnv(char *var);
int inIO(char* arg);
int out1IO(char* arg);
int out2IO(char* arg);
int inout1IO(char* in, char* out);
int inout2IO(char* in, char* out);
int IOerr();
int inIOerr(char* in);
int out1IOerr(char* out);
int out2IOerr(char* out);
int inout1IOerr(char* in, char* out);
int inout2IOerr(char* in, char* out);
int aliasprintenvIO1(char* name, char* out);
int aliasprintenvIO2(char* name, char* out);
%}

%union {char *string;}

%define parse.error verbose
%locations

%start cmd_line
%token <string> BYE CD STRING ALIAS UNALIAS SETENV PRINTENV UNSETENV ERROR IN OUT1 OUT2 IOERR END

%%
cmd_line    :
        BYE END                                 {exit(1); return 1; }
        | CD STRING END                         {runCD($2); return 1;}
        | CD END                                {goHome(); return 1;}
        | ALIAS STRING STRING END               {runSetAlias($2, $3); return 1;}
        | ALIAS END                             {displayAlias(); return 1;}
        | ALIAS OUT1 STRING END                 {aliasprintenvIO1($1, $3); return 1;}
        | ALIAS OUT2 STRING END                 {aliasprintenvIO2($1, $3); return 1;}
        | UNALIAS STRING END                    {removeAlias($2); return 1;}
        | SETENV STRING STRING END              {setEnv($2, $3); return 1;}
        | PRINTENV END                          {printEnv(); return 1;}
        | PRINTENV OUT1 STRING END              {aliasprintenvIO1($1, $3); return 1;}
        | PRINTENV OUT2 STRING END              {aliasprintenvIO2($1, $3); return 1;}
        | UNSETENV STRING END                   {unsetEnv($2); return 1;}
        | ERROR                                 {return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING STRING IN STRING OUT1 STRING IOERR END       {inout1IOerr($11, $13); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING STRING IN STRING OUT1 STRING END        {inout1IO($11, $13); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING STRING IN STRING OUT2 STRING IOERR END       {inout2IOerr($11, $13); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING STRING IN STRING OUT2 STRING END        {inout2IO($11, $13); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING STRING IN STRING IOERR END            {inIOerr($11); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING STRING IN STRING END            {inIO($11); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING STRING OUT1 STRING IOERR END     {out1IOerr($11); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING STRING OUT1 STRING END          {out1IO($11); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING STRING OUT2 STRING IOERR END                {out2IOerr($11); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING STRING OUT2 STRING END          {out2IO($11); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING STRING IOERR END                      {IOerr(); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING STRING END                     {if(command != NULL){nonBuiltIn();} return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING IN STRING OUT1 STRING IOERR END       {inout1IOerr($10, $12); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING IN STRING OUT1 STRING END        {inout1IO($10, $12); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING IN STRING OUT2 STRING IOERR END       {inout2IOerr($10, $12); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING IN STRING OUT2 STRING END        {inout2IO($10, $12); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING IN STRING IOERR END            {inIOerr($10); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING IN STRING END            {inIO($10); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING OUT1 STRING IOERR END     {out1IOerr($10); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING OUT1 STRING END          {out1IO($10); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING OUT2 STRING IOERR END                {out2IOerr($10); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING OUT2 STRING END          {out2IO($10); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING IOERR END                      {IOerr(); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING STRING END                     {if(command != NULL){nonBuiltIn();} return 1;}
        | STRING STRING STRING STRING STRING STRING STRING IN STRING OUT1 STRING IOERR END       {inout1IOerr($9, $11); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING IN STRING OUT1 STRING END        {inout1IO($9, $11); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING IN STRING OUT2 STRING IOERR END       {inout2IOerr($9, $11); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING IN STRING OUT2 STRING END        {inout2IO($9, $11); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING IN STRING IOERR END            {inIOerr($9); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING IN STRING END            {inIO($9); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING OUT1 STRING IOERR END     {out1IOerr($9); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING OUT1 STRING END          {out1IO($9); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING OUT2 STRING IOERR END                {out2IOerr($9); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING OUT2 STRING END          {out2IO($9); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING IOERR END                      {IOerr(); return 1;}
        | STRING STRING STRING STRING STRING STRING STRING END                     {if(command != NULL){nonBuiltIn();} return 1;}
        | STRING STRING STRING STRING STRING STRING IN STRING OUT1 STRING IOERR END       {inout1IOerr($8, $10); return 1;}
        | STRING STRING STRING STRING STRING STRING IN STRING OUT1 STRING END        {inout1IO($8, $10); return 1;}
        | STRING STRING STRING STRING STRING STRING IN STRING OUT2 STRING IOERR END       {inout2IOerr($8, $10); return 1;}
        | STRING STRING STRING STRING STRING STRING IN STRING OUT2 STRING END        {inout2IO($8, $10); return 1;}
        | STRING STRING STRING STRING STRING STRING IN STRING IOERR END            {inIOerr($8); return 1;}
        | STRING STRING STRING STRING STRING STRING IN STRING END            {inIO($8); return 1;}
        | STRING STRING STRING STRING STRING STRING OUT1 STRING IOERR END     {out1IOerr($8); return 1;}
        | STRING STRING STRING STRING STRING STRING OUT1 STRING END          {out1IO($8); return 1;}
        | STRING STRING STRING STRING STRING STRING OUT2 STRING IOERR END                {out2IOerr($8); return 1;}
        | STRING STRING STRING STRING STRING STRING OUT2 STRING END          {out2IO($8); return 1;}
        | STRING STRING STRING STRING STRING STRING IOERR END                      {IOerr(); return 1;}
        | STRING STRING STRING STRING STRING STRING END                     {if(command != NULL){nonBuiltIn();} return 1;}
        | STRING STRING STRING STRING STRING IN STRING OUT1 STRING IOERR END       {inout1IOerr($7, $9); return 1;}
        | STRING STRING STRING STRING STRING IN STRING OUT1 STRING END        {inout1IO($7, $9); return 1;}
        | STRING STRING STRING STRING STRING IN STRING OUT2 STRING IOERR END       {inout2IOerr($7, $9); return 1;}
        | STRING STRING STRING STRING STRING IN STRING OUT2 STRING END        {inout2IO($7, $9); return 1;}
        | STRING STRING STRING STRING STRING IN STRING IOERR END            {inIOerr($7); return 1;}
        | STRING STRING STRING STRING STRING IN STRING END            {inIO($7); return 1;}
        | STRING STRING STRING STRING STRING OUT1 STRING IOERR END     {out1IOerr($7); return 1;}
        | STRING STRING STRING STRING STRING OUT1 STRING END          {out1IO($7); return 1;}
        | STRING STRING STRING STRING STRING OUT2 STRING IOERR END                {out2IOerr($7); return 1;}
        | STRING STRING STRING STRING STRING OUT2 STRING END          {out2IO($7); return 1;}
        | STRING STRING STRING STRING STRING IOERR END                      {IOerr(); return 1;}
        | STRING STRING STRING STRING STRING END                     {if(command != NULL){nonBuiltIn();} return 1;}
        | STRING STRING STRING STRING IN STRING OUT1 STRING IOERR END       {inout1IOerr($6, $8); return 1;}
        | STRING STRING STRING STRING IN STRING OUT1 STRING END        {inout1IO($6, $8); return 1;}
        | STRING STRING STRING STRING IN STRING OUT2 STRING IOERR END       {inout2IOerr($6, $8); return 1;}
        | STRING STRING STRING STRING IN STRING OUT2 STRING END        {inout2IO($6, $8); return 1;}
        | STRING STRING STRING STRING IN STRING IOERR END            {inIOerr($6); return 1;}
        | STRING STRING STRING STRING IN STRING END            {inIO($6); return 1;}
        | STRING STRING STRING STRING OUT1 STRING IOERR END     {out1IOerr($6); return 1;}
        | STRING STRING STRING STRING OUT1 STRING END          {out1IO($6); return 1;}
        | STRING STRING STRING STRING OUT2 STRING IOERR END                {out2IOerr($6); return 1;}
        | STRING STRING STRING STRING OUT2 STRING END          {out2IO($6); return 1;}
        | STRING STRING STRING STRING IOERR END                      {IOerr(); return 1;}
        | STRING STRING STRING STRING END                     {if(command != NULL){nonBuiltIn();} return 1;}
        | STRING STRING STRING IN STRING OUT1 STRING IOERR END       {inout1IOerr($5, $7); return 1;}
        | STRING STRING STRING IN STRING OUT1 STRING END        {inout1IO($5, $7); return 1;}
        | STRING STRING STRING IN STRING OUT2 STRING IOERR END       {inout2IOerr($5, $7); return 1;}
        | STRING STRING STRING IN STRING OUT2 STRING END        {inout2IO($5, $7); return 1;}
        | STRING STRING STRING IN STRING IOERR END            {inIOerr($5); return 1;}
        | STRING STRING STRING IN STRING END            {inIO($5); return 1;}
        | STRING STRING STRING OUT1 STRING IOERR END   {out1IOerr($5); return 1;}
        | STRING STRING STRING OUT1 STRING END          {out1IO($5); return 1;}
        | STRING STRING STRING OUT2 STRING IOERR END                {out2IOerr($5); return 1;}
        | STRING STRING STRING OUT2 STRING END          {out2IO($5); return 1;}
        | STRING STRING STRING IOERR END                      {IOerr(); return 1;}
        | STRING STRING STRING END                      {if(command != NULL){nonBuiltIn();} return 1;}
        | STRING STRING IN STRING OUT1 STRING IOERR END       {inout1IOerr($4, $6); return 1;}
        | STRING STRING IN STRING OUT1 STRING END       {inout1IO($4, $6); return 1;}
        | STRING STRING IN STRING OUT2 STRING IOERR END       {inout2IOerr($4, $6); return 1;}
        | STRING STRING IN STRING OUT2 STRING END       {inout2IO($4, $6); return 1;}
        | STRING STRING IN STRING IOERR END            {inIOerr($4); return 1;}
        | STRING STRING IN STRING END           {inIO($4); return 1;}
        | STRING STRING OUT1 STRING IOERR END   {out1IOerr($4); return 1;}
        | STRING STRING OUT1 STRING END         {out1IO($4); return 1;}
        | STRING STRING OUT2 STRING IOERR END                {out2IOerr($4); return 1;}
        | STRING STRING OUT2 STRING END         {out2IO($4); return 1;}
        | STRING STRING IOERR END               {IOerr(); return 1;}
        | STRING STRING END                     {if(command != NULL){nonBuiltIn();} return 1;}
        | STRING IN STRING OUT1 STRING IOERR END       {inout1IOerr($3, $5); return 1;}
        | STRING IN STRING OUT1 STRING END      {inout2IO($3, $5); return 1;}
        | STRING IN STRING OUT2 STRING IOERR END       {inout2IOerr($3, $5); return 1;}
        | STRING IN STRING OUT2 STRING END      {inout2IO($3, $5); return 1;}
        | STRING IN STRING IOERR END            {inIOerr($3); return 1;}
        | STRING IN STRING END                  {inIO($3); return 1;}
        | STRING OUT1 STRING IOERR END          {out1IOerr($3); return 1;}
        | STRING OUT1 STRING END                {out1IO($3); return 1;}
        | STRING OUT2 STRING IOERR END                {out2IOerr($3); return 1;}
        | STRING OUT2 STRING END                {out2IO($3); return 1;}
        | IN STRING OUT1 STRING IOERR END       {inout1IOerr($2, $4); return 1;}
        | IN STRING OUT1 STRING END             {inout1IO($2, $4); return 1;}
        | IN STRING OUT2 STRING IOERR END       {inout2IOerr($2, $4); return 1;}
        | IN STRING OUT2 STRING END             {inout2IO($2, $4); return 1;}
        | IN STRING IOERR END                   {inIOerr($2); return 1;}
        | IN STRING END                         {inIO($2); return 1;}
        | OUT1 STRING IOERR END                 {out1IOerr($2); return 1;}
        | OUT1 STRING END                       {out1IO($2); return 1;}
        | OUT2 STRING IOERR END                 {out2IOerr($2); return 1;}
        | OUT2 STRING END                       {out2IO($2); return 1;}
        | STRING IOERR END                      {IOerr(); return 1;}
        | STRING END                            {if(command != NULL){nonBuiltIn();} return 1;}

%%

int yyerror(const char *s) {
        extern int yylineno;
        fprintf(stderr,"Error | Line: %d\n%s\n",yylineno,s);
        return 0;
}

int runCD(char* arg) {
        if (arg[0] != '/') { // arg is relative path
                strcat(varTable.word[0], "/");
                strcat(varTable.word[0], arg);

                if(chdir(varTable.word[0]) == 0) {
                        return 1;
                }
                else {
                        getcwd(cwd, sizeof(cwd));
                        strcpy(varTable.word[0], cwd);
                        printf("Directory not found\n");
                        return 1;
                }
        }
        else { // arg is absolute path
                if(chdir(arg) == 0){
                        strcpy(varTable.word[0], arg);
                        return 1;
                }
                else {
                        printf("Directory not found\n");
                        return 1;
                }
        }
}
int runSetAlias(char *name, char *word) {
        for (int i = 0; i < aliasIndex; i++) {
                if(strcmp(name, word) == 0){
                        printf("Error, expansion of \"%s\" would create a loop.\n", name);
                        return 1;
                }
                else if((strcmp(aliasTable.name[i], name) == 0) && (strcmp(aliasTable.word[i], word) == 0)){
                        printf("Error, expansion of \"%s\" would create a loop.\n", name);
                        return 1;
                }
                else if(strcmp(aliasTable.name[i], name) == 0) {
                        strcpy(aliasTable.word[i], word);
                        return 1;
                }
        }
        strcpy(aliasTable.name[aliasIndex], name);
        strcpy(aliasTable.word[aliasIndex], word);
        aliasIndex++;

        return 1;
}

int nonBuiltIn() {
        int err = 0;
        char pathHolder[300];
        strcpy(pathHolder, varTable.word[3]);
        char* temp = strtok(varTable.word[3], ":");
        char tempDir[100];
        strncpy(tempDir, temp, 100);
        strcat(tempDir, "/");
        strcat(tempDir, command);
        FILE *file;
        while (temp != NULL) {
                if (file = fopen(tempDir, "r")) {
                        fclose(file);
                        if (fork() == 0) {
                        err = execv(tempDir, arguments);
                        exit(1);
                        }
                        if (background == 0) {
                                wait(NULL);
                                if (catchup == 1) {
                                        sleep(1);
                                        catchup = 0;
                                }
                        }
                        strcpy(varTable.word[3], pathHolder);
                        return 1;
                }
                temp = strtok(NULL, ":");
                if (temp != NULL) {
                        strncpy(tempDir, temp, 100);
                        strcat(tempDir, "/");
                        strcat(tempDir, command);
                }
        }
        printf("This command is not found in the PATH directories.\n");
        strcpy(varTable.word[3], pathHolder);
        return 1;
}

int displayAlias() {
        for (int i = 0; i < aliasIndex; i++) {
                printf("%s=%s\n", aliasTable.name[i], aliasTable.word[i]);
        }
        return 1;
}

int removeAlias(char* arg) {
        for (int i = 0; i < aliasIndex; i++) {
                if (strcmp(aliasTable.name[i], arg) == 0) {
                for (int j = i; j < aliasIndex; j++) {
                        strcpy(aliasTable.name[j], aliasTable.name[j+1]);
                        strcpy(aliasTable.word[j], aliasTable.word[j+1]);
                }
                aliasIndex--;
                return 1;
                }
        }
        return 1;
}

int goHome() {
        if(chdir(varTable.word[1]) != 0)
                printf("Error: HOME variable not set to an existing directory.\n");
        return 1;
}

int setEnv(char *var, char *word) {
        char *isTrue;
        if (strcmp(var, "PATH") == 0) {
                if ((isTrue = strstr(word, ".:")) != NULL) {
                        strcpy(varTable.word[3], word);
                        return 1;
                }
                else {
                        char temp[100] = ".:";
                        strcat(temp, word);
                        strcpy(varTable.word[3], temp);
                        return 1;
                }
        }
        for(int i = 0; i < varIndex; i++) {
                if (strcmp(varTable.var[i], var) == 0) {
                        strcpy(varTable.word[i], word);
                        return 1;
                }
        }
        strcpy(varTable.var[varIndex], var);
        strcpy(varTable.word[varIndex], word);
        varIndex++;
        return 1;
}
int printEnv() {
        for (int i = 0; i < varIndex; i++) {
                printf("%s=%s\n", varTable.var[i], varTable.word[i]);
        }
        return 1;
}

int unsetEnv(char *var) {
        if (strcmp(var, "PWD") == 0) {
                strcpy(varTable.word[0], "");
                printf("Cannot entirely unset PWD, 1 of 4 base variables, word changed to null as instructed.\n");
                return 1;
        }
        else if (strcmp(var, "HOME") == 0) {
                strcpy(varTable.word[1], "");
                printf("Cannot entirely unset HOME, 1 of 4 base variables, word changed to null as instructed.\n");
                return 1;
        }
        else if (strcmp(var, "PROMPT") == 0) {
                strcpy(varTable.word[2], "");
                printf("Cannot entirely unset PROMPT, 1 of 4 base variables, word changed to null as instructed.\n");
                return 1;
        }
        else if (strcmp(var, "PATH") == 0) {
                strcpy(varTable.word[3], ".:");
                printf("Cannot entirely unset PATH, 1 of 4 base variables, word changed to .: as instructed.\n");
                return 1;
        }
        for (int i = 4; i < varIndex; i++) {
                if (strcmp(varTable.var[i], var) == 0) {
                for (int j = i; j < varIndex; j++) {
                        strcpy(varTable.var[j], varTable.var[j+1]);
                        strcpy(varTable.word[j], varTable.word[j+1]);
                }
                varIndex--;
                }
        }
        return 1;
}

int inIO(char* arg) {
        if (fork() == 0) {
        freopen(arg, "r", stdin);
        if(command != NULL){nonBuiltIn();}
        exit(0);
        }
        wait(NULL);
return 1;
}
int out1IO(char* arg) {
        if (fork() == 0) {
        freopen(arg, "w", stdout);
        if(command != NULL){nonBuiltIn();}
        exit(0);
        }
        wait(NULL);
return 1;
}

int out2IO(char* arg) {
        if (fork() == 0) {
        freopen(arg, "a", stdout);
        if(command != NULL){nonBuiltIn();}
        exit(0);
        }
        wait(NULL);
return 1;
}

int inout1IO(char* in, char* out) {
        if (fork() == 0) {
        freopen(in, "r", stdin);
        freopen(out, "w", stdout);
        if(command != NULL){nonBuiltIn();}
        exit(0);
        }
        wait(NULL);
return 1;
}

int inout2IO(char* in, char* out) {
        if (fork() == 0) {
        freopen(in, "r", stdin);
        freopen(out, "a", stdout);
        if(command != NULL){nonBuiltIn();}
        exit(0);
        }
        wait(NULL);
return 1;
}

int IOerr() {
        if (fork() == 0) {
        freopen(ioerr[0], "w", stderr);
        if(command != NULL){nonBuiltIn();}
        exit(0);
        }
        wait(NULL);
return 1;
}
int inIOerr(char* in) {
        if (fork() == 0) {
        freopen(in, "r", stdin);
        freopen(ioerr[0], "w", stderr);
        if(command != NULL){nonBuiltIn();}
        exit(0);
        }
        wait(NULL);
return 1;
}

int out1IOerr(char* out) {
        if (strcmp(ioerr[0], " ") == 0) {
                strncpy(ioerr[0], out, 100);
        }
        if (fork() == 0) {
        freopen(out, "a", stdout);
        freopen(ioerr[0], "w", stderr);
        if(command != NULL){nonBuiltIn();}
        exit(0);
        }
        wait(NULL);
return 1;
}

int out2IOerr(char* out) {
        if (strcmp(ioerr[0], " ") == 0) {
                strncpy(ioerr[0], out, 100);
        }
        if (fork() == 0) {
        freopen(out, "w", stdout);
        freopen(ioerr[0], "w", stderr);
        if(command != NULL){nonBuiltIn();}
        exit(0);
        }
        wait(NULL);
return 1;
}

int inout1IOerr(char* in, char* out) {
        if (strcmp(ioerr[0], " ") == 0) {
                strncpy(ioerr[0], out, 100);
        }
        if (fork() == 0) {
        freopen(in, "r", stdin);
        freopen(out, "w", stdout);
        freopen(ioerr[0], "w", stderr);
        if(command != NULL){nonBuiltIn();}
        exit(0);
        }
        wait(NULL);
return 1;
}
int inout2IOerr(char* in, char* out) {
        if (strcmp(ioerr[0], " ") == 0) {
                strncpy(ioerr[0], out, 100);
        }
        if (fork() == 0) {
        freopen(in, "r", stdin);
        freopen(out, "w", stdout);
        freopen(ioerr[0], "w", stderr);
        if(command != NULL){nonBuiltIn();}
        exit(0);
        }
        wait(NULL);
return 1;
}

int aliasprintenvIO1(char* name, char* out) {
        if (strcmp(name, "alias") == 0) {
                if (fork() == 0) {
                        freopen(out, "w", stdout);
                        displayAlias();
                        exit(0);
                }
        wait(NULL);
        }
        if (strcmp(name, "printenv") == 0) {
                if (fork() == 0) {
                        freopen(out, "w", stdout);
                        printEnv();
                        exit(0);
                }
        wait(NULL);
        }
return 1;
}

int aliasprintenvIO2(char* name, char* out) {
        if (strcmp(name, "alias") == 0) {
                if (fork() == 0) {
                        freopen(out, "a", stdout);
                        displayAlias();
                        exit(0);
                }
        wait(NULL);
        }
        if (strcmp(name, "printenv") == 0) {
                if (fork() == 0) {
                        freopen(out, "a", stdout);
                        printEnv();
                        exit(0);
                }
        wait(NULL);
        }
return 1;
}
