#include "library.h"

#include <sys/stat.h>

int run_chmod(char *path, int mode) {
    int exitCode = chmod(path, mode);

    return exitCode;
}
