%%

statements: statement {printf("statement");} | statement statements {printf("Statements\n");}

statement: identifier '+' identifier {printf("plus\n"); $$ = $1 + $3;}

statement: identifier '-' identifier {printf("minus\n"); $$ = $1 - $3;}

%% 