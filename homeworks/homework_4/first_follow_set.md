# First and Follow Sets of Mini-Pascal Grammar

## List of Terminals

```json
"Terminals" : 
        [
            "PROGRAM",
            "IDENT", 
            "VAR", 
            "ARRAY",
            "[", "]",
            "OF",
            "NUM",
            "INTEGER",
            "REAL",
            "BOOLEAN",
            "FUNCTION",
            "PROCEDURE",
            "(", ")",
            "BEGIN", "END",
            "IF", "THEN", "ELSE",
            "WHILE", "DO",
            "TRUE", "FALSE", "NOT",
            "<", "<=", ">", ">=", "=", "<>",
            "+", "-",
            "OR",
            ";", ".", "..", ",", ":",
            "*", "/", "DIV", "MOD", "AND"
        ],
```

## List of Non-Terminals

```json
    "Non Terminals": 
        [
            "start", 
            "varDec", 
            "varDecList", 
            "identListType",
            "identList",
            "type",
            "simpleType",
            "subProgList",
            "subProgHead",
            "args",
            "parList",
            "compStmt",
            "stmtList",
            "statement",
            "procCall",
            "params",
            "assignStmt",
            "index",
            "ifStmt",
            "elsePart",
            "whileStmt",
            "exprList",
            "expr",
            "simpleExpr",
            "term",
            "factor",
            "relOp",
            "addOp",
            "mulOp"
        ],
```

## Production Rules

### ```start -> PROGRAM IDENT ; varDecl subProgList compStmt .```

`FIRST := { PROGRAM }`

`FOLLOW := { $ }`

### ```varDec -> VAR varDecList | @```

`FIRST := { VAR }`

`FOLLOW := { }`

### ```varDecList -> identListType ; varDecList'```

`FIRST := { IDENT }`

`FOLLOW := { }`

### ```varDecList' -> identListType ; varDecList' | @"```

`FIRST := { IDENT }`

`FOLLOW := { }`

### ```identListType -> identList : type```

`FIRST := { IDENT }`

`FOLLOW := { }`

### ```identList -> IDENT identList'```

`FIRST := { IDENT }`

`FOLLOW := { :,  }`

### ```identList' -> , IDENT identList'```

`FIRST := { , }`

`FOLLOW := { }`

### ```type -> simpleType | ARRAY [ NUM .. NUM ] OF simpleType```

`FIRST := { INTEGER, REAL, BOOLEAN, ARRAY }`

`FOLLOW := { }`

### ```simpleType -> INTEGER | REAL | BOOLEAN```

`FIRST := { INTEGER, REAL, BOOLEAN }`

`FOLLOW := { }`


### ```subProgList -> subProgHead varDec compStmt ; subProgHead' | @```

`FIRST := { FUNCTION, PROCEDURE }`

`FOLLOW := { }`


### ```subProgList' -> ; subProgHead varDec compStmt subProgList' | @```

`FIRST := { ;, @ }`

`FOLLOW := { }`

### ```subProgHead -> FUNCTION IDENT args : type ; | PROCEDURE IDENT args ;```

`FIRST := { FUNCTION, PROCEDURE }`

`FOLLOW := { }`

### ```args -> ( parList ) | @```

`FIRST := { (, @ }`

`FOLLOW := { }`

### ```parList -> identListType parList'```

`FIRST := { IDENT }`

`FOLLOW := { }`

### ```parList' -> ; identListType parList' | @```

`FIRST := { ;, @ }`

`FOLLOW := { }`

### ```compStmt -> BEGIN stmtList END```

`FIRST := { BEGIN }`

`FOLLOW := { }`

### ```stmtList -> statement stmtList'```

`FIRST := { IDENT, BEGIN, IF, WHILE }`

`FOLLOW := { }`

### ```stmtList' -> ; statement stmtList' | @```

`FIRST := { ;, @ }`

`FOLLOW := { }`

### ```statement -> procCall | assignStmt | compStmt | ifStmt | whileStmt```

`FIRST := { IDENT, BEGIN, IF, WHILE }`

`FOLLOW := { }`

### ```procCall -> IDENT procCall'```

`FIRST := { IDENT }`

`FOLLOW := { }`

### ```procCall' -> params | @```

`FIRST := { (, @ }`

`FOLLOW := { }`

### ```params -> ( exprList )```

`FIRST := { ( }`

`FOLLOW := { }`

### ```assignStmt -> IDENT assignStmt'```

`FIRST := { IDENT }`

`FOLLOW := { }`

### ```assignStmt' -> := expr | index := expr```

`FIRST := { :=, [ }`

`FOLLOW := { }`

### ```index -> [ expr ] | [ expr .. expr ]```

`FIRST := { [ }`

`FOLLOW := { }`

### ```ifStmt -> IF expr THEN statement elsePart```

`FIRST := { IF }`

`FOLLOW := { }`

### ```elsePart -> ELSE statement | @```

`FIRST := { ELSE, @ }`

`FOLLOW := { }`

### ```whileStmt -> WHILE expr DO statement```

`FIRST := { WHILE }`

`FOLLOW := { }`

### ```exprList -> expr exprList'```

`FIRST := { NUM, FALSE, TRUE, IDENT, NOT, -, ( }`

`FOLLOW := { }`

### ```exprList' -> , expr | @```

`FIRST := { , @ }`

`FOLLOW := { }`

### ```expr -> simpleExpr expr'```

`FIRST := { NUM, FALSE, TRUE, IDENT, NOT, -, ( }`

`FOLLOW := { }`

### ```expr' -> relOp simpeExpr | @```

`FIRST := { < , <= , > , >= , = , <> }`

`FOLLOW := { }`

### ```simpleExpr -> term simpleExpr'```

`FIRST := { NUM, FALSE, TRUE, IDENT, NOT, -, ( }`

`FOLLOW := { }`

### ```simpleExpr' -> addOp term simpleExpr' | @```

`FIRST := { +, -, OR }`

`FOLLOW := { }`

### ```term -> factor term'```

`FIRST := { NUM, FALSE, TRUE, IDENT, NOT, -, ( }`

`FOLLOW := { }`

### ```term' -> mulOp factor term' | @```

`FIRST := { *, /, DIV, MOD, AND }`

`FOLLOW := { }`

### ```factor -> NUM | FALSE | TRUE | IDENT factor' | NOT factor | - factor | (expr)```

`FIRST := { NUM, FALSE, TRUE, IDENT, NOT, -, ( }`

`FOLLOW := { }`

### ```factor' -> index | params | @```

`FIRST := { [, (, @ }`

`FOLLOW := { }`

### ```relOp -> < | <= | > | >= | = | <>```

`FIRST := { < , <= , > , >= , = , <> }`

`FOLLOW := { }`

### ```addOp -> + | - | OR```

`FIRST := { +, -, OR }`

`FOLLOW := { }`

### ```mulOp -> * | / | DIV | MOD | AND```

`FIRST := { *, /, DIV, MOD, AND }`

`FOLLOW := { }`
