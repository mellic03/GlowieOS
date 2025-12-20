#pragma once

typedef void* FILE;

FILE *fopen(const char*, const char*);
int *fclose(FILE*);
