%{
    #include "y.tab.h"
    #include <stdio.h>
    #include <stdlib.h>
    #include "ast_symtab.h"
%}
%option yylineno

%%

[ ]             ;
[\t]+           ;
[\n]+           ;
"{".*"}"        ;
"exit"          { return exit_command; }

"*"             return MULT;
"/"             return DIVIDE;
"div"           return DIV;
"mod"           return MOD;
"and"           return AND;

                   
%%

int yywrap()
{
    return 1;
}