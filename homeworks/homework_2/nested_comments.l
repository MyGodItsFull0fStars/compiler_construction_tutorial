%{
    #include <stdio.h>
    void transform_comment(char []);
    int get_comment_nesting_level(char []);

    int comment_count = 0;
    int max_nesting_level = 0;
%}

letter          [a-zA-Z_]
digit           [0-9]
rel_OP          "<"|">"|"="
math_OP         "+"|"-"|"*"|"/"
whitespace      [ \t\n]    
paranthesis     "("|")"
bracket         "["|"]"
newline         "\n"
comment         (\{.+\})

%%

[ ]+        {
    putchar(' ');
}

[\t]+     {
    printf("\t");
}

[\n]+        {
    printf("\n");
}
{comment}   {
    transform_comment(yytext);
    comment_count++;

    int comment_nesting_level = get_comment_nesting_level(yytext);
    if (max_nesting_level < comment_nesting_level)
        max_nesting_level = comment_nesting_level;
    
    printf("%s", yytext);
}

uses | 
div | 
not | 
if | 
then | 
else | 
of | 
while | 
do | 
begin | 
end | 
read | 
write | 
var | 
array | 
function | 
procedure | 
program | 
true | 
false | 
char | 
integer | 
boolean {     
    printf("%s", yytext);
}



%%

void capitalize(char data[])
{
    if (data[0] >= 'a' && data[0] <= 'z') 
        {
            data[0] = data[0] - 32;
        }
}

void to_uppercase(char data[])
{
    int i = 0;

    while (data[i] != '\0')
    {
        if (data[i] >= 'a' && data[i] <= 'z') 
        {
            data[i] = data[i] - 32;
        }
        i++;
    }
}

int get_comment_nesting_level(char data[])
{
    int nest_level = -1;
    int num_left_paranthesis = 0;
    int num_right_parantheis = 0;
    int i = 0;

    while (data[i] != '\0')
    {
        if (data[i] == '(' && data[i+1] == '*')
        {
            num_left_paranthesis++;
            i += 2;
            continue;
        }

        else if (data[i] == '*' && data[i+1] == ')')
        {
            num_right_parantheis++;
            i += 2;
            continue;
        }
        i++;
    }
    if (num_left_paranthesis == num_right_parantheis)
        nest_level = num_left_paranthesis;

    return nest_level;
}

void transform_comment(char comment[]){
    strncpy(comment, &comment[0], strlen(comment));
    comment[strlen(comment)-2] = '\0';

    comment[0] = '(';
    comment[1] = '*';
    strcat(comment, " *)");
}

int main(int argv, char *argc[])
{
    yylex();
    printf("Max Nesting Level: %d", max_nesting_level);
    return 0;
}

int yywrap()
{
    return 1;
}