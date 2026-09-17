CC     = cc
CFLAGS = -Wall -Wextra -std=c11 -g

SRCS   = image.c container.c cli.c

.PHONY: all test clean

all: bock2-host

bock2-host: main.c $(SRCS)
	$(CC) $(CFLAGS) -o $@ $^

test: test.c $(SRCS)
	$(CC) $(CFLAGS) -o test_runner $^
	./test_runner

clean:
	rm -f bock2-host test_runner
