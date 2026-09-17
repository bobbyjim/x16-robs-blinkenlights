#ifndef CONTAINER_H
#define CONTAINER_H

#define MAX_CONTAINERS   16
#define CONTAINER_ID_LEN 24

#define CONTAINER_OK   0
#define CONTAINER_DEAD 1

typedef struct {
    char id[CONTAINER_ID_LEN];
    char image[16];
    int  year, month, day, hour, min;
    int  status;
} Container;

/* Returns 0 on success, -1 if image not found, -2 if at capacity */
int              container_create(const char *image_name_or_id);

/* Returns index or -1 */
int              container_find(const char *id);

/* Returns 0 on success, -1 if not found */
int              container_stop(const char *id);
int              container_start(const char *id);
int              container_rm(const char *id);

int              container_count(void);
const Container *container_get(int index);
void             container_list(void);

/* Reset all state (used by tests) */
void             container_clear(void);

#endif
