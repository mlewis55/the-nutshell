#include "PARSER.tab.h"
#include <stdio.h>

int main() {
        int x = 1;
        while (x==1) {
                yyparse();
        }
        return 0;
}