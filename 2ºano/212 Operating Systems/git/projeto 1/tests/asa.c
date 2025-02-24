#include "fs/operations.h"
#include <assert.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <time.h>

int main() {
    srand((unsigned int)(time(NULL)));
    //char *str = "1\n";
    char str[1000] = "1\n";

    char *path = "/f1";
    char *path2 = "tests/asa.txt";
    //char to_read[40];
    //char str[100] = "This is ";
    //char str2[] = "1 ";

    for(int i = 2; i<40;i+=2){
        str[i] = (char)(rand()%10 + 48);
        str[i+1] = ' ';
        //*str++ = 'a';
        //strcat(str,str2);
    }
    str[strlen(str)] = '\n';









    assert(tfs_init() != -1);

    int file = tfs_open(path, TFS_O_CREAT);
    assert(file != -1);

    assert(tfs_write(file, str, strlen(str)) != -1);

    assert(tfs_close(file) != -1);

    assert(tfs_copy_to_external_fs(path, path2) != -1);
/*
    FILE *fp = fopen(path2, "r");

    assert(fp != NULL);

    assert(fread(to_read, sizeof(char), strlen(str), fp) == strlen(str));
    
    assert(strcmp(str, to_read) == 0);

    assert(fclose(fp) != -1);

    unlink(path2);
*/
    printf("Successful test.\n");

    return 0;
}
