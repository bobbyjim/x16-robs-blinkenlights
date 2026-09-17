#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "platform.h"
#include "container.h"
#include "image.h"

/* --- name generator -------------------------------------------------- */

static const char *adjectives[] = {
    "arthritic", "banal",       "campy",       "deathly",  "english",
    "figgy",     "grungy",      "hapless",     "insolent", "junk",
    "klepto",    "leggy", 		"maniacal",    "nearsighted", "outre",    "painful",
    "quacking",  "rascally",    "slithy",      "turfal",      "unisex",   "verbal",
    "woeful",    "xanthic",     "yonder",      "zippy"
};
#define N_ADJ  (int)(sizeof(adjectives) / sizeof(adjectives[0]))

static const char *nouns[] = {
    "ankle",   "bat",     "cryptid",  "dunghill", "ent",
    "fink",    "gruel",   "harpy",    "ink",      "job",
    "kerbal",  "lunk",    "mud",      "nerf",     "oaf",
    "punk",    "qagga",   "rennet",   "sinkhole", "tv",
    "unguent", "vat",     "whip",     "xerxes",   "yak",    "zebra"
};
#define N_NOUN (int)(sizeof(nouns) / sizeof(nouns[0]))

static void generate_name(char *buf, int len)
{
    snprintf(buf, len, "%s_%s",
             adjectives[rand() % N_ADJ],
             nouns[rand() % N_NOUN]);
}

/* --- module state ---------------------------------------------------- */

static Container containers[MAX_CONTAINERS];
static int        container_cnt = 0;

void container_clear(void)     { container_cnt = 0; }
int  container_count(void)     { return container_cnt; }

const Container *container_get(int i)
{
    if (i < 0 || i >= container_cnt) return NULL;
    return &containers[i];
}

/* --- operations ------------------------------------------------------ */

int container_find(const char *id)
{
    int i;
    if (!id) return -1;
    for (i = 0; i < container_cnt; ++i)
        if (!strcmp(containers[i].id, id)) return i;
    return -1;
}

int container_create(const char *image_name_or_id)
{
    Container *c;
    int img_idx;

    if (container_cnt == MAX_CONTAINERS) return -2;

    img_idx = image_find(image_name_or_id);
    if (img_idx < 0) return -1;

    c = &containers[container_cnt];
    generate_name(c->id, CONTAINER_ID_LEN);
    strncpy(c->image, image_get(img_idx)->name, sizeof(c->image) - 1);
    c->image[sizeof(c->image) - 1] = '\0';
    c->year   = 1970 + rand() % 56;
    c->month  = 1    + rand() % 12;
    c->day    = 1    + rand() % 28;
    c->hour   = rand() % 24;
    c->min    = rand() % 60;
    c->status = CONTAINER_OK;

    ++container_cnt;
    return 0;
}

int container_stop(const char *id)
{
    int i = container_find(id);
    if (i < 0) return -1;
    containers[i].status = CONTAINER_DEAD;
    return 0;
}

int container_start(const char *id)
{
    int i = container_find(id);
    if (i < 0) return -1;
    containers[i].status = CONTAINER_OK;
    return 0;
}

int container_rm(const char *id)
{
    int i, j;
    i = container_find(id);
    if (i < 0) return -1;
    for (j = i; j < container_cnt - 1; ++j)
        containers[j] = containers[j + 1];
    --container_cnt;
    return 0;
}

void container_list(void)
{
    int i;
    static const char *status_str[] = { "ok", "dead" };
    printf("%-24s %-16s %-18s status\n", "container id", "image",  "created");
    printf("%-24s %-16s %-18s ------\n", "------------", "-----",  "-------");
    for (i = 0; i < container_cnt; ++i)
        printf("%-24s %-16s %04d/%02d/%02d %02d:%02d   %s\n",
               containers[i].id, containers[i].image,
               containers[i].year, containers[i].month, containers[i].day,
               containers[i].hour, containers[i].min,
               status_str[containers[i].status & 1]);
}
