/*
 * thread.c - simple example demonstrating the creation of threads
 */

/*
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdlib.h>


int main(){

   float a=0, b=0, c=0;
   
   pid_t pid, cpid;
   int status;
   
   
   pid = fork();
   if(pid == 0) {
      a=1+1;
      printf("a: (in Child)= %.2f\n",a);
      exit(0);
   }else {
      if ((cpid=wait(&status)) == pid){
         printf("Child %d returned\n",pid);
      }
      //sleep(5);
      b=2+2;
      printf("a: (in Parent)=%.2f\n", a);
      printf("b=%.2f\n", b);
      c=a+b;
      printf("c=%.2f\n", c);
   }
   return 0; 
}
*/
/*
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>

int main (int argc, char** argv){
   int hey = 0;
   printf("(PID: %d) Ola, aqui estou eu! hey = %d\n", getpid(), hey);

   if(fork()==0){
      hey++;
      printf("(PID: %d) Depois do fork! hey = %d\n", getpid(), hey);
      exit(EXIT_SUCCESS);
   }

   if(fork()==0){
      hey+=2;
      printf("(PID: %d) Depois do fork! hey = %d\n", getpid(), hey);
      exit(EXIT_SUCCESS);
   }

   wait(NULL);
   //sleep(1);
   printf("(PID: %d) Depois do fork! hey = %d\n", getpid(), hey);
   exit(EXIT_SUCCESS);
}
*/

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#define N 5
#define TAMANHO 10

int buffer [N] [TAMANHO];

void *soma_linha (void *linha) {
   int c, soma=0;
   int *b = (int*) linha;
   for (c=0;c<TAMANHO-1;c++) {
      soma += b[c];
   }
   b[c]=soma; /* soma->ult.col.*/
   return NULL;
}


int main (void) {
   int i;
   pthread_t tid[N];

   //inicializaMatriz(buffer, N, TAMANHO);
   for (i=0; i< N; i++){
      if(pthread_create (&tid[i], 0, soma_linha,buffer[i])== 0) {
         printf ("Criada a tarefa %d\n", (int)tid[i]);
      }
      else {
         printf("Erro na criação da tarefa\n");
         exit(1);
      }
   }

   for (i=0; i<N; i++){
      pthread_join (tid[i], NULL);
   }
   printf ("Terminaram todas as threads\n");
   //imprimeResultados(buffer);
   exit(0);
}