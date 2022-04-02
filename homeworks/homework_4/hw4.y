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
%token NUM
%token OF
%token INTEGER
%token REAL
%token BOOLEAN
%token FUNCTION
%token PROCEDURE
%token BEGIN
%token END


%token SEMICOLON
%token COLON
%token DOT
%token COMMA
%token LEFT_BRACKET
%token RIGHT_BRACKET
%token DOUBLEDOT
%token LEFT_PARANTHESIS
%token RIGHT_PARANTHESIS


%%

start       :       PROGRAM IDENT SEMICOLON varDec subProgList compStmt'.'              {}

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