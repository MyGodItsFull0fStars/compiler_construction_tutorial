#include <stdio.h>
#include <stdlib.h>

#include "ast_symtab.h"

void print_statement(N_STMT);
void print_entry(ENTRY);
void print_entry_const(ENTRY);

int main(void)
{

    // const N_PROG *root_node = ast;

    BOOLEAN bool = _FALSE;
    printf("%d\n", bool);

    DATA_TYPE dt = _REAL;
    printf("%d\n", dt);

    ENTRY entry = (ENTRY){.typ = _CONST, .data_type = _REAL, .base.real_val = 3.141593, .ext = NULL, .next = NULL};

    ENTRY const_entry = (ENTRY){.typ = _CONST, .data_type = _INT, .base.int_val = 5};
    
    print_entry(const_entry);
    print_entry(entry);

    N_EXPR *expression = &(N_EXPR) {.typ=CONSTANT, .desc.constant="Super Constant", .next=NULL}; 
    N_IF *if_statement = &(N_IF){.expr=expression, .then_part=NULL, .else_part=NULL};
    N_STMT statement = (N_STMT){.typ=_IF, .node.if_stmt=if_statement, .next=NULL};

    print_statement(statement);

    printf("%d\n", EQ_OP);
    return 0;
}

void print_statement(N_STMT statement)
{
    switch (statement.typ)
    {
    case _ASSIGN:
        /* code */
        break;
    case _IF:
        printf("If Statement\n");
        printf("%s\n", statement.node.if_stmt->expr->desc.constant);
        break;
    case _WHILE:
        break;
    case _PROC_CALL:
        break;
    default:
        break;
    }
}

void print_entry(ENTRY entry)
{
    switch (entry.typ)
    {
    case _CONST:
        print_entry_const(entry);
        break;
    case _VAR:
        break;
    case _ARRAY:
        break;
    case _PROG:
        break;

    default:
        break;
    }
}

void print_entry_const(ENTRY entry)
{
    switch (entry.data_type)
    {
    case _BOOL:
        printf("Boolean Entry Value: %d\n", entry.base.bool_val);
        break;

    case _INT:
        printf("Constant Entry Value: %d\n", entry.base.int_val);
        break;

    case _REAL:
        printf("Real Entry Value: %f\n", entry.base.real_val);
        break;

    case _VOID: /* See ast_symtab.h line 24 and 29 */
        printf("Procedure Name: %s\n", entry.base.id);
        break;
    default:
        break;
    }
}

// void print_entry_var(ENTRY entry)
// {
//     switch (entry.data_type)
//     {
//     case: /* constant-expression */
//         /* code */
//         break;

//     default:
//         break;
//     }
// }