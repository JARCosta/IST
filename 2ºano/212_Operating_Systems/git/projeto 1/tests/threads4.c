#include "fs/operations.h"
#include <assert.h>
#include <string.h>
#include <pthread.h>

#define THREADS 26
#define SIZE 1
#define OUT "threads4.out"


struct arg_struct {
    char charact;
    int value;
};
char string[THREADS];
int fd;
char buffer[SIZE];

void* threads(){
  assert(tfs_read(fd,buffer,SIZE)== SIZE);
  printf("%s\n", buffer);
  return NULL;
}

int main() {
  for(int i = 0; i!=THREADS;i++){
    string[i] = (char)('A' + i%24);
  }
  char *path = "/f1";

  char output [SIZE];

  assert(tfs_init() != -1);
  fd = tfs_open(path, TFS_O_CREAT);
  assert(fd != -1);

  pthread_t tid[THREADS];

  char input[SIZE];
  for(int i = 0; i < THREADS; i++ ){
    memset(input, 'A' + i , SIZE);
    tfs_write(fd, input, SIZE);
  }

  tfs_close(fd);
  fd = tfs_open(path,0);

  for (int i = 0; i < THREADS; i++){
    int error = pthread_create(&tid[i], 0, &threads, NULL);
    assert(error == 0);
  }

  for (int i = 0; i < THREADS; i++){
    pthread_join (tid[i], NULL);
  }

  assert(tfs_close(fd) != -1);

  fd = tfs_open(path, 0);
  assert(fd != -1 );

  tfs_copy_to_external_fs(path, OUT);
  
  for(int i = 0; i < THREADS; i++){
    assert(tfs_read(fd, output, SIZE)==SIZE);
  }
  printf("Great success\n");
}

/*
tfs_open(file,0)
create 4 threads
    tfs_write(var, thread_id, 3)

w/ threads: 111333222444
no threads: 222444
*/