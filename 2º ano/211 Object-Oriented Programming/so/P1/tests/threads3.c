#include "fs/operations.h"
#include <assert.h>
#include <string.h>
#include <pthread.h>

#define THREADS 8
#define SIZE 128
#define PATH "/f1"
#define OUT "threads3.out"

struct arg_struct {
  int value;
};

int fd;



void* thread(void *arguments){
  char input[SIZE];
  struct arg_struct *args = (struct arg_struct *)arguments;
  

  memset(input, '0' + args->value % 10, SIZE);

  printf("%s\n",input);

  tfs_write(fd, input, SIZE);
  return 0;
}

/*
tfs_open(file,0)
create 4 threads
    tfs_write(var, thread_id, 3)

w/ threads: 111333222444
no threads: 222444
*/

int main() {
  char output [SIZE];
  pthread_t tid[THREADS];

  assert(tfs_init() != -1);

  fd = tfs_open(PATH, TFS_O_CREAT);
  assert(fd != -1);
  
  for (int i = 0; i < THREADS; i++){
    struct arg_struct args;
    args.value = i;
    pthread_create(&tid[i],0,&thread, (void *)&args);
  }

  for (int i = 0; i < THREADS; i++) pthread_join (tid[i], NULL);

  tfs_close(fd);


  fd = tfs_open(PATH, 0);
  assert(fd != -1 );
  
  tfs_copy_to_external_fs(PATH, OUT);

  for(int i = 0; i < THREADS; i++){
    int read = (int)tfs_read(fd, output, SIZE);
    //printf("%d\n", written);
    assert(read == SIZE);
  }
  printf("Great success\n");
}