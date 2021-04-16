#include "stdbool.h"
#include <limits.h>

struct evTable {
   char var[128][100];
   char word[128][100];
};

struct aTable {
        char name[128][100];
        char word[128][100];
};

char cwd[PATH_MAX];

struct evTable varTable;

struct aTable aliasTable;

int aliasIndex, varIndex;

char* subAliases(char* name);

char* command;
char* arguments[50];
char argumentHelper[50][100];
int argumentCounter;
int aliasLoopCounter;
char io[5][100];
int ioCount;
char ioerr[1][100];
int background;
int catchup;
