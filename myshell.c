#include <stdio.h>

#include <string.h>

#include <unistd.h>

#include <sys/wait.h>

#include <stdlib.h>

#include <stdint-gcc.h>





#define MAX_COMMAND_LENGTH 100

#define MAX_HISTORY_SIZE 100

int history_count = 0;

char history[MAX_HISTORY_SIZE][MAX_COMMAND_LENGTH];

pid_t pid_history[100];



void new_path(int arg, char *argv[]) {

    int i;

    for (i = 0; i < arg; i++) {

        char *z = getenv("PATH");

        strcat(z, ":/");

        strcat(z, argv[i]);

        setenv("PATH", z, 0);

    }

}



void print_history() {



    for (int i = 0; i < history_count; i++) {

        printf("%d %s\n", pid_history[i], history[i]);

    }

}



int execute_cd(char arguments[]) {

    if (strcmp(arguments, "..") == 0) {

        chdir("..");

        return 0;

    }

    if (arguments[0] == '/') {

        if (chdir(arguments) == -1) {

            perror("cd failed");

            return 1;



        }

    } else {

        char current_dir[100];

        getcwd(current_dir, 100);

        strcat(current_dir, "/");

        strcat(current_dir, arguments);

        // Change the current working directory

        if (chdir(current_dir) == -1) {

            perror("cd failed");

            free(current_dir);

            return 1;



        }

    }

    return 0;



}



void execute_exit() {

    exit(0);

}





void print_prompt() {

    printf("$");

    fflush(stdout);

}



int main(int arg, char *argv[]) {



    new_path(arg, argv);

    //all the command

    char command[MAX_COMMAND_LENGTH];

    //all strings in the command

    char *arguments[100];

    while (1) {

        print_prompt();

        if (fgets(command, MAX_COMMAND_LENGTH, stdin) == NULL) {

            // If fgets returns NULL, the user has pressed Ctrl-D to indicate end-of-file

            printf("\n");

            break;

        }



        // Remove the newline character from the input

        command[strcspn(command, "\n")] = '\0';



        // Parse the input into command and ents

        int arg_count = 0;



        char *token = strtok(command, " ");

        while (token != NULL && arg_count < 100) {

            arguments[arg_count] = token;

            arg_count++;

            token = strtok(NULL, " ");

        }

        arguments[arg_count] = NULL;

        // Handle built-in commands

        if (strcmp(arguments[0], "cd") == 0) {

            if (arg_count > 2) {

                fprintf(stderr, "cd: too many arguments\n");

            } else {

                int status = execute_cd(arguments[1]);

                if (status == 1) {

                    continue;

                } else {

                    strcpy(history[history_count], command);

                    pid_history[history_count] = getpid();

                    history_count++;

                    continue;

                }

            }

        }

        if (strcmp(arguments[0], "exit") == 0) {

            execute_exit();

        }

        if (strcmp(arguments[0], "history") == 0) {

            strcpy(history[history_count], command);

            pid_history[history_count] = getpid();

            history_count++;

            print_history();

            continue;

        }

        // Fork a child process to run the command

        pid_t pid = fork();



        if (pid == -1) {

            perror("fork failed");

            continue;

        }

        if (pid == 0) {

            // Child process: execute the command

            execvp(arguments[0], arguments);

            perror("execl failed");

            strcpy(history[history_count], command);

            pid_history[history_count] = pid;

            history_count++;

            exit(0);



        } else {

            // Parent process: wait for the child to finish

            int status, waited;

            waited = wait(&status);

            // Add the command to the history

            strcpy(history[history_count], command);

            pid_history[history_count] = pid;

            history_count++;



        }

    }

}



