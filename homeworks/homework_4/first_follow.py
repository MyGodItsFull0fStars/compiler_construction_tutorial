import sys
import json
sys.setrecursionlimit(60)

def first(string):
    #print("first({})".format(string))
    first_ = set()
    if string in non_terminals:
        alternatives = productions_dict[string]

        for alternative in alternatives:
            first_2 = first(alternative)
            first_ = first_ |first_2

    elif string in terminals:
        first_ = {string}

    elif string=='' or string=='@':
        first_ = {'@'}

    else:
        first_2 = first(string[0])
        if '@' in first_2:
            i = 1
            while '@' in first_2:
                #print("inside while")

                first_ = first_ | (first_2 - {'@'})
                #print('string[i:]=', string[i:])
                if string[i:] in terminals:
                    first_ = first_ | {string[i:]}
                    break
                elif string[i:] == '':
                    first_ = first_ | {'@'}
                    break
                first_2 = first(string[i:])
                first_ = first_ | first_2 - {'@'}
                i += 1
        else:
            first_ = first_ | first_2


    #print("returning for first({})".format(string),first_)
    return  first_


def follow(non_terminal):
    #print("inside follow({})".format(nT))
    follow_ = set()
    #print("FOLLOW", FOLLOW)
    prods = productions_dict.items()
    if non_terminal==starting_symbol:
        follow_ = follow_ | {'$'}
    for nt,rhs in prods:
        #print("nt to rhs", nt,rhs)
        for alt in rhs:
            for char in alt:
                if char==non_terminal:
                    following_str = alt[alt.index(char) + 1:]
                    if following_str=='':
                        if nt==non_terminal:
                            continue
                        else:
                            follow_ = follow_ | follow(nt)
                    else:
                        follow_2 = first(following_str)
                        if '@' in follow_2:
                            follow_ = follow_ | follow_2-{'@'}
                            follow_ = follow_ | follow(nt)
                        else:
                            follow_ = follow_ | follow_2
    #print("returning for follow({})".format(nT),follow_)
    return follow_


terminals = []
non_terminals = []
productions = []
productions_dict = {}
starting_symbol = None

def terminal_prompt():
    no_of_terminals=int(input("Enter no. of terminals: "))


    print("Enter the terminals :")
    for _ in range(no_of_terminals):
        terminals.append(input())


def non_terminal_prompt():
    no_of_non_terminals=int(input("Enter no. of non terminals: "))


    print("Enter the non terminals :")
    for _ in range(no_of_non_terminals):
        non_terminals.append(input())

def start_symbol_prompt():
    starting_symbol = input("Enter the starting symbol: ")

def production_prompt():
    no_of_productions = int(input("Enter no of productions: "))


    print("Enter the productions:")
    for _ in range(no_of_productions):
        productions.append(input())


def load_config(file_path: str = 'grammar.json'):
    with open(file_path, 'r') as file:
        json_file = json.load(file)
        starting_symbol = json_file['Start']
        terminals = json_file['Terminals']
        non_terminals = json_file['Non Terminals']
        productions = json_file['Production Rules']

    return starting_symbol, terminals, non_terminals, productions

starting_symbol, terminals, non_terminals, productions = load_config()
        



#print("terminals", terminals)

#print("non terminals", non_terminals)

#print("productions",productions)

for non_terminal in non_terminals:
    productions_dict[non_terminal] = []


#print("productions_dict",productions_dict)

for production in productions:
    nonterm_to_prod = production.split("->")
    alternatives = nonterm_to_prod[1].split("|")
    for alternative in alternatives:
        productions_dict[nonterm_to_prod[0]].append(alternative)

#print("productions_dict",productions_dict)

#print("nonterm_to_prod",nonterm_to_prod)
#print("alternatives",alternatives)


FIRST = {}
FOLLOW = {}

for non_terminal in non_terminals:
    FIRST[non_terminal] = set()
    FOLLOW[non_terminal] = set()

#print("FIRST",FIRST)

for non_terminal in non_terminals:
    FIRST[non_terminal] = FIRST[non_terminal] | first(non_terminal)

#print("FIRST",FIRST)


FOLLOW[starting_symbol] = FOLLOW[starting_symbol] | {'$'}
for non_terminal in non_terminals:
    FOLLOW[non_terminal] = FOLLOW[non_terminal] | follow(non_terminal)

#print("FOLLOW", FOLLOW)

print("{: ^20}{: ^20}{: ^20}".format('Non Terminals','First','Follow'))
for non_terminal in non_terminals:
    print("{: ^20}{: ^20}{: ^20}".format(non_terminal,str(FIRST[non_terminal]),str(FOLLOW[non_terminal])))
