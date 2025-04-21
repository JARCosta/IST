# Ponteiros e Alocação Dinâmica de Memória

## ex01

Implemente um programa em C que leia uma palavra do standard input e que
imprima todos os sufixos dessa palavra.  O programa deverá imprimir um sufixo
por linha começando do mais comprido para o menos comprido.

Por exemplo, para o input `abc` o output deve ser:

    abc
    bc
    c

Poderá supor que a palavra nunca terá mais de 1000 caracteres.

*Dica:* Sugere-se utilização de aritmética de ponteiros, para poder avançar com
um ponteiro `p` representando os diferentes sufixos e passar esse ponteiro `p`
como parâmetro para a função `printf`.

## ex02

Implemente um programa em C que leia uma sequência de palavras do standard
input e imprima as mesmas na ordem inversa.  O programa deverá imprimir uma
palavra por linha começando pela última palavra.

Por exemplo, para o input `abcd foo bar` o output deve ser:

    bar
    foo
    abcd

Poderá supor que a palavra nunca terá mais de 1000 caracteres, que não aparacem
mais que 10000 palavras e que cada palavra pode ser lida com `scanf("%s", s)`.

*Dica:* Guarde as palavras como um vector de strings.  Primeiro leia a palavra
dentro de uma string com um tamanho fixo e só depois aloca a string com o
tamanho adequado.

*Dica:* A chamada `scanf("%s", buffer)` devolve `1` se e só se a palavra foi lida
com sucesso, i.e. a leitura pode terminar se o valor devolvido não estiver `1`.

## ex03

Desenvolva em C um conjunto de funções que permita manipular uma pilha
(_stack_) com realocação automática. A pilha será representada com a seguinte
estrutura:

    typedef struct {
        int *v;     /* contents of the stack */
        int cap;    /* capacity of v, i.e. how many elements can fit in v */
        int sz;     /* number of elements currently stored in v */
    } stack;

As funções a desenvolver são as seguintes:

    stack *init();                  /* returns an empty stack with an initial capacity of 4
                                        (return 0 if no memory is available) */
    void push(stack * s, int e);    /* pushes integer e on top of the stack  (reallocate v if necessary) */
    int pop(stack * s);             /* removes top element from the stack and return it
                                        (not necessary to reallocate v) */
    int is_empty(stack * s);        /* returns 1 iff s represents the empty stack, returns 0 otherwise */
    void destroy(stack * s);        /* frees the memory associated with the stack */

O programa (*main*) lê do terminal uma lista de inteiros que empurra para a pilha (*push*).
Terminada a leitura, o programa imprime os elementos na pilha (*pop*) até a pilha estar vazia (*is_empty*).
Execute o programa com auxílio do *valgrind* (`valgrind ./ex03`) para verificar que não tem fugas de memória.

*Nota:* Poderá começar por considerar uma implementação sem a realocação automática.

## ex04 (facultativo)

Implemente em C um programa que leia uma linha do standard input e verifica se
os parênteses estão bem formatados, considerando os pares de parênteses `()`,
`[]`, `{}`.

Por exemplo, a string `"{[a]b(c)}()[]"` é uma string bem formatada, enquanto a
string `"(()"` não o é.  Se o input for bem formatado, o programa deverá
imprimir `"yes"`, e no caso contrário deverá imprimir `"no"`.

*Dica:* Podem aproveitar o `ex03` para resolver este exercício. Quando
encontrarem um parêntesis a abrir, coloque-o no stack; quando encontrar um
parêntesis a fechar verifica se o topo é um "match" e retira-o da pilha.  No
final a stack deverá ficar vazio.

*Dica:* Não é necessário guardar o input; é suficiente usar o stack.
