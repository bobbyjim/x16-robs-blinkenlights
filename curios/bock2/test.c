#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "image.h"
#include "container.h"
#include "cli.h"

/* ------------------------------------------------------------------ */
/* Minimal test harness                                                */
/* ------------------------------------------------------------------ */

static int passed = 0;
static int failed = 0;

#define CHECK(expr, msg) \
    do { \
        if (expr) { \
            ++passed; \
        } else { \
            ++failed; \
            printf("FAIL [line %d]: %s\n", __LINE__, msg); \
        } \
    } while (0)

/* ------------------------------------------------------------------ */
/* Image tests                                                         */
/* ------------------------------------------------------------------ */

static void test_image_pull_ok(void)
{
    image_clear();
    CHECK(image_pull("ubuntu") == 0,  "pull ubuntu succeeds");
    CHECK(image_count()        == 1,  "count is 1 after pull");
    CHECK(image_get(0)         != NULL, "image_get(0) is not null");
}

static void test_image_pull_null(void)
{
    image_clear();
    CHECK(image_pull(NULL) == -2, "pull(NULL) returns -2");
    CHECK(image_count()    == 0,  "count unchanged after null pull");
}

static void test_image_full(void)
{
    int i;
    image_clear();
    for (i = 0; i < MAX_IMAGES; ++i)
        image_pull("img");
    CHECK(image_count()        == MAX_IMAGES, "count reaches MAX_IMAGES");
    CHECK(image_pull("onemore") == -1,        "pull when full returns -1");
    CHECK(image_count()        == MAX_IMAGES, "count unchanged after rejected pull");
}

static void test_image_find_by_name(void)
{
    image_clear();
    image_pull("alpine");
    CHECK(image_find("alpine") == 0,  "find by name returns 0");
    CHECK(image_find("ubuntu") == -1, "find missing name returns -1");
    CHECK(image_find(NULL)     == -1, "find(NULL) returns -1");
}

static void test_image_find_by_id(void)
{
    const Image *img;
    image_clear();
    srand(1);
    image_pull("debian");
    img = image_get(0);
    CHECK(img != NULL,               "image_get(0) not null");
    CHECK(image_find(img->id) == 0,  "find by id returns 0");
}

static void test_image_rm_ok(void)
{
    image_clear();
    image_pull("ubuntu");
    image_pull("alpine");
    CHECK(image_rm("ubuntu")    == 0,  "rm ubuntu ok");
    CHECK(image_count()         == 1,  "count is 1 after rm");
    CHECK(image_find("ubuntu")  == -1, "removed image not findable");
    CHECK(image_find("alpine")  == 0,  "remaining image compacted to index 0");
}

static void test_image_rm_missing(void)
{
    image_clear();
    CHECK(image_rm("nosuchimage") == -1, "rm missing returns -1");
}

/* ------------------------------------------------------------------ */
/* Container tests                                                     */
/* ------------------------------------------------------------------ */

/* Sets up a clean slate with one image ready to use. */
static void setup(void)
{
    image_clear();
    container_clear();
    srand(42);
    image_pull("ubuntu");
}

static void test_container_create_ok(void)
{
    setup();
    CHECK(container_create("ubuntu") == 0, "create from ubuntu ok");
    CHECK(container_count()          == 1, "count is 1 after create");
    CHECK(container_get(0)           != NULL, "container_get(0) not null");
}

static void test_container_create_no_image(void)
{
    setup();
    CHECK(container_create("nosuchimage") == -1, "create missing image returns -1");
    CHECK(container_count()               == 0,  "count unchanged");
}

static void test_container_create_full(void)
{
    int i;
    setup();
    for (i = 0; i < MAX_CONTAINERS; ++i)
        container_create("ubuntu");
    CHECK(container_count()          == MAX_CONTAINERS, "count hits MAX_CONTAINERS");
    CHECK(container_create("ubuntu") == -2,             "create when full returns -2");
    CHECK(container_count()          == MAX_CONTAINERS, "count unchanged after reject");
}

static void test_container_stop_ok(void)
{
    char id[CONTAINER_ID_LEN];
    setup();
    container_create("ubuntu");
    strncpy(id, container_get(0)->id, CONTAINER_ID_LEN);
    CHECK(container_stop(id)              == 0,              "stop ok");
    CHECK(container_get(0)->status        == CONTAINER_DEAD, "status DEAD after stop");
}

static void test_container_stop_missing(void)
{
    setup();
    CHECK(container_stop("nosuchid") == -1, "stop missing returns -1");
}

static void test_container_start_ok(void)
{
    char id[CONTAINER_ID_LEN];
    setup();
    container_create("ubuntu");
    strncpy(id, container_get(0)->id, CONTAINER_ID_LEN);
    container_stop(id);
    CHECK(container_start(id)             == 0,            "start ok");
    CHECK(container_get(0)->status        == CONTAINER_OK, "status OK after start");
}

static void test_container_start_missing(void)
{
    setup();
    CHECK(container_start("nosuchid") == -1, "start missing returns -1");
}

static void test_container_rm_ok(void)
{
    char id[CONTAINER_ID_LEN];
    setup();
    container_create("ubuntu");
    strncpy(id, container_get(0)->id, CONTAINER_ID_LEN);

    CHECK(container_rm(id)          == 0,  "rm ok");
    CHECK(container_count()         == 0,  "count decremented after rm");
    CHECK(container_find(id)        == -1, "removed container not findable");
}

static void test_container_rm_missing(void)
{
    setup();
    CHECK(container_rm("nosuchid") == -1, "rm missing returns -1");
}

static void test_container_rm_compacts(void)
{
    char id0[CONTAINER_ID_LEN], id1[CONTAINER_ID_LEN], id2[CONTAINER_ID_LEN];
    setup();
    container_create("ubuntu");
    container_create("ubuntu");
    container_create("ubuntu");
    strncpy(id0, container_get(0)->id, CONTAINER_ID_LEN);
    strncpy(id1, container_get(1)->id, CONTAINER_ID_LEN);
    strncpy(id2, container_get(2)->id, CONTAINER_ID_LEN);

    container_rm(id1);  /* remove middle */

    CHECK(container_count()        == 2,  "count is 2 after removing middle");
    CHECK(container_find(id0)      >= 0,  "first container still present");
    CHECK(container_find(id2)      >= 0,  "last container still present");
    CHECK(container_find(id1)      == -1, "middle container gone");
}

/* ------------------------------------------------------------------ */
/* Tokenizer tests                                                     */
/* ------------------------------------------------------------------ */

static void test_tokenize_basic(void)
{
    char  line[] = "container create ubuntu";
    char *argv[10];
    int   argc = cli_tokenize(line, argv, 10);
    CHECK(argc == 3,                        "3 tokens");
    CHECK(!strcmp(argv[0], "container"),    "argv[0]=container");
    CHECK(!strcmp(argv[1], "create"),       "argv[1]=create");
    CHECK(!strcmp(argv[2], "ubuntu"),       "argv[2]=ubuntu");
}

static void test_tokenize_empty(void)
{
    char  line[] = "";
    char *argv[10];
    int   argc = cli_tokenize(line, argv, 10);
    CHECK(argc == 0, "empty string -> argc=0");
}

static void test_tokenize_extra_spaces(void)
{
    char  line[] = "image  pull   alpine";
    char *argv[10];
    int   argc = cli_tokenize(line, argv, 10);
    CHECK(argc == 3,                    "3 tokens despite extra spaces");
    CHECK(!strcmp(argv[1], "pull"),     "argv[1]=pull");
    CHECK(!strcmp(argv[2], "alpine"),   "argv[2]=alpine");
}

static void test_tokenize_caps(void)
{
    char  line[] = "PS";       /* PETSCII arrives uppercase */
    char *argv[10];
    int   argc = cli_tokenize(line, argv, 10);
    CHECK(argc == 1,               "1 token");
    CHECK(!strcmp(argv[0], "PS"),  "token preserved as-is");
}

/* ------------------------------------------------------------------ */
/* Dispatcher safety tests                                             */
/* ------------------------------------------------------------------ */

static void test_dispatch_empty(void)
{
    char *argv[1];     /* unused, but avoids zero-length array warning */
    CHECK(cli_dispatch(0, argv) == 0, "dispatch argc=0 is safe");
}

static void test_dispatch_unknown(void)
{
    char *argv[] = { "flibble" };
    CHECK(cli_dispatch(1, argv) == 0, "dispatch unknown command returns 0");
}

static void test_dispatch_quit(void)
{
    char *argv[] = { "quit" };
    CHECK(cli_dispatch(1, argv) == -1, "dispatch quit returns -1");
}

/* ------------------------------------------------------------------ */
/* Runner                                                              */
/* ------------------------------------------------------------------ */

int main(void)
{
    printf("=== bock2 tests ===\n\n");

    /* image */
    test_image_pull_ok();
    test_image_pull_null();
    test_image_full();
    test_image_find_by_name();
    test_image_find_by_id();
    test_image_rm_ok();
    test_image_rm_missing();

    /* container */
    test_container_create_ok();
    test_container_create_no_image();
    test_container_create_full();
    test_container_stop_ok();
    test_container_stop_missing();
    test_container_start_ok();
    test_container_start_missing();
    test_container_rm_ok();
    test_container_rm_missing();
    test_container_rm_compacts();

    /* tokenizer */
    test_tokenize_basic();
    test_tokenize_empty();
    test_tokenize_extra_spaces();
    test_tokenize_caps();

    /* dispatcher */
    test_dispatch_empty();
    test_dispatch_unknown();
    test_dispatch_quit();

    printf("\n%d passed, %d failed\n", passed, failed);
    return (failed == 0) ? 0 : 1;
}
