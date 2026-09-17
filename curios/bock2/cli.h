#ifndef CLI_H
#define CLI_H

#define CLI_MAX_ARGS 20
#define CLI_LINE_LEN 80

/*
 * Split 'line' into whitespace-delimited tokens in-place.
 * Writes up to max_argc pointers into argv[].
 * Returns argc (modifies line!).
 */
int cli_tokenize(char *line, char **argv, int max_argc);

/*
 * Dispatch argc/argv to the matching command handler.
 * Returns 0 to keep running, -1 to quit.
 */
int cli_dispatch(int argc, char **argv);

#endif
