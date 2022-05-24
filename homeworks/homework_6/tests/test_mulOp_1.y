%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "ast_symtab.h"
    int yyerror(char *s);
    int yylex();

%}

%token MULT
%token DIVIDE
%token DIV
%token MOD
%token AND 

%token exit_command

%union {
    int operator_type;
    // struct N_STMT statement;
} 

/* %type <while_stmt> whileStmt */

%type <operator_type> mulOp

%start mulOp

%%



mulOp           : MULT                                  { $$ = MULT_OP; }
                | DIVIDE                                { $$ = SLASH_OP; }
                | DIV                                   { $$ = DIV_OP; }
                | MOD                                   { $$ = MOD_OP; }
                | AND                                   { $$ = AND_OP; }
                | mulOp exit_command                    { return $1; }
                ;


%%
int main(void) 
{ 
    int result = yyparse();
    printf("Result: %d\n", result);
}

int yyerror(char *s) 
{ 
    fprintf(stderr, "%s\n", s); return 0; 
}