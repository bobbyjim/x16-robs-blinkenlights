#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "platform.h"
#include "image.h"

static Image images[MAX_IMAGES];
static int   image_cnt = 0;

void image_clear(void)          { image_cnt = 0; }
int  image_count(void)          { return image_cnt; }

const Image *image_get(int i)
{
    if (i < 0 || i >= image_cnt) return NULL;
    return &images[i];
}

int image_find(const char *name_or_id)
{
    int i;
    if (!name_or_id) return -1;
    for (i = 0; i < image_cnt; ++i) {
        if (!strcmp(images[i].name, name_or_id)) return i;
        if (!strcmp(images[i].id,   name_or_id)) return i;
    }
    return -1;
}

int image_pull(const char *name)
{
    Image *img;
    if (!name)                  return -2;
    if (image_cnt == MAX_IMAGES) return -1;

    img = &images[image_cnt];
    strncpy(img->name, name, IMAGE_NAME_LEN - 1);
    img->name[IMAGE_NAME_LEN - 1] = '\0';
    snprintf(img->id, IMAGE_ID_LEN, "%08x", rand());
    img->year    = 1970 + rand() % 56;
    img->month   = 1    + rand() % 12;
    img->day     = 1    + rand() % 28;
    img->hour    = rand() % 24;
    img->min     = rand() % 60;
    img->size_kb = 1    + rand() % 254;

    ++image_cnt;
    return 0;
}

int image_rm(const char *name_or_id)
{
    int i, j;
    i = image_find(name_or_id);
    if (i < 0) return -1;
    for (j = i; j < image_cnt - 1; ++j)
        images[j] = images[j + 1];
    --image_cnt;
    return 0;
}

void image_list(void)
{
    int i;
    printf("%-16s %-10s  %-16s  size\n",   "repository",  "image id", "created");
    printf("%-16s %-10s  %-16s  ----\n",   "----------",  "--------", "-------");
    for (i = 0; i < image_cnt; ++i)
        printf("%-16s %-10s  %04d/%02d/%02d %02d:%02d  %d kb\n",
               images[i].name, images[i].id,
               images[i].year, images[i].month, images[i].day,
               images[i].hour, images[i].min,
               images[i].size_kb);
}
