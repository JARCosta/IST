#include <stdio.h>
#include "fs/operations.h"
#include <assert.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>

#define COUNT 5
#define THREADS 2
#define SIZE 1024

char *path = "/f1";
int fd;

void* write_function(){
    fd = tfs_open(path, TFS_O_CREAT);
    assert(fd != -1);
    char input[SIZE];
    memset(input, 'A', SIZE);
    tfs_write(fd, input, SIZE);
    assert(tfs_close(fd) != -1);
    return NULL;
}

int main() {
    pthread_t tid[THREADS];
    char input_check_A[SIZE*THREADS];
    char output[THREADS*SIZE];

    assert(tfs_init() != -1);
    memset(input_check_A, 'A', SIZE);

    for (int i=0; i<THREADS; i++) assert(pthread_create(&tid[i], NULL, write_function, NULL)!=-1);
    
    for (int i = 0; i < THREADS; i++) pthread_join(tid[i], NULL);

    tfs_copy_to_external_fs(path, "out2");
    
    fd = tfs_open(path, 0);
    assert(fd != -1 );

    printf("%d\n",(int)tfs_read(fd, output, THREADS*SIZE));
    //assert( == THREADS*SIZE);
    assert(memcmp(input_check_A, output,THREADS*SIZE) == 0);
    assert(tfs_close(fd) != -1);
    printf("Successful test\n");
    return 0;
} 