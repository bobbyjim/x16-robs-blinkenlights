
#include <stdio.h>
#include <conio.h>
#include <dirent.h>
#include <ctype.h>
#include <string.h>

#include "helloworld.h"

void listdir() {
	int i;
	char c;
    DIR *dir;
    struct dirent *dent;
    dir = opendir(".");

    if(dir!=NULL) {
        while((dent=readdir(dir))!=NULL) {
			for (i=0; i<strlen(dent->d_name); ++i) {
			    c = dent->d_name[i];
				if (c>95) 
					cputc(c-32);
				else 
				   cputc(c);
			}
            puts("\n");
		}
    }
    closedir(dir);	
}

void hello_world()
{
	FILE *fp;
	int c;

	fp = fopen("helloworld.txt", "r");
	while(1) {
		c = fgetc(fp);
		printf("%c", c);
		if (c==-1) break;  // eof
	}
	fclose(fp);
}

void make_file()
{
	FILE *fp;
	int status;

	fp = fopen("helloworld.txt", "w");

	fputs("this is the first test.\n", fp);
	status = fprintf( fp, "%s\n", "hello world.\n" );
	cprintf("status: %d\r\n", status);
	status = fflush(fp);
	cprintf("status: %d\r\n", status);
	status = fclose(fp);
	cprintf("status: %d\r\n", status);
}