#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

int* merge_sets(int first_set[], int first_length, int follow_set[], int follow_length)
{
    int rv[first_length + follow_length]; 
    memcpy(rv, first_set, sizeof(first_set) + 4);
    memcpy(rv+first_length, follow_set, sizeof(follow_set) + 4);
    return rv;
}

bool token_in_set(int current_token, int syncset[], int length)
{
    for (int i=0; i<length; i++)
        if (current_token == syncset[i])
            return true;
    
    return false;
}

int main()
{

    int first[] = {1, 3, 5};
    int follow[] = {34, 6};

    int* test = merge_sets(first, 3, follow, 2);

    for (int i=0; i<5; i++)
    {
        printf("%d, ", test[i]);
    }
    printf("\n");

    bool answer = token_in_set(2, test, 5);
    printf("%d\n", answer);

    return 0;
}