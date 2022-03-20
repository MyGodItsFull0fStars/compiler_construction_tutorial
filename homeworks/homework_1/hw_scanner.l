%{
    #include <stdio.h>
    #include "hw_scanner.h"
%}

letter      [a-zA-Z_]
digit       [0-9]
rel_OP      "<"|">"|"="
math_OP     "+"|"-"|"*"|"/"
whitespace  [ \t\n]    
paranthesis   "("|")"
bracket       "["|"]"
newline     "\n"
alphanum    letter|digit

%%

"{".*"}"                    { /* DO NOTHING */ }
\n                          { yylineno++; }
program                     return PROGRAM;
";"                         return SEMICOLON;
":"                         return COLON;
","                         return COMMA;
if|then|begin|end|procedure|function|boolean|while { return KEYWORD;
                                        }
true|false                  return BOOLEAN;
var                         return VAR;
integer                     return INTEGER_KW;
array                       return ARRAY;
of                          return ARRAY;
real                        return TYPE;

":="                        return ASSIGN;
{letter}{alphanum}*         return IDENTIFIER;
{digit}{letter}+            return ERROR;
{digit}+                    return INTEGER;
{digit}+"."{digit}*         return FLOAT;

{math_OP}                   return OP;
{rel_OP}                    return REL;
{paranthesis}               return PARANTHESIS;
{bracket}                   return BRACKET;
{bracket}{digit}+".."{digit}+{bracket}                            return ARRAY_DEC;
"."                         return DOT;
{whitespace}                /* eat up whitespace */
.                           return ERROR;

                    
%%



int yywrap()
{
    return 1;
}