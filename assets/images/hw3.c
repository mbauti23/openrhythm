#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <fcntl.h>

//Used Chapters 8.4 - 8.6 in the textbook for signal methods
//used http://man7.org/linux/man-pages/man7/signal.7.html for signal methods
//used https://www.geeksforgeeks.org/signals-c-language/ for signal concepts and integers

void SIGINT_h (int sig) {
    printf("\nCaught: Interrupt\n");
    write(1, "361 > ", 5);
}

void SIGTSTP_h (int sig) {
    write(1, "361 > ", 5);
}

int main()
{
    int redirect = 0;
    char fName[300];

    signal(SIGINT, SIGINT_h);
    signal(SIGTSTP, SIGTSTP_h);

    char line[300];  
    char* args[500];

    while(1) {

        write(1, "361 > ", 5);
        fgets(line, 1024, stdin);

            if (line[strlen(line) - 1] == '\n')
                line[strlen(line) - 1] = '\0';

            if(strcmp(line, "exit") == 0)
                break;

            char *word = strtok(line, " ");
            int i = 0;

            while (word) {
            args[i] = word;
            word = strtok(NULL, " ");
            i = i + 1;
            }

            args[i] = NULL;

        int x;    
        for(x = 0; x < i; x++)
        {
            if (strcmp(args[x], ">") == 0)
            {
                strcpy(fName, args[x + 1]);
                int fd = open(fName, O_RDWR | O_CREAT| O_TRUNC, S_IRUSR | S_IWUSR);
                int pid = fork();
                args[x + 1] = NULL;
                args[x] =  NULL;

                if(pid == 0)
                {
                    dup2(fd, 1);
                    execvp(args[0], args); 
                    close(fd); 
                }
                else 
                {
                    printf("pid: %d ", pid);
                    int status;
                    wait(&status);
                    printf("status %d\n", WEXITSTATUS(status));
                }

                redirect=1;
                break;
            }

            else if (strcmp(args[x], ">>") == 0)
            {
                strcpy(fName, args[x + 1]);
                int fd = open(fName, O_WRONLY | O_APPEND | O_CREAT);
                int pid = fork();
                args[x + 1] = NULL;
                args[x] =  NULL;

                if(pid == 0)
                {
                    dup2(fd, 1);
                    execvp(args[0], args); 
                    close(fd); 
                }
                else 
                {
                    printf("pid: %d ", pid);
                    int status;
                    wait(&status);
                    printf("status %d\n", WEXITSTATUS(status));
                }
                redirect=1;
               
                break;
            }

            else if (strcmp(args[x], "<") == 0)
            {
                char buff[500];
                strcpy(buff, " ");

                int fd = open(args[x + 1], O_RDONLY);
                int fsize = lseek(fd, 0, SEEK_END);
                close(fd);
                fd = open(args[x + 1], O_RDONLY);

                read(fd, buff, fsize - 1);
                buff[fsize - 1] = '\0';

                i = 0;
                char *word1 = strtok(buff, " ");
                while (word1) {
                    args[i] = word1;
                    word1 = strtok(NULL, " ");
                    i = i + 1;
                }

                int pid = fork();
                if(pid == 0)
                {
                    execvp(args[0], args);  
                    exit(0);
                }

                else 
                {
                    printf("pid: %d ", pid);
                    int status;
                    wait(&status);
                    printf("status %d\n", WEXITSTATUS(status));
                }
    
                redirect = 1;
                close(fd);
                break;
            }
        }

        if(redirect == 0) {

            int pid = fork();

            if(pid == 0)
            {
                execvp(args[0], args);  
                exit(0);
            }   
            else 
            {
                printf("pid: %d ", pid);
                int status;
                wait(&status);
                printf("status %d\n", WEXITSTATUS(status));
            }
    }
}
    return 0;
}
