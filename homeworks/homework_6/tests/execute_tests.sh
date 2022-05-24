#!/bin/sh

# list of files to remove in cleanup step
remove_file_list=(lex.yy.c y.tab.c y.tab.h out)


# only look for yacc files with the prefix "test_"
for test_name in test_*.y
do
    # generate test files
    yacc -d $test_name

    # split test_name to retrieve file_name without extention


    IFS='.' # SET DELIMITER
    read -ra ADDR <<< "$test_name"
    PREFIX=${ADDR[0]}
    IFS='' # RETURN DELIMITER TO DEFAULT VALUE

    lex ast_lexer_1.l y.tab.h
    gcc lex.yy.c y.tab.c -o out

    # Provide input and store result in separate file
    ./out < "$PREFIX.txt" > test_1_actual.txt

    if cmp "$PREFIX"_actual.txt "$PREFIX"_expected.txt; then
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