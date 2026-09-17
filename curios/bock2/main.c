#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "platform.h"
#include "cli.h"

MAIN(void)
{
    char  line[CLI_LINE_LEN];
    char *argv[CLI_MAX_ARGS];
    int   argc;

    platform_init();
    srand((unsigned int)time(NULL));

    printf("bock bock.  (type 'help' for commands, 'quit' or Ctrl-D to exit)\n");

    while (printf("\n%% "), fgets(line, sizeof(line), stdin)) {
        line[strcspn(line, "\r\n")] = '\0';     /* strip newline */
        argc = cli_tokenize(line, argv, CLI_MAX_ARGS);
        if (cli_dispatch(argc, argv) == -1)
            break;
    }

    printf("\nbock bock.\n");
}
