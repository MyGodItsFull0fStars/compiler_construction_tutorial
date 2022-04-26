%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>

    #define ERROR                   0
    #define EPSILON                 1
    #define PLUS                    2
    #define MULT                    3
    #define LEFT_PARANTHESIS        4
    #define RIGHT_PARANTHESIS       5
    #define ID                      6
    #define NUM                     7

    void match(int);

    void E();
    void E_();

    void T();
    void T_();

    void F();

    void syntax_error(int expected, int actual);
    void syntax_error_multiple_expected(int expected[], int len, int actual);

    int token_number = -1;
    char* token_array[] = {"error", "epsilon", "addition", "multiplication", "left paranthesis", "right paranthesis", "identifier", "num"};
%}

/* 
E –> T E’ 
E’ –> + T E’ | e 
T –> F T’ 
T’ –> * F T’ | e 
F –> ( E ) | id
 */

newline         [\n]+
tab             [\t]+
space           [ ]
id              [a-zA-Z_][a-zA-Z_0-9]*
l_paranthesis   "("
r_paranthesis   ")"
plus            "+"
mult            "*"
num             [0-9]


%%

{space}             ;
{tab}               ;
{newline}           {yylineno++; return EPSILON;}

{l_paranthesis}     return LEFT_PARANTHESIS;
{r_paranthesis}     return RIGHT_PARANTHESIS;

{mult}              return MULT;
{plus}              return PLUS;

{num}+              return NUM;
{id}                return ID;
.                   return ERROR;

%%

void syntax_error(int expected, int actual)
{
    printf("Expected token %s but encountered %s in line %d.\n", token_array[expected], yytext, yylineno);
    exit(-1);
}

void syntax_error_multiple_expected(int expected[], int len, int actual)
{
    printf("Expected token %s or ", token_array[expected[0]]);
    for (int i = 1; i < len; i++)
    {
        printf("%s", token_array[expected[i]]);
        if ((i + 1) < len)
            printf(" or ");
    }
    printf(" but encountered %s in line %d.\n", yytext, yylineno);

    exit(-1);
}

void match(int t)
{
    if (token_number == t)
    {
        char* matched = yytext;
        int temp_token = token_number;
        token_number = yylex();
        printf("Matched %s of type %s, get next token %s of type %s\n", matched, token_array[temp_token], yytext, token_array[token_number]);
    }
    else
        syntax_error(t, token_number);
}

/* E –> T E’  */
void E() 
{
    T(); E_();
}

/* E’ –> + T E’ | e */
void E_()
{
    switch(token_number)
    {
        case PLUS:
            match(PLUS); T(); E_();
            break;

        case EPSILON:
            match(EPSILON);
            break;

        default:
            /* syntax_error(PLUS, token_number); */
            break;
    }
}

/* T –> F T’ */
void T()
{
    F(); T_();
}

/* T’ –> * F T’ | e  */
void T_()
{
    switch(token_number)
    {
        case MULT:
            match(MULT); F(); T_();
            break;

        case EPSILON:
            match(EPSILON);
            break;

        case ERROR:
            syntax_error(MULT, ERROR);

        default:
            /* syntax_error(MULT, token_number); */
            break;
    }
}

/* F –> ( E ) | id | num*/
void F()
{
    int f_array[3] = {LEFT_PARANTHESIS, ID, NUM};
    switch(token_number)
    {
        case LEFT_PARANTHESIS:
            match(LEFT_PARANTHESIS); E(); match(RIGHT_PARANTHESIS);
            break;

        case ID:
            match(ID);
            break;

        case NUM:
            match(NUM);
            break;
            
        default:
            syntax_error_multiple_expected(f_array, 3, token_number);
            break;
    }

}

int main(int argv, char *argc[])
{
    token_number = yylex(); // get the first token
    E();
  
    return 0;
}

int yywrap()
{
    return 1;
}