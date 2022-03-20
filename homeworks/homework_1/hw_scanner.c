// lex hw_scanner.l -> lex.yy.c
// gcc hw_scanner.c lex.yy.c -o hw_output

#include <stdio.h>
#include "hw_scanner.h"

extern int yylex();
extern int yylineno;
extern char* yytext;

int main(void)
{
    int n_token, v_token;
    int count = 0;
    n_token = yylex(); // will return the first valid token

    FILE *fp;

    fp = fopen("test.pas", "w+");
    // fprintf(fp, "This is a Test\n");
    // fputs("wrotghiwrhg\n", fp);
    while(n_token)
    {

        // fputs(yytext, fp);
        // fputs("\n", fp);
        // v_token = yylex();
        switch (n_token)
        {
        case PROGRAM:
        case IDENTIFIER:
        case SEMICOLON:
        case COLON:
        case VAR:
        case INTEGER_KW:
        case ARRAY:
        case COMMA:
        case OP:
        case REL:
        case ASSIGN:
        case BEGIN_KW:
        case END_KW:
        case FUNCTION:
        case COND:
        case COMMENT:
        case INTEGER:
        case BOOLEAN:
        case KEYWORD:
        case TYPE:
        case FLOAT:
        case PARANTHESIS:
        case BRACKET:
        case ARRAY_DEC:
        case DOT:
            // if (v_token != IDENTIFIER){
            //     printf("Syntax error in line %d, Expected an identifier but found %s\n", yylineno, yytext);
            //     return 1;
            // }
            break;
        
        case ERROR:
            printf("Syntax error in line %d with token %s\n", yylineno, yytext);
            break;

        default:
            break;
        
        }
        // printf("%d\t", n_token);
        n_token = yylex();
        // count++;
        // if (count % 10 == 0)
        //     printf("\n");
    }
    fclose(fp);
    return 0;
}