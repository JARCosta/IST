#include "operations.h"
#define MAX_SESSIONS 20
#define BUFFER_SIZE 1024
#define FREE 0
#define TAKEN 1

session session_list[MAX_SESSIONS];
int free_sessions[MAX_SESSIONS] = {FREE};
//int opened_files_owners[1024] = {-1};
int server_pipe;
pthread_mutex_t server_thread_lock;

void thread_mount(){
    printf("TFS_MOUNT:\n");
    int session_id;
    char client_name[40] = {'\0'};

    if(read(server_pipe, &client_name, 40 * sizeof(char)) == -1){
        printf("ERROR: reading client name\n");
    }                
    session_id = -1;

    for (int i = 0; i < MAX_SESSIONS; ++i){ // get first free session or wait for one, in the future, use signals
        if (free_sessions[i] == FREE){
            session_list[i].client_path_name = client_name;
            session_id = i;
            free_sessions[i] = TAKEN;
            printf("\t mounted session %d\n", session_id);
            break;
        }
    }

    int return_pipe = open(client_name, O_WRONLY);
    if(return_pipe  == -1){
        printf("ERROR: Couldnt open client pipe for writing.\n");
        return;
    }
    if (session_id != -1) session_list[session_id].client_pipe = return_pipe;
    if(-1 == write(return_pipe, &session_id, sizeof(int))) return;
}

void thread_unmount(int session_id){
    
    int error = 1;
    
    if (close(session_list[session_id].client_pipe) == -1){
        error = -1;
        printf("ERROR: couldnt close client pipe\n");
        if(write(session_list[session_id].client_pipe, &error, sizeof(int)) == -1) return;
        return;
    }

    free_sessions[session_id] = FREE;
    
    printf("\t unmounted session %d\n", session_id);
    free(session_list[session_id].buffer);
    session_list[session_id].buffer = NULL;
}

void thread_open(int session_id){

    open_struct input;
    memcpy(&input, session_list[session_id].buffer, sizeof(open_struct));

    int buffer = tfs_open(input.name,input.flag);
    //opened_files_owners[buffer] = input.session_id;
    if(write(session_list[input.session_id].client_pipe, &buffer, sizeof(buffer)) == -1) return;
    free(session_list[session_id].buffer);
    session_list[session_id].buffer = NULL;
}

void thread_close(int session_id){

    close_struct input;
    memcpy(&input, session_list[session_id].buffer, sizeof(close_struct));
    /*
    int owner_flag;
    if(input.session_id != opened_files_owners[input.session_id]){
        owner_flag = 1;
    }
    */
    
    int buffer = tfs_close(input.fhandle);
    if(write(session_list[session_id].client_pipe, &buffer, sizeof(buffer)) == -1) return;
    printf("\t closed %d\n",buffer);
    free(session_list[session_id].buffer);
    session_list[session_id].buffer = NULL;
}

void thread_write(int session_id){

    write_struct input;
    memcpy(&input, session_list[session_id].buffer, sizeof(write_struct));
    char buffer[input.len];
    memcpy(&buffer, session_list[session_id].buffer + sizeof(write_struct), input.len);

    printf("\t written on server: %s\n", buffer);
    
    ssize_t written = tfs_write(input.fhandle, &buffer, input.len);
    if(write(session_list[input.session_id].client_pipe, &written, sizeof(ssize_t)) == -1) return;
    
    printf("\t wrote %d B\n", (int)written);
    free(session_list[session_id].buffer);
    session_list[session_id].buffer = NULL;
}

void thread_read(int session_id){

    read_struct input;
    memcpy(&input, session_list[session_id].buffer, sizeof(read_struct));
    
    char buffer[input.len];
    ssize_t red = tfs_read(input.fhandle, &buffer, input.len);
    buffer[red] = '\0';
    if(write(session_list[input.session_id].client_pipe, &buffer, input.len) == -1) return;
    printf("\t read %s( %d B)\n",buffer, (int)red);
    free(session_list[session_id].buffer);
    session_list[session_id].buffer = NULL;
}

void thread_destroy_after_all_closed(int session_id){
    int error = tfs_destroy_after_all_closed();
    if(write(session_list[session_id].client_pipe, &error, sizeof(int)) == -1) return;
}

void* thread_func(void *session_void){
    int session_id = *(int*)session_void;
    while(1) {
        printf(" %d\t sleeping\n", session_id);
        if (pthread_mutex_lock(&session_list[session_id].lock) != 0) return;
        if (pthread_mutex_unlock(&server_thread_lock) != 0) return;
        if (pthread_cond_wait(&session_list[session_id].var, &session_list[session_id].lock) != 0) return;
        if (pthread_mutex_unlock(&session_list[session_id].lock) != 0) return;
        printf(" %d\t awake\n", session_id);

        char op_char = session_list[session_id].op_code;

        if(op_char == '2'){
            thread_unmount(session_id);
        }
        else if(op_char == '3'){
            thread_open(session_id);
        }
        else if(op_char == '4'){
            thread_close(session_id);
        }
        else if(op_char == '5'){
            thread_write(session_id);
        }
        else if(op_char == '6'){
            thread_read(session_id);
        }
        else if(op_char == '7'){
            thread_destroy_after_all_closed(session_id);
        }
    }
}


int main(int argc, char **argv) {

    if (argc < 2) {
        printf("Please specify the pathname of the server's pipe.\n");
        return 1;
    }

    char *pipename = argv[1];
    printf("Starting TecnicoFS server with pipe called %s\n", pipename);

    /* TO DO */
    if (mkfifo(pipename, 0777) == -1){
        if (errno != EEXIST){
            printf("ERROR: Couldnt create FIFO\n");
            return -1;
        }
    }
    if(tfs_init() == -1) return -1;
    if (pthread_mutex_init(&server_thread_lock, NULL) != 0) return -1;
    for (int i = 0; i < MAX_SESSIONS; i++){
        if (pthread_mutex_lock(&server_thread_lock) != 0) return -1;
        if (pthread_cond_init(&session_list[i].var, NULL) != 0) return -1;
        if (pthread_mutex_init(&session_list[i].lock, NULL) != 0) return -1;
        if (pthread_create(&session_list[i].thread, NULL, &thread_func, (void*)&i) != 0) return -1;
        printf(" %d\t created\n", i);
    }

    server_pipe = open(pipename, O_RDONLY);

    printf("\t thread open\n");
    ssize_t a;
    while(1){
        char op_code;
        a = read(server_pipe, &op_code, sizeof(char));
        if (a > 0){
            if(op_code == '1'){
                
                thread_mount();     //Optamos por nao utilizar threads no mount visto que achamos que nao seria necessario

            } else if(op_code == '2'){
                printf("TFS_UNMOUNT:\n");
                                
                unmount_struct input;
                if(read(server_pipe, &input, sizeof(unmount_struct)) == -1){
                    printf("ERROR: reading client name\n");
                }
                
                session_list[input.session_id].op_code = '2';

                if (pthread_cond_signal(&session_list[input.session_id].var) != 0) return -1;
            
            } else if(op_code == '3'){
                printf("TFS_OPEN:\n");

                open_struct input;
                if(-1 == read(server_pipe, &input, sizeof(open_struct))) return -1;
                //printf("\t read from server pipe\n");
                session_list[input.session_id].buffer = malloc(sizeof(open_struct));
                memcpy(session_list[input.session_id].buffer, &input, sizeof(open_struct));
                session_list[input.session_id].op_code = '3';

                if (pthread_cond_signal(&session_list[input.session_id].var) != 0) return -1;
                printf("\t session id: %d\n", input.session_id);
            
            } else if(op_code == '4'){
                printf("TFS_CLOSE:\n");

                close_struct input;
                if(-1 == read(server_pipe, &input, sizeof(close_struct))) return -1;
                
                session_list[input.session_id].buffer = malloc(sizeof(close_struct));
                memcpy(session_list[input.session_id].buffer, &input, sizeof(close_struct));
                session_list[input.session_id].op_code = '4';

                if (pthread_cond_signal(&session_list[input.session_id].var) != 0) return -1;
            
            } else if(op_code == '5'){
                printf("TFS_WRITE:\n");


                write_struct input;
                if(-1 == read(server_pipe, &input, sizeof(write_struct))) return -1;
                char buffer[input.len /* + 1*/ ];
                //printf("\t created buffer \"%d\"\n", &buffer);
               if(-1 == read(server_pipe, &buffer, input.len)) return -1;
                //buffer[input.len] = '\0';
                printf("\t read from server pipe: %s", buffer);
                session_list[input.session_id].buffer = malloc(sizeof(write_struct) + input.len);
                memcpy(session_list[input.session_id].buffer, &input, sizeof(write_struct));
                memcpy(session_list[input.session_id].buffer + sizeof(write_struct), &buffer, input.len);
                session_list[input.session_id].op_code = '5';

                if (pthread_cond_signal(&session_list[input.session_id].var) != 0) return -1;
                printf("\t session id: %d\n", input.session_id);
            
            } else if(op_code == '6'){

                printf("TFS_READ:\n");
                read_struct input;
                if(-1 == read(server_pipe, &input, sizeof(read_struct))) return -1;
                
                session_list[input.session_id].buffer = malloc(sizeof(read_struct));
                memcpy(session_list[input.session_id].buffer, &input, sizeof(read_struct));
                session_list[input.session_id].op_code = '6';

                if (pthread_cond_signal(&session_list[input.session_id].var) != 0) return -1;
            
            }else if(op_code == '7'){

                printf("TFS_DESTROY_AFTER_ALL_CLOSED:\n");
                int session_id;
                if(-1 == read(server_pipe, &session_id, sizeof(int))) return -1;

                session_list[session_id].op_code = '7';

                if (pthread_cond_signal(&session_list[session_id].var) != 0) return -1;
            }
        }
    }
    return 0;
}