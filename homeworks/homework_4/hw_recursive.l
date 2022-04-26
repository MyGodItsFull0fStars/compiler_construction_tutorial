%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>

    // TERMINALS
    #define ERROR                       0
    #define EPSILON                     1
    #define PROGRAM                     2
    #define IDENT                       3
    #define VAR                         4
    #define SEMICOLON                   5
    #define ARRAY                       6
    #define LEFT_BRACKET                7
    #define RIGHT_BRACKET               8
    #define NUM                         9
    #define OF                          10
    #define RANGE_DOTS                  11
    #define INTEGER                     12
    #define REAL                        13
    #define BOOLEAN                     14
    #define FUNCTION                    15
    #define PROCEDURE                   16
    #define LEFT_PARANTHESIS            17
    #define RIGHT_PARANTHESIS           18
    #define BEGIN                       19
    #define END                         20
    #define IF                          21
    #define THEN                        22
    #define ELSE                        23
    #define WHILE                       24
    #define DO                          25
    #define TRUE                        26
    #define FALSE                       27
    #define NOT                         28
    #define MINUS                       29
    #define PLUS                        30
    #define SLASH                       31
    #define DIV                         32
    #define MOD                         33
    #define AND                         34
    #define OR                          35
    #define LESS                        36
    #define LESS_EQ                     37
    #define GREATER                     38
    #define GREATER_EQ                  39
    #define EQUAL                       40
    #define NOT_EQUAL                   41
    #define DOT                         44
    #define COLON                       45
    #define COMMA                       46
    #define PARSE_END                   47

    void match(int token);
    void syntax_error(int expected, int actual);

    // PANIC MODE ERROR RECOVERY
    // SEE 4 - Top-Down Parser, slide 63
    void check_input(int[], int, int[], int);
    void scan_to(int[], int);
    bool token_in_set(int[], int);
    int* merge_sets(int[], int, int[], int);

    // NON TERMINALS
    void start();
    void varDec();
    void varDecList();
    void varDecList_();
    void identListType();
    void identList();
    void identList_();
    void type();
    void simpleType();
    void subProgList();
    void subProgHead();
    void args();
    void parList();
    void comptStmt();
    void stmtList();
    void statement();
    void procCall();
    void params();
    void assignStmt();
    void index();
    void ifStmt();
    void elsePart();
    void whileStmt();
    void exprList();
    void expr();
    void simpleExpr();
    void term();
    void factor();
    void factor_();
    void relOp();
    void addOp();
    void mulOp();

    int current_token = -1;


%}

newline         [\n]+
tab             [\t]+
space           [ ]
l_paranthesis   "("
r_paranthesis   ")"
l_bracket       "["
r_bracket       "]"
plus            "+"
mult            "*"
id              [a-zA-Z_][a-zA-Z_0-9]*

%%

{space}             ;
{tab}               ;
{newline}           {yylineno++;}
{l_paranthesis}     return LEFT_PARANTHESIS;
{r_paranthesis}     return RIGHT_PARANTHESIS;
{l_bracket}         return LEFT_BRACKET;
{r_bracket}         return RIGHT_BRACKET;
"program"           return PROGRAM;
";"                 return SEMICOLON;
"."                 return DOT;

%%

int* merge_sets(int first_set[], int first_length, int follow_set[], int follow_length)
{
    int rv[first_length + follow_length]; 
    memcpy(rv, first_set, sizeof(first_set) + 4);
    memcpy(rv+first_length, follow_set, sizeof(follow_set) + 4);
    return rv;
}

bool token_in_set(int syncset[], int length)
{
    for (int i=0; i<length; i++)
        if (current_token == syncset[i])
            return true;
    
    return false;
}

void check_input(int first_set[], int first_length, int follow_set[], int follow_length)
{
    if (token_in_set(first_set, first_length) == false)
    {
        /* ERROR */
        int *syncset = merge_sets(first_set, first_length, follow_set, follow_length);
        scan_to(syncset, first_length + follow_length);
    }
}

void scan_to(int syncset[], int length)
{
    int parse_end[] = { PARSE_END };
    while (token_in_set(syncset, length) == false || token_in_set(parse_end, 1) == false)
        current_token = yylex();
    
}

void syntax_error(int expected, int actual)
{
    printf("Expected token number %d but encountered token number %d at line %d.\n", expected, actual, yylineno);
    exit(-1);
}

void match(int expected_token)
{
    if (current_token == expected_token)
    {
        current_token = yylex();
    }
    else
        syntax_error(expected_token, current_token);
}

/* start -> PROGRAM IDENT ; varDec subProgList comptStmt . */
void start()
{
    int first_set[] = { PROGRAM };
    int follow_set[] = { PARSE_END };
    check_input(first_set, 1, follow_set, 1);

    match(PROGRAM);
    match(IDENT);
    match(SEMICOLON);
    varDec();
    subProgList();
    comptStmt();
    match(DOT);
    check_input(follow_set, 1, first_set, 1);
    exit(0);
}

/* varDec -> VAR varDecList | eps */
void varDec()
{
    int first_set[] = { VAR, EPSILON };
    int follow_set[] = { ? };
    check_input(first_set, 2, follow_set, 1);

    if (current_token == VAR)
    {
        match(VAR); varDecList();
    }
    /* NO ERROR IF NOT MATCHED BECAUSE OF EPSILON */
    check_input(follow_set, 1, first_set, 2);
}

/* varDecList -> identListType; varDecList' */
void varDecList()
{
    int first_set[] = { IDENT };
    int follow_set[] = { ? };
    check_input(first_set, 1, follow_set, 1);
    identListType(); match(SEMICOLON); varDecList_();
}

/* varDecList' -> identListType ; varDecList' | eps */
void varDecList_()
{
    if (current_token == IDENT)
    {
        identListType(); match(SEMICOLON); varDecList_();
    }
}

/* identListType -> identList : type */
void identListType()
{
    identList(); match(COLON); type();
}

/* identList -> IDENT identList' */
void identList()
{
    match(IDENT); identList_();
}

/* identList' -> , IDENT identList' */
void identList_()
{
    if (current_token == COMMA)
    {
        match(COMMA); match(IDENT); identList_();
    }
}

void factor()
{
    switch(current_token)
    {
        case NUM:
            match(NUM); break;
        case FALSE:
            match(FALSE); break;
        case TRUE;
            match(TRUE); break;
        /*  factor -> IDENT
            factor -> IDENT params
            factor -> IDENT index */
        case IDENT: 
            match(IDENT);
            factor_();
            break;
    }
}

void factor_()
{
    if (current_token == LEFT_BRACKET)
        index();
    else if(current_token == LEFT_PARANTHESIS)
        params();
}

void relOp()
{
    switch(current_token)
    {
        case LESS:
            match(LESS);
            break;
        case LESS_EQ:
            match(LESS_EQ);
            break;
        case GREATER:
            match(GREATER);
            break;
        case GREATER_EQ:
            match(GREATER_EQ);
            break;
        case EQUAL:
            match(EQUAL);
            break;
        case NOT_EQUAL:
            match(NOT_EQUAL);
            break;
    }
}

int main(int argv, char *argc[])
{
    current_token = yylex(); // get the first token
    start();
  
    return 0;
}

int yywrap()
{
    return 1;
}