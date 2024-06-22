#include "fs/operations.h"
#include <assert.h>
#include <string.h>
#include <pthread.h>

#define THREADS 4
#define SIZE 10
#define OUT "threads5.out"

int fd1;
int fd2;
int n = 1;

void* write(){
  char input[SIZE];
  //printf("%c\n\n",'A'+ args->value % 2);
  
  memset(input, 'A' + (n - 1), SIZE);
  printf("to write %d: %s\n", n, input);
  n += 1;
  tfs_write(fd1, input, SIZE);
  return NULL;
}

void *read(){//esquece ele so compila o q consegue, se der erro aq compila o 7 a mm
//noice eu tou so a tentar perceber o read
    char input[SIZE];
    int read = (int)tfs_read(fd2, input, SIZE);
    assert(sizeof(input) == SIZE);
    printf("read %d, %d: %s\n", n, read, input);
    return NULL;
}

int main() {
  char *path = "/f1";
 // char input [SIZE * 2];
  char output [SIZE];
 // memset(input, 'T', SIZE * 2);
  //printf("initial input: %s\n", input);
  assert(tfs_init() != -1);
  printf("***\n");
  fd1 = tfs_open(path, TFS_O_CREAT);
  assert(fd1 != -1);
  printf("***\n");
  fd2 = tfs_open(path, 0);
  assert(fd2 != -1);
  printf("***\n");
  //int fd3 = tfs_open(path, 0);
  assert(fd2 != -1);
  printf("***\n");

 // tfs_write(fd3, input, SIZE * 2);
  printf("***\n");
  
  pthread_t tid[THREADS];

  for (int i = 0; i < THREADS; i++){
    int error;
    if (i % 2 == 0){
        error = pthread_create(&tid[i],0,write, NULL);
        printf("***\n");
    }
    else {
        error = pthread_create(&tid[i],0,read, NULL);
        printf("***\n");
    }
    assert(error == 0);
  }

  for (int i = 0; i < THREADS; i++){
    pthread_join (tid[i], NULL);
  }

  printf("fd1: %d, fd2: %d\n", fd1, fd2);
  printf("***\n");

  assert(tfs_close(fd1) != -1);
  printf("***\n");
  assert(tfs_close(fd2) != -1);
  printf("***\n");

  int fd = tfs_open(path, 0);
  printf("***\n");
  assert(fd != -1 );
  tfs_copy_to_external_fs(path, OUT);
  
  for(int i = 0; i < THREADS; i++){
    if (i % 2 == 0)
    assert(tfs_read(fd, output, SIZE)==SIZE);
    printf("output: %s\n", output);
    printf("***\n");
  }
  printf("Great success\n");
}

// create n threads
    // tfs_open(x, create);
    // write;
    // delete