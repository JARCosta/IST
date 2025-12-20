#include "fs/operations.h"
#include <assert.h>
#include <string.h>
#include <pthread.h>

#define THREADS 6
#define SIZE 100
#define OUT "threads7.out"
#define PATH "/f1"

struct arg_struct {
  char charact;
  int value;
};
char string[THREADS*SIZE];
int FD;
int it;
int ocurrs[THREADS];

char input[SIZE];

void* threads(){
  for(int i = 0; i < SIZE; i++){
    assert(tfs_write(FD,input,1) != -1);
  }
  tfs_close(FD);
  return NULL;
}

int main() {

  assert(tfs_init() != -1);

  for(int i = 0; i < SIZE;i++){
    input[i]='A';
  }
  //printf("%s\n",input);

  FD = tfs_open(PATH, TFS_O_CREAT);
  assert(FD != -1);

  pthread_t tid[THREADS];

  for (int i = 0; i < THREADS; i++){
    it = i;
    int error = pthread_create(&tid[i], 0, &threads, NULL);
    assert(error == 0);
  }

  for (int i = 0; i < THREADS; i++){
    pthread_join (tid[i], NULL);
  }


  char buffer[(SIZE*THREADS)+1];
  int fd = tfs_open(PATH,0);
  assert(tfs_read(fd,buffer,SIZE*THREADS)==SIZE*THREADS);
  buffer[SIZE*THREADS]= '\0';
  int j = (int)strlen(buffer);
  //printf("%s %d %d\n",buffer,j,SIZE*THREADS);
  assert(j>=(SIZE*THREADS));


  printf("Great success\n");
}







/*
tfs_open(file,0)
create 4 threads
  tfs_write(var, thread_id, 3)

w/ threads: 111333222444
no threads: 222444
*/


