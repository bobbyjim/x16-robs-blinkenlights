#ifndef _CONTAINER_H_
#define _CONTAINER_H_

void container_ps();
void container_root();
void container_create(char *imageId);
void container_stop(char *id);
void container_start(char *id);
void container_rm(char *id);
#endif
