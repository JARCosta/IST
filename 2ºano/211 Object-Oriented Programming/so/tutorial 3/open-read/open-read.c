/*
 * open-read.c
 *
 * Simple example of opening and reading to a file.
 *
 */

#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>


int main(int argc, char *argv[])
{
   /*
    *
    * the attributes are:
    * - O_RDONLY: open the file for reading
    *
    */

   FILE* fd = fopen("test.txt", "r");
   if (fd < 0){
      printf("open error: %s\n", strerror(errno));
      return -1;
   }

   char buffer[128];
   memset(buffer,0,sizeof(buffer));

   /* read the contents of the file */
   //int bytes_read = read(fd, buffer, sizeof(buffer));
   int bytes_read;
   
   

   printf("%s",buffer);   
   
   do{
      bytes_read = fread(buffer,1,sizeof(buffer)-1,fd);
      buffer[bytes_read] = '\0';
      printf("%s",buffer);
      //printf("%d",bytes_read);

      if (bytes_read < 0){
         printf("read error: %s\n", strerror(errno));
         return -1;
      }
   }
   while(bytes_read >= sizeof(buffer)-1);
   

   /* close the file */
   fclose(fd);

   return 0;
}
