#ifndef IMAGE_H
#define IMAGE_H

#define MAX_IMAGES    16
#define IMAGE_NAME_LEN 16
#define IMAGE_ID_LEN   10

typedef struct {
    char name[IMAGE_NAME_LEN];
    char id[IMAGE_ID_LEN];
    int  year, month, day, hour, min;
    int  size_kb;
} Image;

/* Returns 0 on success, -1 if at capacity, -2 if name is NULL */
int          image_pull(const char *name);

/* Returns 0 on success, -1 if not found */
int          image_rm(const char *name_or_id);

/* Returns index [0..count) or -1 if not found */
int          image_find(const char *name_or_id);

int          image_count(void);
const Image *image_get(int index);
void         image_list(void);

/* Reset all state (used by tests) */
void         image_clear(void);

#endif
