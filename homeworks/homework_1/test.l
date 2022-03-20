%{
    #include <stdio.h>
    void to_uppercase(char []);
    void transform_comment(char []);
    void capitalize(char []);
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
    capitalize(yytext);
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

void transform_comment(char comment[]){
    strncpy(comment, &comment[0], strlen(comment));
    comment[strlen(comment)-2] = '\0';

    comment[0] = '(';
    comment[1] = '*';
    strcat(comment, " *)");
}

int main(int argv,char *argc[])
{
    yylex();
    return 0;
}

int yywrap()
{
    return 1;
}