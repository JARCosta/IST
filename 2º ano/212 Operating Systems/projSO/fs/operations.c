#include "operations.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

int tfs_init() {
    state_init();

    /* create root inode */
    int root = inode_create(T_DIRECTORY);
    if (root != ROOT_DIR_INUM) {
        return -1;
    }

    return 0;
}

int tfs_destroy() {
    state_destroy();
    return 0;
}

static bool valid_pathname(char const *name) {
    return name != NULL && strlen(name) > 1 && name[0] == '/';
}


int tfs_lookup(char const *name) {
    if (!valid_pathname(name)) {
        return -1;
    }

    // skip the initial '/' character
    name++;

    return find_in_dir(ROOT_DIR_INUM, name);
}

int tfs_open(char const *name, int flags) {
    int inum;
    size_t offset;

    /* Checks if the path name is valid */
    if (!valid_pathname(name)) {
        return -1;
    }
    inode_t *root = inode_get(0);
    if (pthread_rwlock_wrlock(&root->lock) != 0) {
        //printf("error locking\n");
        return -1;
    }// if a file is beeing created, wait for it
    
    inum = tfs_lookup(name);

    if (inum >= 0) {
        if (pthread_rwlock_unlock(&root->lock) != 0){
            //printf("error unlocking\n");
            return -1;
        }
        /* The file already exists */
        inode_t *inode = inode_get(inum);
        pthread_rwlock_wrlock(&inode -> lock);
        if (inode == NULL) {
            return -1;
        }

        /* Trucate (if requested) */
        if (flags & TFS_O_TRUNC) {
            if (inode->i_size > 0) {
                for(int i = 0; i<10;i++)
                    if (data_block_free(inode->i_data_block[i]) == -1) {
                        pthread_rwlock_unlock(&inode->lock);
                        return -1;
                    }

                inode->i_size = 0;
            }
        }
        /* Determine initial offset */
        if (flags & TFS_O_APPEND) {
            offset = inode->i_size;
        } else {
            offset = 0;
        }
        pthread_rwlock_unlock(&inode->lock);
    } else if (flags & TFS_O_CREAT) {
        /* The file doesn't exist; the flags specify that it should be created*/
        /* Create inode */

        inum = inode_create(T_FILE);
        if (inum == -1) {
            if (pthread_rwlock_unlock(&root->lock) != 0){
            //printf("error unlocking\n");
            return -1;
        }
            return -1;
        }
        /* Add entry in the root directory */
        if (add_dir_entry(ROOT_DIR_INUM, inum, name + 1) == -1) {
            inode_delete(inum);
            if (pthread_rwlock_unlock(&root->lock) != 0){
            //printf("error unlocking\n");
            return -1;
        }
            return -1;
        }
        if (pthread_rwlock_unlock(&root->lock) != 0){
            //printf("error unlocking\n");
            return -1;
        }
        offset = 0;
    } else {
        if (pthread_rwlock_unlock(&root->lock) != 0){
            //printf("error unlocking\n");
            return -1;
        }
        return -1;
    }

    /* Finally, add entry to the open file table and
     * return the corresponding handle */
    return add_to_open_file_table(inum, offset);

    /* Note: for simplification, if file was created with TFS_O_CREAT and there
     * is an error adding an entry to the open file table, the file is not
     * opened but it remains created */
}


int tfs_close(int fhandle) { return remove_from_open_file_table(fhandle); }

void *createBlock(inode_t *inode, int blockIndex){
    //printf("new block: %d\n",blockIndex);
    int savingBlock = data_block_alloc();

    if(blockIndex >= 10){
        void *indexBlock = data_block_get(inode->i_data_block[10]);

        if(indexBlock == NULL || inode->i_data_block[10] == 0){         // i_data_block[10] starts with vaue 0 somehow
            inode->i_data_block[10] = data_block_alloc();
            indexBlock = data_block_get(inode->i_data_block[10]);
        }

        memcpy(indexBlock + (size_t)((blockIndex-10)*(int)sizeof(int)), &savingBlock, sizeof(int));
        
        //printf("saving block:%d\n",savingBlock);
        return data_block_get(savingBlock);
    } else{
        //printf("saving block:%d\n",savingBlock);
        inode->i_data_block[blockIndex] = savingBlock;
        return data_block_get(savingBlock);
    }
}

void *getBlock(inode_t *inode,int blockIndex){
    if(blockIndex >= 10){
        if(inode->i_data_block[10] == 0){   // if there is no block for block #REF
            //printf("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n");
            return NULL;
        } else{
            void *indexBlock = data_block_get(inode->i_data_block[10]);
            //printf("%d %d\n",inode->i_data_block[10],indexBlock==NULL);

            int memIndex = 0;
            memcpy(&memIndex, indexBlock + (size_t)((blockIndex-10)*(int)sizeof(int)), sizeof(int));

            //printf("getting block:%d (null:%d)\n",memIndex,data_block_get(memIndex) == NULL);
            if(memIndex==0) return NULL;
            //printf("block%d: %d %d\n",blockIndex, data_block_get(memIndex)==NULL,memIndex);
            return data_block_get(memIndex);
        }
    } else{
        return data_block_get(inode->i_data_block[blockIndex]);
    }
}

ssize_t tfs_write(int fhandle, void const *buffer, size_t to_write) {
    pthread_mutex_lock(&open_file_entries_lock);
    open_file_entry_t *file = get_open_file_entry(fhandle);
    pthread_mutex_lock(&file->lock);
    pthread_mutex_unlock(&open_file_entries_lock);
    
    if (file == NULL) {
        pthread_mutex_unlock(&file->lock);
        return -1;
    }

    /* From the open file table entry, we get the inode */
    inode_t *inode = inode_get(file->of_inumber);
    pthread_rwlock_wrlock(&inode->lock);
    if (inode == NULL) {
        pthread_rwlock_unlock(&inode->lock);
        pthread_mutex_unlock(&file->lock);
        return -1;
    }


    size_t wrote = 0;
    int blockIndex = (int)(file->of_offset / BLOCK_SIZE);
    while (to_write > 0) {
        //printf("block: %d\n",blockIndex);
        //void *block = NULL;
        //if(blockIndex<10)
        void *block = getBlock(inode,blockIndex);
        //printf("NULLblock:%d\n",block == NULL);
        if (block == NULL /*&& blockIndex < 10*/) {
            //printf("new block: %d\n", blockIndex);
            block = createBlock(inode,blockIndex);
        }
        /*if( blockIndex >= 10){
            wrote += to_write;
            to_write -= to_write;
        }
        else */
        if(blockIndex < (file->of_offset + to_write) / BLOCK_SIZE){
            size_t nextBlock = BLOCK_SIZE - (file->of_offset % BLOCK_SIZE);
            memcpy(block + (file->of_offset % BLOCK_SIZE), buffer, nextBlock);
            //printf("offset: %d\n",(int)(file->of_offset % BLOCK_SIZE));
            //printf("block: %d writing: %d(%d -> %d)\n",blockIndex, (int)nextBlock,(int)file->of_offset, (int)(file->of_offset+nextBlock));
            inode -> i_size += nextBlock;
            wrote += nextBlock;
            buffer += nextBlock;
            file->of_offset += nextBlock;
            to_write -= nextBlock;
            blockIndex++;
        } else{
            memcpy(block + (file->of_offset % BLOCK_SIZE), buffer, to_write);
            //printf("offset: %d\n",(int)(file->of_offset % BLOCK_SIZE));
            //printf("block: %d writing: %d(%d -> %d)\n",blockIndex, (int)to_write, (int)file->of_offset, (int)(file->of_offset+to_write));

            inode -> i_size += to_write;
            buffer += to_write;
            file->of_offset += to_write;
            wrote += to_write;
            to_write -= to_write;
        }
    }
    
    pthread_rwlock_unlock(&inode->lock);
    pthread_mutex_unlock(&file->lock);
    return (ssize_t)wrote;
}

ssize_t tfs_read(int fhandle, void *buffer, size_t len) {

    pthread_mutex_lock(&open_file_entries_lock);
    open_file_entry_t *file = get_open_file_entry(fhandle);
    pthread_mutex_lock(&file->lock);
    pthread_mutex_unlock(&open_file_entries_lock);
    if (file == NULL) {
        return -1;
    }


    //From the open file table entry, we get the inode
    inode_t *inode = inode_get(file->of_inumber);
    pthread_rwlock_rdlock(&inode->lock);
    if (inode == NULL) {
        return -1;
    }


    //Determine how many bytes to read
    size_t to_read = inode->i_size - file->of_offset;
    if (to_read > len) {
        to_read = len;
    }

    
    //printf("of_offsett: %d\n", (int)file->of_offset);
    size_t read = 0;
    int blockIndex = (int)(file->of_offset/BLOCK_SIZE);
    //printf("to_read: %d starting in block: %d\n", (int)to_read, blockIndex);
    while (to_read > 0) {
        //printf("block: %d(pos%ld)\n",blockIndex,file->of_offset);

        //void *block = data_block_get(inode->i_data_block[blockIndex]);
        void *block = getBlock(inode, blockIndex);
        if(block == NULL) {
            pthread_rwlock_unlock(&inode->lock);
            pthread_mutex_unlock(&file->lock);
            return -1;
        }

        if(file->of_offset/BLOCK_SIZE < (file->of_offset + to_read) / BLOCK_SIZE){
            size_t nextBlock = BLOCK_SIZE - (file->of_offset % BLOCK_SIZE);
            memcpy(buffer, block + (file->of_offset%BLOCK_SIZE), nextBlock);
            //printf("block: %d reading: %d from: %d to: %d\n",blockIndex, (int)nextBlock,(int)file->of_offset,(int)(file->of_offset+nextBlock));
            read += nextBlock;
            buffer += nextBlock;
            file->of_offset += nextBlock;
            to_read -= nextBlock;
            blockIndex++;
        } else{
            memcpy(buffer, block + (file->of_offset%BLOCK_SIZE), to_read);
            //printf("block: %d reading: %d from: %d to: %d\n",blockIndex, (int)to_read,(int)file->of_offset,(int)(file->of_offset+to_read));
            read += to_read;
            buffer += to_read;
            file->of_offset += to_read;
            to_read -= to_read;
        }
    }
    
    pthread_rwlock_unlock(&inode->lock);
    pthread_mutex_unlock(&file->lock);
    return (ssize_t)read;
}

int tfs_copy_to_external_fs(char const *source_path, char const *dest_path){
    
    int srcFile = tfs_open(source_path, 0);
//    open_file_entry_t *fhandle = get_open_file_entry(srcFile);
//    pthread_mutex_lock(&fhandle->lock);

    int dstFile = tfs_open(dest_path,TFS_O_TRUNC);

    if (dstFile != 0){
        dstFile = tfs_open(dest_path, TFS_O_CREAT);
    }
    
    char buffer[1024];
    memset(buffer,0,sizeof(buffer));
    
    FILE* fd = fopen(dest_path,"w");
    if(fd == NULL) return -1;
    
    long int bytes_read, bytes_written;
    
    do{
        bytes_read = tfs_read(srcFile, buffer, sizeof(buffer) - 1);
        bytes_written = (long int)fwrite(buffer,1,(size_t)bytes_read,fd);
        //bytes_written = tfs_write(dstFile, buffer, (size_t)bytes_read);
        if(bytes_read != bytes_written){
            //printf("%ld %ld", bytes_read, bytes_written);
            return -1;
        }
    } while(bytes_read >= sizeof(buffer)-1);
    fclose(fd);
    tfs_close(srcFile);
    tfs_close(dstFile);
    return 0;
}