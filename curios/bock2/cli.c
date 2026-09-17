#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "platform.h"
#include "cli.h"
#include "image.h"
#include "container.h"

/* ------------------------------------------------------------------ */
/* Tokenizer                                                           */
/* ------------------------------------------------------------------ */

int cli_tokenize(char *line, char **argv, int max_argc)
{
    int   argc  = 0;
    char *token = strtok(line, " \t");
    while (token && argc < max_argc) {
        argv[argc++] = token;
        token = strtok(NULL, " \t");
    }
    return argc;
}

/* ------------------------------------------------------------------ */
/* Command handlers                                                    */
/* ------------------------------------------------------------------ */

static void cmd_ps(int argc, char **argv)
{
    (void)argc; (void)argv;
    container_list();
}

static void cmd_image(int argc, char **argv)
{
    char saved[IMAGE_NAME_LEN];
    int  idx;

    if (argc < 2) {
        image_list();
        return;
    }

    if (!strcmp(argv[1], "pull")) {
        if (argc < 3) { printf( "usage: image pull <name>\n"); return; }
        switch (image_pull(argv[2])) {
            case  0: printf("pulled %s\n", argv[2]);                      break;
            case -1: printf( "error: image registry full\n");     break;
            case -2: printf( "error: image name required\n");     break;
        }

    } else if (!strcmp(argv[1], "rm")) {
        if (argc < 3) { printf( "usage: image rm <name|id>\n"); return; }
        idx = image_find(argv[2]);
        if (idx < 0) { printf( "error: no such image: %s\n", argv[2]); return; }
        strncpy(saved, image_get(idx)->name, IMAGE_NAME_LEN - 1);
        saved[IMAGE_NAME_LEN - 1] = '\0';
        image_rm(saved);
        printf("image [%s] removed\n", saved);

    } else {
        printf( "unknown image subcommand: %s\n", argv[1]);
        printf( "subcommands: pull, rm\n");
    }
}

static void cmd_container(int argc, char **argv)
{
    char saved[CONTAINER_ID_LEN];
    int  idx;

    if (argc < 2) {
        printf( "usage: container <create|stop|start|rm> ...\n");
        return;
    }

    if (!strcmp(argv[1], "create")) {
        if (argc < 3) { printf( "usage: container create <image>\n"); return; }
        switch (container_create(argv[2])) {
            case  0:
                printf("container [%s] created\n",
                       container_get(container_count() - 1)->id);
                break;
            case -1: printf( "error: no such image: %s\n",        argv[2]); break;
            case -2: printf( "error: container registry full\n");            break;
        }

    } else if (!strcmp(argv[1], "stop")) {
        if (argc < 3) { printf( "usage: container stop <id>\n"); return; }
        if (container_stop(argv[2]) < 0)
            printf( "error: no such container: %s\n", argv[2]);
        else
            printf("container [%s] stopped\n", argv[2]);

    } else if (!strcmp(argv[1], "start")) {
        if (argc < 3) { printf( "usage: container start <id>\n"); return; }
        if (container_start(argv[2]) < 0)
            printf( "error: no such container: %s\n", argv[2]);
        else
            printf("container [%s] started\n", argv[2]);

    } else if (!strcmp(argv[1], "rm")) {
        if (argc < 3) { printf( "usage: container rm <id>\n"); return; }
        idx = container_find(argv[2]);
        if (idx < 0) { printf( "error: no such container: %s\n", argv[2]); return; }
        strncpy(saved, container_get(idx)->id, CONTAINER_ID_LEN - 1);
        saved[CONTAINER_ID_LEN - 1] = '\0';
        container_rm(saved);
        printf("container [%s] removed\n", saved);

    } else {
        printf( "unknown container subcommand: %s\n", argv[1]);
        printf( "subcommands: create, stop, start, rm\n");
    }
}

static void cmd_quit(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* returning -1 signals the main loop to exit */
}

/* ------------------------------------------------------------------ */
/* Dispatch table                                                      */
/* ------------------------------------------------------------------ */

/* forward-declare so cmd_help can reference commands[] */
static void cmd_help(int argc, char **argv);

typedef void (*CmdFn)(int, char **);

typedef struct {
    const char *verb;
    const char *synopsis;
    CmdFn       fn;
} Command;

static const Command commands[] = {
    { "ps",        "list containers",                          cmd_ps        },
    { "image",     "image pull <name> | image rm <name|id>",  cmd_image     },
    { "container", "container create|stop|start|rm <id>",     cmd_container },
    { "quit",      "exit bock2",                              cmd_quit      },
    { "help",      "show this help",                          cmd_help      },
};
#define N_COMMANDS (int)(sizeof(commands) / sizeof(commands[0]))

static void cmd_help(int argc, char **argv)
{
    int i;
    (void)argc; (void)argv;
    printf("commands:\n");
    for (i = 0; i < N_COMMANDS; ++i)
        printf("  %-12s  %s\n", commands[i].verb, commands[i].synopsis);
}

/* ------------------------------------------------------------------ */
/* Dispatcher                                                          */
/* ------------------------------------------------------------------ */

int cli_dispatch(int argc, char **argv)
{
    int i;
    if (argc == 0) return 0;
    for (i = 0; i < N_COMMANDS; ++i) {
        if (!strcmp(argv[0], commands[i].verb)) {
            commands[i].fn(argc, argv);
            return (commands[i].fn == cmd_quit) ? -1 : 0;
        }
    }
    printf( "unknown command: %s  (try 'help')\n", argv[0]);
    return 0;
}
