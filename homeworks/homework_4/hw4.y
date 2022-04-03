%{
    void yyerror (char *s);
    #include <stdio.h>
    #include <stdlib.h>
    int symbols[52]; // [a-zA-Z]

%}

%union {int num; char* id; bool boolean; void none;}
%start start

%token PROGRAM
%token IDENT
%token VAR
%token ARRAY
%token OF
%token FUNCTION
%token PROCEDURE
%token BEGIN
%token END

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



%%

start       :       PROGRAM IDENT SEMICOLON varDec subProgList compStmt DOT             {}

varDec      :       VAR varDecList                                                      {}
            |       ;                                                                   {}

varDecList  :       varDecList identListType SEMICOLON                                  {}
            |       identListType SEMICOLON                                             {}

identListType   :   identList COLON type                                                

identList       :   identList',' IDENT                                                  {}
                |   IDENT                                                               {}

type            :   simpleType                                                          {}
                |   ARRAY LEFT_BRACKET NUM DOUBLEDOT NUM RIGHT_BRACKET OF simpleType    {}

simpleType      :   INTEGER                                                             {}
                |   REAL                                                                {}
                |   BOOLEAN                                                             {}

subProgList     :   subProgList subProgHead varDec compStmt SEMICOLON                   {}
                |   ;                                                                   {}

subProgHead     :   FUNCTION IDENT args COLON type SEMICOLON                            {}
                |   PROCEDURE IDENT args SEMICOLON                                      {}

args            :   LEFT_PARANTHESIS parList RIGHT_PARANTHESIS                          {}
                |   ;                                                                   {}

parList         :   parList SEMICOLON identListType                                     {}
                |   identListType                                                       {}

compStmt        :   BEGIN stmtList END                                                  {}

stmtList        :   stmtList SEMICOLON statement                                        {}
                |   statement                                                           {}


statement       :   procCall                                                            {}
                |   assignStmt                                                          {}
                |   compStmt                                                            {}
                |   ifStmt                                                              {}
                |   whileStmt                                                           {}

procCall        :   IDENT                                                               {}
                |   IDENT params                                                        {}

params          :   LEFT_PARANTHESIS exprList RIGHT_PARANTHESIS                         {}

assignStmt      :   IDENT ASSIGN expr                                                   {}
                |   IDENT index ASSIGN expr                                             {}

index           :   LEFT_BRACKET expr RIGHT_BRACKET                                     {}
                |   LEFT_BRACKET expr DOUBLEDOT expr RIGHT_BRACKET                      {}

ifStmt          :   IF expr THEN statement elsePart                                     {}

elsePart        :   ELSE statement                                                      {}
                |   ;                                                                   {}

whileStmt       :   WHILE expr DO statement                                             {}

exprList        :   exprList COMMA expr                                                 {}
                |   expr                                                                {}

expr            :   simpleExpr relOp simpleExpr                                         {}
                |   simpleExpr                                                          {}

simpleExpr      :   simpleExpr addOp term                                               {}
                |   term                                                                {}

term            :   term mulOp factor                                                   {}
                |   factor                                                              {}

factor          :   NUM                                                                 {}
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