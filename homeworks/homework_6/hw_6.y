%{
    #include <stdio.h>
    #include <stdlib.h>

    #include "ast_symtab.h"

    void yyerror (char *s);
    extern int yylex();

    void print_ast(N_PROG *ast);

    extern char *yytext;
    extern int yychar;
    extern int yylineno;
    extern N_PROG* ast;

    BOOLEAN* get_boolean(int);
    DATA_TYPE* get_data_type(int);
    N_PROG* get_prog(N_STMT*, N_PROG*);

    N_STMT* get_assign_stmt(N_ASSIGN*);
    N_STMT* get_while_stmt(N_WHILE*);
    N_STMT* get_if_stmt(N_IF*);
    N_STMT* get_proc_call(N_CALL*);

    N_EXPR* get_constant_expr(char* constant);
    N_EXPR* get_var_ref_expr(N_VAR_REF*);
    N_EXPR* get_operation_expr(int, N_EXPR*, N_EXPR*);
    N_EXPR* get_func_call_expr(N_CALL*);

    N_WHILE* get_while(N_EXPR*, N_STMT*);
    N_IF* get_if(N_EXPR*, N_STMT*, N_STMT*);
    N_VAR_REF* get_var_ref(char*, N_EXPR*);
    N_ASSIGN* get_assign(N_VAR_REF*, N_EXPR*);
    N_CALL* get_call(char*, N_EXPR*);
%}

%start start /* denotes the stating rule */

%token<id> PROGRAM
%token<id> IDENT
%token<id> VAR
%token<id> ARRAY
%token<id> OF
%token<id> FUNCTION
%token<id> PROCEDURE
%token<id> BEGIN
%token<id> END

%token NUM
%token INTEGER
%token REAL
%token BOOLEAN
%token FALSE
%token TRUE

%token SEMICOLON
%token COLON
%token DOT
%token COMMA
%token LEFT_BRACKET
%token RIGHT_BRACKET
%token DOUBLEDOT
%token LEFT_PARANTHESIS
%token RIGHT_PARANTHESIS
%token ASSIGN
%token IF
%token THEN
%token ELSE
%token WHILE
%token DO
%token NOT

%token PLUS
%token MINUS
%token MULT
%token DIVISION
%token DIV
%token MOD
%token AND

%token LESS
%token LESS_EQUAL
%token GREATER
%token GREATER_EQUAL
%token EQUAL
%token NOT_EQUAL
%token OR


%union {
    char *char_val;
    int int_val;
    struct BOOLEAN *boolean_val;
    struct DATA_TYPE *data_type_val;
    struct tN_PROG *prog_val;
    struct tN_STMT *stmt_val;
    struct tN_EXPR *expr_val;
    struct tN_WHILE *while_val;
    struct tN_IF *if_val;
    struct tN_VAR_REF *var_ref_val;
    struct tN_ASSIGN *assign_val;
    struct tN_CALL *call_val;
}

%type<int_val> addOp mulOp relOp;
%type<prog_val> start subProgList
%type<stmt_val> statement stmtList compStmt elsePart
%type<expr_val> expr factor index exprList params term simpleExpr
%type<while_val> whileStmt
%type<if_val> ifStmt
%type<assign_val> assignStmt
%type<call_val> procCall


%%

start       :       PROGRAM IDENT SEMICOLON varDec subProgList compStmt DOT             { ast = get_prog($6, $5); }
            ;

varDec      :       VAR varDecList                                                      {}
            |                                                                           {}
            

varDecList      :   identListType SEMICOLON varDecList_                                 {}

varDecList_     :   identListType SEMICOLON varDecList_                                 {}
                |                                                                       {}

identListType   :   identList COLON type                                                

identList       :   IDENT identList_                                                    {}

identList_      :   COLON IDENT identList_                                              {}
                ;

type            :   simpleType                                                          {}
                |   ARRAY LEFT_BRACKET NUM DOUBLEDOT NUM RIGHT_BRACKET OF simpleType    {}

simpleType      :   INTEGER                                                             { }
                |   REAL                                                                {}
                |   BOOLEAN                                                             {}


subProgList     :   subProgHead varDec compStmt SEMICOLON subProgList_                  {}
                ;


subProgList_    :   SEMICOLON subProgHead varDec compStmt subProgList_                  {}
                ;

subProgHead     :   FUNCTION IDENT args COLON type SEMICOLON                            {}
                |   PROCEDURE IDENT args SEMICOLON                                      {}

args            :   LEFT_PARANTHESIS parList RIGHT_PARANTHESIS                          {}

parList         :   identListType parList_                                              {}

parList_        :   SEMICOLON identListType parList_                                    {}

compStmt        :   BEGIN stmtList END                                                  {}

stmtList        :   statement stmtList_                                                 {}

stmtList_       :   SEMICOLON statement stmtList_                                       {}

statement       :   procCall                                                            {}
                |   assignStmt                                                          {}
                |   compStmt                                                            {}
                |   ifStmt                                                              {}
                |   whileStmt                                                           {}

procCall        :   IDENT procCall_                                                     {}
                

/* procCall' -> params | @ */
procCall_       :   params                                                              {}
                ;

/* params -> ( exprList ) */
params          :   LEFT_PARANTHESIS exprList RIGHT_PARANTHESIS                         {}

/* assignStmt -> IDENT assignStmt' */
assignStmt      :   IDENT assignStmt_                                                   { }

/* assignStmt' -> := expr | index := expr */
assignStmt_     :   ASSIGN expr                                                         {}
                |   index ASSIGN expr                                                   {}

/* index -> [ expr index' */
index           :   LEFT_BRACKET expr index_                                            {}

/* index' -> ] | .. expr ] */
index_          :   RIGHT_BRACKET                                                       {}
                |   DOUBLEDOT expr RIGHT_BRACKET                                        {}

ifStmt          :   IF expr THEN statement elsePart                                     {}

elsePart        :   ELSE statement                                                      {}
                |                                                                       {}

whileStmt       :   WHILE expr DO statement                                             {}

exprList        :   exprList COMMA expr                                                 {}
                |   expr                                                                {}

expr            :   simpleExpr relOp simpleExpr                                         {}
                |   simpleExpr                                                          {}

simpleExpr      :   simpleExpr addOp term                                               {}
                |   term                                                                {}

term            :   term mulOp factor                                                   {}
                |   factor                                                              { $$=$1; }

factor          :   NUM                                                                 { }
                |   FALSE                                                               {}
                |   TRUE                                                                {}
                |   IDENT                                                               {}
                |   IDENT index                                                         {}
                |   IDENT params                                                        {}
                |   NOT factor                                                          {}
                |   MINUS factor                                                        {}
                |   LEFT_PARANTHESIS expr RIGHT_PARANTHESIS                             {}

relOp           :   LESS                                                                {}
                |   LESS_EQUAL                                                          {}
                |   GREATER                                                             {}
                |   GREATER_EQUAL                                                       {}
                |   EQUAL                                                               {}
                |   NOT_EQUAL                                                           {}                     

addOp           :   PLUS                                                                {}
                |   MINUS                                                               {}
                |   OR

mulOp           :   MULT                                                                {}
                |   DIVISION                                                            {}
                |   DIV                                                                 {}
                |   MOD                                                                 {}
                |   AND                                                                 {}




%%

/* YACC AST FUNCTIONS */

DATA_TYPE* get_data_type(int data_type_id)
{
    /* TODO */
}

BOOLEAN* get_boolean(int boolean_id)
{
    /* TODO */
}

N_PROG* get_prog(N_STMT* stmt_, N_PROG* prog_)
{
    /* TODO */
}

N_STMT* get_assign_stmt(N_ASSIGN* assign_)
{
    /* TODO */
}
N_STMT* get_while_stmt(N_WHILE* while_)
{
    /* TODO */
}
N_STMT* get_if_stmt(N_IF* if_)
{
    /* TODO */
}
N_STMT* get_proc_call(N_CALL* call_)
{
    /* TODO */
}

N_EXPR* get_constant_expr(char* constant_)
{
    /* TODO */
}
N_EXPR* get_var_ref_expr(N_VAR_REF* var_ref_)
{
    /* TODO */
}
N_EXPR* get_operation_expr(int, N_EXPR* x, N_EXPR* y)
{
    /* TODO */
}
N_EXPR* get_func_call_expr(N_CALL* call_)
{
    /* TODO */
}

N_WHILE* get_while(N_EXPR* expr_, N_STMT* stmt_)
{
    /* TODO */
}
N_IF* get_if(N_EXPR* expr_, N_STMT* then_, N_STMT* else_)
{
    /* TODO */
}
N_VAR_REF* get_var_ref(char* id_, N_EXPR* expr_)
{
    /* TODO */
}
N_ASSIGN* get_assign(N_VAR_REF* var_ref_, N_EXPR* expr_)
{
    /* TODO */
}
N_CALL* get_call(char* id_, N_EXPR* par_list_)
{
    /* TODO */
}

 /* C code */

void print_ast(N_PROG *ast)
{
    if (ast->next != null)
    {
        printf("PROGRAM IDENT; ");
        
    }
}

int yyerror(char *s)
{
    fprintf(stderr, "Cause: $s at character: %d\n", yytext, yychar);
    fprintf(stderr, "%s", s);
    fprintf(stderr, "Error on line: %d\n", yylineno);
    return 1;
}

int main(void)
{
    yyparse();
    return 0;
}

void yyerror(char *s) {fprintf(stderr, "%s\n", s);}