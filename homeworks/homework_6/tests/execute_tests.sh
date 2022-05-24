#!/bin/sh

# list of files to remove in cleanup step
remove_file_list=(lex.yy.c y.tab.c y.tab.h out)

# only look for yacc files with the prefix "test_"
for test_name in "test_*.y" 
do
    # generate test files
    yacc -d $test_name
    lex ast_lexer_1.l y.tab.h
    gcc lex.yy.c y.tab.c -o out

    ./out < test_mulOp_1.txt > test_1_actual.txt
    if cmp "test_1_actual.txt" "test_1_expected.txt"; then
        echo "True"
    else
        echo "False"
    fi


    # cleanup
    for remove_file in ${remove_file_list[@]} 
    do
        rm $remove_file
    done
done