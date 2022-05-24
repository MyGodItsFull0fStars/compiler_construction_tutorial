%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "ast_symtab.h"
    int yyerror(char *s);
    int yylex();

    const N_PROG * root_node = ast;
%}

%token PROGRAM 
%token IDENT
%token SEMICOLON
%token DOT
%token VAR
%token COLON
%token COMMA
%token ARRAY
%token OF
%token OP_BRACKET
%token CL_BRACKET
%token NUM
%token TWO_DOTS
%token INTEGER
%token BOOLEAN
%token REAL
%token FUNCTION
%token PROCEDURE
%token OP_PARANTHESIS
%token CL_PARANTHESIS
%token ASSIGN
%token BEGIN_KW
%token END_KW
%token IF
%token THEN
%token ELSE
%token WHILE
%token DO
%token FALSE_KW
%token TRUE_KW
%token NOT
%token MINUS
%token LESS
%token LESS_EQUAL
%token GREATER
%token GREATER_EQUAL
%token EQUAL
%token NOT_EQUAL
%token PLUS
%token OR
%token MULT
%token DIVIDE
%token DIV
%token MOD
%token AND 

%union {
    N_STMT statement; 
    N_WHILE while_stmt;
} 

%type <while_stmt> whileStmt


%start start

%%

/* 
start -> PROGRAM IDENT ; varDec subProgList compStmt . */
start           : PROGRAM IDENT SEMICOLON varDec subProgList compStmt DOT       { ast = ...;
return ast;}    
                ;

varDec          : VAR varDecList
                |
                ;

varDecList      : identListType SEMICOLON varDecList_
                ;

varDecList_     : identListType SEMICOLON varDecList_
                |
                ;

identListType   : identList COLON type
                ;

identList       : IDENT identList_
                ;

identList_      : COMMA IDENT identList_
                |
                ;

type            : simpleType
                | ARRAY OP_BRACKET NUM TWO_DOTS NUM CL_BRACKET OF simpleType
                ;

simpleType      : INTEGER       { $$ = INTEGER; }
                | BOOLEAN       { $$ = BOOLEAN; }
                | REAL          { $$ = REAL; }
                ;

subProgList     : subProgHead varDec compStmt SEMICOLON subProgList
                |
                ;

subProgHead     : FUNCTION IDENT args COLON type SEMICOLON
                | PROCEDURE IDENT args SEMICOLON
                ;

args            : OP_PARANTHESIS parList CL_PARANTHESIS
                |
                ;

parList         : identListType parList_
                ;

parList_        : SEMICOLON identListType parList_
                |
                ;

compStmt        : BEGIN_KW stmtList END_KW                  { $$ = $1; }
                ;


stmtList        : statement stmtList_                       {
                                                                N_STMT stmt = $1;
                                                                stmt.next = $2;
                                                                $$ = stmt;
                                                            }
                ;

stmtList_       : SEMICOLON statement stmtList_             { 
                                                                N_STMT stmt = $2;
                                                                stmt.next = $3;
                                                                $$ = stmt;
                                                            }
                |
                ;

statement       : procCall                                  { $$ = (N_STMT) {.typ = _PROC_CALL, .node.proc_call = $1}; }
                | assignStmt                                { $$ = (N_STMT) {.typ = _ASSIGN, .node.assign_stmt = $1}; }
                | compStmt                                   { $$ = $1;}
                | ifStmt                                    { $$ = (N_STMT) {.typ = _IF, .node.if_stmt = $1}; }
                | whileStmt                                 { $$ = (N_STMT) {.typ = _WHILE, .node.while_stmt = $1}; }
                ;

procCall        : IDENT procCall_                           { $$ = (N_CALL) {.id = $1, .par_list = $2}; }
                ;

procCall_       : params                                    { $$ = $1; }
                | 
                ;

params          : OP_PARANTHESIS exprList CL_PARANTHESIS
                ;

assignStmt      : IDENT assignStmt_
                ;

assignStmt_     : index ASSIGN expr
                | ASSIGN expr
                ;

index           : OP_BRACKET expr index_
                ;

index_          : CL_BRACKET
                | TWO_DOTS expr CL_BRACKET
                ;

ifStmt          : IF expr THEN statement elsePart           { $$ = (N_IF) {.expr = $2, .then_part = $3, .else_part = $4}; }
                ;

elsePart        : ELSE statement                            { $$ = $1; }
                |
                ;

whileStmt       : WHILE expr DO statement                   { $$ = (N_WHILE) {.expr = $2, .stmt = $4}; }
                ;

exprList        : expr exprList_
                ;

exprList_       : COMMA expr exprList_
                |
                ;

expr            : simpleExpr expr_
                ;

expr_           : relOp simpleExpr
                |
                ;

simpleExpr      : term simpleExpr_
                ;

simpleExpr_     : addOp term simpleExpr_
                |
                ;

term            : factor term_
                ;

term_           : mulOp factor term_
                |
                ;

factor          : NUM                                   { $$ = NUM; }
                | FALSE_KW                              { $$ = FALSE_KW; }
                | TRUE_KW                               { $$ = TRUE_KW; }
                | IDENT factor_
                | NOT factor
                | MINUS factor
                | OP_PARANTHESIS expr CL_PARANTHESIS
                ;

factor_         : index
                | params
                |
                ;

relOp           : LESS                                  { $$ = LT_OP; }
                | LESS_EQUAL                            { $$ = LE_OP; }
                | GREATER                               { $$ = GT_OP; }
                | GREATER_EQUAL                         { $$ = GE_OP; }
                | EQUAL                                 { $$ = EQ_OP; }
                | NOT_EQUAL                             { $$ = NE_OP; }
                ;

addOp           : PLUS                                  { $$ = PLUS_OP; }
                | MINUS                                 { $$ = MINUS_OP; }
                | OR                                    { $$ = OR_OP; }
                ;

mulOp           : MULT                                  { $$ = MULT_OP; }
                | DIVIDE                                { $$ = SLASH_OP; }
                | DIV                                   { $$ = DIV_OP; }
                | MOD                                   { $$ = MOD_OP; }
                | AND                                   { $$ = AND_OP; }
                ;


%%
int main(void) { 
    yyparse(); 
    printf(ast);
    }
int yyerror(char *s) { fprintf(stderr, "%s\n", s); return 0; }