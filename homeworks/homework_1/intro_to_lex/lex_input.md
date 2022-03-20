# lex input

`FIRST PART` (optional part)

- Can contain lines that control dimensions of tables that are internal for LEX,
- It can contain definitions for text replacements,
- It can also contain global C code that is going to be utilized by the actions and there is a special syntax for including C code in the `FIRST PART`

%%

`SECOND PART`

- Is used to define regular expressions

pattern             action
......

%%

`THIRD PART` (also optional)

- It is used for C code.
- So different functions that are used in the actions, are defined here.


## Using Lex

- `lex lex_file_name.l`
- `cc lex.yy.c -ll`
- `./a.out`


## lex pattern examples

- `abc` - Match the string "abc".
- `[a-zA-Z] - Match any lower or uppercase letter.
- ``dog.*cat` - Match any string starting with dog, and ending with cat.
- `(ab)+` - Match one or more occurrences of "ab" concatenated.
- `[^a-z]+ - Matches any string of one or more chararcters that do not include lower case a-z.
- [+-]?[0-9]+ - Match any string of one or more digits with an optional prefix of + or -.
