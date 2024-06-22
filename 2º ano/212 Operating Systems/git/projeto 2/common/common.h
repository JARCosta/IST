#ifndef COMMON_H
#define COMMON_H
#define CLIENT_NAME_SIZE 40

#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>


/* tfs_open flags */
enum {
    TFS_O_CREAT = 0b001,
    TFS_O_TRUNC = 0b010,
    TFS_O_APPEND = 0b100,
};

/* operation codes (for client-server requests) */
enum {
    TFS_OP_CODE_MOUNT = 1,
    TFS_OP_CODE_UNMOUNT = 2,
    TFS_OP_CODE_OPEN = 3,
    TFS_OP_CODE_CLOSE = 4,
    TFS_OP_CODE_WRITE = 5,
    TFS_OP_CODE_READ = 6,
    TFS_OP_CODE_SHUTDOWN_AFTER_ALL_CLOSED = 7
};

//  Criamos as struct com __attribute__((__packed__)) para excluirmos problemas de padding na escrita e leitura das mesmas.

typedef struct __attribute__((__packed__)){
    char client_pipe_name[CLIENT_NAME_SIZE];
} mount_struct;

typedef struct __attribute__((__packed__)){
    int session_id;
} unmount_struct;

typedef struct __attribute__((__packed__)){
    int session_id;
    char name[CLIENT_NAME_SIZE];
    int flag;
} open_struct;

typedef struct __attribute__((__packed__)){
    int session_id;
    int fhandle;
} close_struct;

typedef struct __attribute__((__packed__)){
    int session_id;
    int fhandle;
    size_t len;
} write_struct;

typedef struct __attribute__((__packed__)){
    int session_id;
    int fhandle;
    size_t len;
} read_struct;



#endif /* COMMON_H */