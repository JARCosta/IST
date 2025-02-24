#include <stdlib.h>
#include <stdio.h>

typedef struct stru_node {
    struct stru_node *next;
    int v;
} node;

/* Print all values in the list. */
void print_list(node * head) {
    for (; head; head = head->next)
        printf("%d ", head->v);
    printf("\n");
}

/* Remove the first element of the list and return the new head */
node * pop(node * head) {
    node * aux = head->next;
    free(head);
    return aux;
}

/* Free all memory associated with the list and return NULL */
node * destroy(node * head) {
    while (head)
        head=pop(head);
    return NULL;
}

/* Add e as the first element of the list and return the new head */
node * push(node * head, int e) {
    node *aux = head;
    head = malloc(sizeof(node));
    head -> v =e;
    head -> next = aux;
    return head;

}

int count(node* head , int val){
    node *curr;
    int count =0;
    for(curr=head; curr != NULL; curr = curr -> next){
        if(curr -> v == val)
            ++count;
    }
}

/* Read a sequence of values and print them in reverse order. */
int main() {
    int val;
    node * head = NULL;

    /* Read values and store them in the list. */
    while(1) {
        scanf("%d", &val);
        if (val == 0) break;
        head = push(head, val);
    }
    count_4s = count(node* head,4);
    printf("4s %d",count_4s);
    /* Print all values in the list. */
  /*  print_list(head);*/

    head = destroy(head);
    return 0;
}