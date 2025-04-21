#include<stdlib.h>
#include<stdio.h>

typedef struct stru_node {
    struct stru_node *next;
    int v;
} node;

/* remove the first element of the list and return the new head */
node * pop(node * head) {
    node * aux = head->next;
    free(head);
    return aux;
}

/* frees all memory associated with the list  and returns NULL */
node * destroy(node * head) {
    while (head)
        head=pop(head);
    return NULL;
}

/* add e as the first element of the list and return the new head */
node * push(node * head, int e) {
    node * aux = head;
    head = malloc(sizeof(node));
    head->v = e;
    head->next = aux;
    return head;
}

void print_list(node * head) {
    for (; head; head = head->next)
        printf("%d ", head->v);
    printf("\n");
}

/* Return the number of occurrences of 'val'. */
int count(node* head, int val) {
    node *curr;
    int count = 0;
    for (curr = head; curr != NULL; curr = curr->next) {
        if (curr->v == val)
            ++count;
    }
    return count;
}

/* Delete all occurrences of 'val'. */
node * delete(node* head, int val) {
    node *curr, *prev;
    for (curr = head; curr != NULL; prev = curr, curr = curr->next) {
        if (curr->v == val) {
            if (curr == head)
                head = curr->next;
            else
                prev->next = curr->next;
            free(curr);
        }
    }
    return head;
}

int main() {
    int v;
    node * head = NULL;
    int count_4s;
    while(1) {
        scanf("%d", &v);
        if (v==0) break;
        head = push(head, v);
    }
    /* Count all 4s */
    count_4s = count(head, 4);

    printf("The list has %d 4s.\n\n", count_4s);

    /* Delete all 4s */
    head = delete(head, 4);

    /* Imprime todos os valores da lista */
    print_list(head);
    head = destroy(head);
    return 0;
}