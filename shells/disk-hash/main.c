
#include <conio.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <6502.h>

char line[80];
char key[40], value[40], newvalue[40];
FILE *fp;

int getSymbol( char* key, char* value )
{
   char filename[24];
   sprintf(filename, "hash-%s.txt", key);
   fp = fopen( filename, "r" );
   if (!fp) return 0;
   fgets(value, 40, fp);
   fclose(fp);
   return 1;
}

int putSymbol( char* key, char* value )
{
   char filename[24];
   sprintf(filename, "hash-%s.txt", key);
   fp = fopen( filename, "w" );
   if (!fp) return 0;
   fputs(value, fp);
   fclose(fp);
   return 1;
}

void showDir()
{
   DIR *dir = opendir(".");
   struct dirent *ent;
   while(ent = readdir(dir)) 
   {
      printf("%2u %16s %u\n", ent->d_type, ent->d_name, ent->d_blocks);
   }
   closedir(dir);
}

void main()
{
   showDir();
   putSymbol("foo", "bar");
   getSymbol("foo", value);
   printf("foo: [%s]\n", value);
}
