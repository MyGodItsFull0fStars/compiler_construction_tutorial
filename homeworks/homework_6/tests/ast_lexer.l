%{
    #include "y.tab.h"
    #include <stdio.h>
    #include <stdlib.h>
    #include "ast_symtab.h"
%}
%option yylineno
id          [a-zA-Z_][a-zA-Z_0-9]*
digit       [0-9]
nat         {digit}+
signedNat   (-)?{nat}
num         {signedNat}("."{nat})?(E{signedNat})?

%%

[ ]             ;
[\t]+           ;
[\n]+           ;
"{".*"}"        ;
"exit"          { return exit_command; }
"program"       return PROGRAM;
";"             return SEMICOLON;
"var"           return VAR;
":="            return ASSIGN;
"array"         return ARRAY;
"["             return OP_BRACKET;
"]"             return CL_BRACKET;
".."            return TWO_DOTS;
"of"            return OF;
"integer"       return INTEGER;
"boolean"       return BOOLEAN_OP;
"real"          return REAL;
"function"      return FUNCTION;
"procedure"     return PROCEDURE;
":"             return COLON;
"("             return OP_PARANTHESIS;
")"             return CL_PARANTHESIS;
"begin"         return BEGIN_KW;
"end"           return END;
"if"            return IF;
"then"          return THEN;
"else"          return ELSE;
"while"         return WHILE;
"do"            return DO;
"false"         return FALSE_KW;
"true"          return TRUE_KW;
"not"           return NOT;
"-"             return MINUS;
"<"             return LESS;
"<="            return LESS_EQUAL;
">"             return GREATER;
">="            return GREATER_EQUAL;
"="             return EQUAL;
"<>"            return NOT_EQUAL;
"+"             return PLUS;
"or"            return OR;
"*"             return MULT;
"/"             return DIVIDE;
"div"           return DIV;
"mod"           return MOD;
"and"           return AND;
"."             return DOT;
","             return COMMA;
{id}            return IDENT;
{num}           return NUM;



                    
%%

int yywrap()
{
    return 1;
}