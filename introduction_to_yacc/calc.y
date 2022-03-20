%{
    void yyerror (char *s);
    #include <stdio.h>
    #include <stdlib.h>
    int symbols[52];
    int symbol_val(char symbol);
    void update_symbol_val(char symbol, int val);
%}

%union {int num; char id;} 
%start line     /* denotes the starting rule */
%token print    
%token exit_command
%token <num> number
%token <id> identifier
%type <num> line exp term
%type <id> assignment

%%

line        :   assignment ';'          {;}
            |   exit_command ';'        {exit(EXIT_SUCCESS);}
            |   print exp ';'           {printf("Printing %d\n", $2);}
            |   line assignment ';'     {;}
            |   line print exp ';'      {printf("Printing %d\n", $3);}
            |   line exit_command ';'   {exit(EXIT_SUCCESS);}
            ;

assignment  :   identifier '=' exp      {update_symbol_val($1, $3);} 
            ;

exp         :   term                    {$$ = $1;}
            |   exp '+' term            {$$ = $1 + $3;}
            |   exp '-' term            {$$ = $1 - $3;}
            ;

term        :   number                  {$$ = $1;}
            |   identifier              {$$ = symbol_val($1);}
            ;


%%  /* C code */

int compute_symbol_index(char token)
{
    int idx = -1;
    if (islower(token)) 
    {
        idx = token - 'a' + 26;
    }
    else if (isupper(token)) 
    {
        idx = token - 'A';
    }
    return idx;
}

/* returns the value of a given symbol */
int symbol_val(char symbol)
{
    int bucket = compute_symbol_index(symbol);
    return symbols[bucket];
}

/* updates the value of a given symbol */
void update_symbol_val(char symbol, int val)
{
    int bucket = compute_symbol_index(symbol);
    symbols[bucket] = val;
}

int main (void)
{
    /* init symbol table */
    int i;
    for (i = 0; i < 52; i++)
        symbols[i] = 0;
    
    return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);}