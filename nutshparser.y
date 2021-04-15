%{
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>
#include <string.h>
#include "global.h"

int yylex(void);
int yyerror(char *s);
int runCD(char* arg);
int runSetAlias(char *name, char *word);
int nonBuiltIn();
int displayAlias();
int removeAlias(char* arg);
int goHome();
int setEnv(char *var, char *word);
int printEnv();
int unsetEnv(char *var);
{
	printf()
}
%}

%union {char *string;}

%start cmd_line
%token <string> BYE CD STRING ALIAS UNALIAS SETENV PRINTENV UNSETENV ERROR END

%%
cmd_line    :
	BYE END                                 {exit(1); return 1; }
	| CD STRING END                         {runCD($2); return 1;}
	| CD END                                {goHome(); return 1;}
	| ALIAS STRING STRING END               {runSetAlias($2, $3); return 1;}
	| ALIAS END                             {displayAlias(); return 1;}
	| UNALIAS STRING END                    {removeAlias($2); return 1;}
	| SETENV STRING STRING END              {setEnv($2, $3); return 1;}
	| PRINTENV END                          {printEnv(); return 1;}
	| UNSETENV STRING END                   {unsetEnv($2); return 1;}
	| ERROR                                 {return 1;}
	| STRING STRING STRING STRING STRING STRING STRING STRING STRING END                     {if(command != NULL){ fnmatch(); nonBuiltIn();} return 1;}
	| STRING STRING STRING STRING STRING STRING STRING STRING END                     {if(command != NULL){nonBuiltIn();} return 1;}
	| STRING STRING STRING STRING STRING STRING STRING END                     {if(command != NULL){nonBuiltIn();} return 1;}
	| STRING STRING STRING STRING STRING STRING END                     {if(command != NULL){nonBuiltIn();} return 1;}
	| STRING STRING STRING STRING STRING END                     {if(command != NULL){nonBuiltIn();} return 1;}
	| STRING STRING STRING STRING END                     {if(command != NULL){nonBuiltIn();} return 1;}
	| STRING STRING STRING END                     {if(command != NULL){nonBuiltIn();} return 1;}
	| STRING STRING END                     {if(command != NULL){nonBuiltIn();} return 1;}
	| STRING END                     {if(command != NULL){nonBuiltIn();} return 1;}
%%

int yyerror(char *s) 
{
  printf("%s\n",s);
  return 0;
}

int runCD(char* arg) 
{
	if (arg[0] != '/') 
	{ // arg is relative path
		strcat(varTable.word[0], "/");
		strcat(varTable.word[0], arg);

		if(chdir(varTable.word[0]) == 0) {
			return 1;
		}
		else 
		{
			getcwd(cwd, sizeof(cwd));
			strcpy(varTable.word[0], cwd);
			printf("Directory not found\n");
			return 1;
		}
	}
	else 
	{ // arg is absolute path
		if(chdir(arg) == 0)
		{
			strcpy(varTable.word[0], arg);
			return 1;
		}
		else 
		{
			printf("Directory not found\n");
			return 1;
		}
	}
}

int runSetAlias(char *name, char *word) 
{
	for (int i = 0; i < aliasIndex; i++) 
	{
		if(strcmp(name, word) == 0)
		{
			printf("Error, expansion of \"%s\" would create a loop.\n", name);
			return 1;
		}
		else if((strcmp(aliasTable.name[i], name) == 0) && (strcmp(aliasTable.word[i], word) == 0)){
			printf("Error, expansion of \"%s\" would create a loop.\n", name);
			return 1;
		}
		else if(strcmp(aliasTable.name[i], name) == 0) 
		{
			strcpy(aliasTable.word[i], word);
			return 1;
		}
	}
	strcpy(aliasTable.name[aliasIndex], name);
	strcpy(aliasTable.word[aliasIndex], word);
	aliasIndex++;

	return 1;
}

int nonBuiltIn() 
{
	int err = 0;
	char pathHolder[300];
	strcpy(pathHolder, varTable.word[3]);
	char* temp = strtok(varTable.word[3], ":");
	char tempDir[100];
	strncpy(tempDir, temp, 100);
	strcat(tempDir, "/");
	strcat(tempDir, command);
	FILE *file;

	while (temp != NULL) 
	{
		if (file = fopen(tempDir, "r")) 
		{
			fclose(file);
			if (fork() == 0) 
			{
				err = execv(tempDir, arguments);
				exit(0);
			}
			wait(NULL);
			strcpy(varTable.word[3], pathHolder);
			return 1;
		}
		temp = strtok(NULL, ":");

		if (temp != NULL) 
		{
			strncpy(tempDir, temp, 100);
			strcat(tempDir, "/");
			strcat(tempDir, command);
		}
	}
	printf("This command is not found in the PATH directories.\n");
	strcpy(varTable.word[3], pathHolder);
	return 1;
}

int displayAlias() 
{
	for (int i = 0; i < aliasIndex; i++) 
	{
		printf("%s = %s\n", aliasTable.name[i], aliasTable.word[i]);
	}
	return 1;
}

int removeAlias(char* arg) 
{
	for (int i = 0; i < aliasIndex; i++) 
	{
		if (strcmp(aliasTable.name[i], arg) == 0) 
		{
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

int goHome() 
{
	if(chdir(varTable.word[1]) != 0)
		printf("Error: HOME variable not set to an existing directory.\n");
	return 1;
}

int setEnv(char *var, char *word) 
{
	char *isTrue;
	if (strcmp(var, "PATH") == 0) 
	{
		if ((isTrue = strstr(word, ".:")) != NULL) 
		{
				strcpy(varTable.word[3], word);
				return 1;
		}
		else 
		{
				char temp[100] = ".:";
				strcat(temp, word);
				strcpy(varTable.word[3], temp);
				return 1;
		}
	}
	for(int i = 0; i < varIndex; i++) 
	{
		if (strcmp(varTable.var[i], var) == 0) 
		{
				strcpy(varTable.word[i], word);
				return 1;
		}
	}
	strcpy(varTable.var[varIndex], var);
	strcpy(varTable.word[varIndex], word);
	varIndex++;
	return 1;
}

int printEnv() 
{
	for (int i = 0; i < varIndex; i++) 
	{
		printf("%s=%s\n", varTable.var[i], varTable.word[i]);
	}
	return 1;
}

int unsetEnv(char *var) 
{

	if (strcmp(var, "PWD") == 0) 
	{
		strcpy(varTable.word[0], "");
		printf("Cannot entirely unset PWD, 1 of 4 base variables, word changed to null as instructed.\n");
		return 1;
	}
	else if (strcmp(var, "HOME") == 0) {
		strcpy(varTable.word[1], "");
		printf("Cannot entirely unset HOME, 1 of 4 base variables, word changed to null as instructed.\n");
		return 1;
	}
	else if (strcmp(var, "PROMPT") == 0) 
	{
		strcpy(varTable.word[2], "");
		printf("Cannot entirely unset PROMPT, 1 of 4 base variables, word changed to null as instructed.\n");
		return 1;
	}
	else if (strcmp(var, "PATH") == 0) 
	{
		strcpy(varTable.word[3], ".:");
		printf("Cannot entirely unset PATH, 1 of 4 base variables, word changed to .: as instructed.\n");
		return 1;
	}

	for (int i = 4; i < varIndex; i++) {
		if (strcmp(varTable.var[i], var) == 0) 
		{
			for (int j = i; j < varIndex; j++) 
			{
				strcpy(varTable.var[j], varTable.var[j+1]);
				strcpy(varTable.word[j], varTable.word[j+1]);
			}
			varIndex--;
		}
	}
	return 1;
}
