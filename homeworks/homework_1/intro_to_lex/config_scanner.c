// lex config_scanner.l -> lex.yy.c
// gcc config_scanner.c lex.yy.c -o config_output

#include <stdio.h>
#include "config_scanner.h"

extern int yylex();
extern int yylineno;
extern char* yytext;
 
char *names[] = {NULL, "db_type", "db_name", "db_table_prefix", "db_port"};

int main(void)
{
    int n_token, value_token;

    n_token = yylex(); // will return the first valid token
    while(n_token)
    {
        printf("%d\n", n_token);
        if (yylex() != COLON)
        {
            printf("Syntax error in line %d, Expected a ':' but found %s\n", yylineno, yytext);
            return 1;
        }
        value_token = yylex();
        switch (n_token)
        {
        case TYPE:
        case NAME:
        case TABLE_PREFIX:
        if (value_token != IDENTIFIER)
        {
            printf("Syntax error in line %d, Expected an identifier but found %s\n", yylineno, yytext);
            return 1;
        }
        printf("%s is set to %s\n", names[n_token], yytext);
        break;

        case PORT:
            if (value_token != INTEGER)
            {
                printf("Syntax error in line %d, Expected an .integer but found %s\n", yylineno, yytext);
                return 1;
            }
            printf("%s is set to %s\n", names[n_token], yytext);
            break;
        
        
        default:
            printf("Syntax error in line %d\n", yylineno);
            break;
        }

        n_token = yylex();
    }
    return 0;
}