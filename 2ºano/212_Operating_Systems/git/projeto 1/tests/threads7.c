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
int fd[THREADS];
int FD;
int it;
int ocurrs[THREADS];

// regista o numero de vezes que cada letra é lida
// com locks, cada elemento deverá armazenar SIZE

//ex:  SIZE = 2 THREADS = 2
//ficheiro armazena: "AABB"
// ou seja, ocurrs[0], que guarda as ocurrencias de A, deverá armazenar 2

//sem locks, haverá letras duplamente lidas

void* threads(){
  char string2[SIZE*THREADS];
  char buffer[2];
  //char trash[SIZE*THREADS];
  //int value = it;
  //printf("%d\n",value);
  //int thread_file_handle = tfs_open(PATH,0);
  
  //tfs_read(FD, trash, (size_t)(SIZE));
  
  for(int i = 0; i < SIZE;i++){
    assert(tfs_read(FD, buffer, 1) == 1);
    strcat(string2,buffer);
    //printf("%c\n",buffer[0]);
    int character = (int)buffer[0] - (int)'A';
    ocurrs[character]++;
    //printf("%s %d\n", buffer, (int)strlen(buffer));
  }
  //printf("%s\n",string2);

  //assert(strlen(buffer)==SIZE);
  //tfs_close(thread_file_handle);
  return NULL;
}

int main() {

  assert(tfs_init() != -1);

  FD = tfs_open(PATH, TFS_O_CREAT);
  assert(FD != -1);

  pthread_t tid[THREADS];

  for(int i = 0; i!=THREADS;i++){
    for(int j = 0; j<SIZE;j++){
      string[i*SIZE+j] = (char)('A' + i%24);
    }
  }
  //printf("input: %s\n",string);

  tfs_write(fd[1], string, (size_t)(SIZE * THREADS));
  //printf("%s\n",string);
  assert(tfs_close(FD) != -1);
  FD = tfs_open(PATH,0);
  assert(FD != -1);

  for (int i = 0; i < THREADS; i++){
    it = i;
    int error = pthread_create(&tid[i], 0, &threads, NULL);
    assert(error == 0);
  }

  for (int i = 0; i < THREADS; i++){
    pthread_join (tid[i], NULL);
  }

  for(int i = 0; i< THREADS; i++){
    //printf("%c %d\n",(char)('A'+i), ocurrs[i]);
    assert(ocurrs[i] == SIZE);
  }

  //for(int i = 0; i< THREADS; i++) assert(tfs_close(fd[i]) != -1);

  tfs_copy_to_external_fs(PATH, OUT);
  /*
  char output [SIZE];
  for(int i = 0; i < THREADS; i++){
    assert(tfs_read(fd[i], output, SIZE)==SIZE);
  }
  */
  printf("Great success\n");
}







/*
tfs_open(file,0)
create 4 threads
  tfs_write(var, thread_id, 3)

w/ threads: 111333222444
no threads: 222444
*/



