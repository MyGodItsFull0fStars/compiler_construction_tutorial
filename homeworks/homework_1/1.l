%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>


%}
/* https://www.tutorialspoint.com/pascal/pascal_operators.htm */

math_op     (\*|\-|\+|\/|\%){1}
relation_op (=|<>|>|<|>=|<=){1}
boolean_op  ("and"|"and then"|"or"|"or else"|"not"){1}
bit_op      (\&|\||\!|\~|<<|>>){1}
number      [0-9]+
words       [_a-zA-Z][_a-zA-Z0-9]*
separators  (;|:|,|\.\.){1}
braces      (\{|\}|\(|\)|\[|\]){1}

%%

{math_op}           { printf("\nIdentified math_op: %s", yytext); }
{relation_op}       { printf("\nIdentified relation_op: %s", yytext); }
{boolean_op}        { printf("\nIdentified boolean_op: %s", yytext); }
{bit_op}            { printf("\nIdentified bit_op: %s", yytext); }
{number}            { printf("\nIdentified number: %s", yytext); }
{words}             { printf("\nIdentified words: %s", yytext); }
{braces}            { printf("\nIdentified braces: %s", yytext); }
{separators}        { printf("\nIdentified separators: %s", yytext); }

%%

int main(int argc, char **argv) {
    yylex();
    printf("Terminated.");
    return 0;
}