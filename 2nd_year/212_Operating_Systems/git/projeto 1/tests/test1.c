#include "fs/operations.h"
#include <assert.h>
#include <string.h>

#define SIZE 600

int main() {

    char *str = "11111111222222223333333344444444555555556666666677777777888888888888888877777777666666665555555544444444333333332222222211111111111111112222222233333333444444445555555566666666777777778888888888888888777777776666666655555555";
    char *path = "/f1";
    char buffer[SIZE+1];

    assert(tfs_init() != -1);

    int f;
    ssize_t r;

    f = tfs_open(path, TFS_O_CREAT);
    assert(f != -1);

    r = tfs_write(f, str, strlen(str));
    assert(r == strlen(str));

    assert(tfs_close(f) != -1);

    f = tfs_open(path, 0);
    assert(f != -1);

    int i = 0;
    while(i < strlen(str)/SIZE){
        r = tfs_read(f, buffer, sizeof(buffer) - 1);
        buffer[SIZE] = '\0';
        //printf("len(buffer): %ld len(str): %ld\n", strlen(buffer), strlen(str));
        printf("%s\n\n",(char*)buffer);
        i++;
    }
    assert(r == strlen(str));
    
    assert(strcmp(buffer, str) == 0);

    assert(tfs_close(f) != -1);

    printf("Successful test.\n");

    return 0;
}
