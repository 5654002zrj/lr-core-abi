#include <stddef.h>
#include <stdio.h>
#include <string.h>

extern size_t my_strlen(const char *s);

static const char *cases[] = {
    "",
    "a",
    "abc",
    "abcdefg",
    "abcdefgh",
    "hello, world",
    "a\0b",
};

#define NCASE (sizeof(cases) / sizeof(cases[0]))

int main(void) {
    for (size_t k = 0; k < NCASE; k++) {
        const char *s = cases[k];
        size_t got = my_strlen(s);
        size_t want = strlen(s);
        if (got != want) {
            printf("[Error]: my_strlen(\"%s\") = %lu,库函数 strlen = %lu\n", s,
                   (unsigned long)got, (unsigned long)want);
            return 1;
        }
    }
    printf("my_strlen: %lu 个样例全部与库函数一致\n",
           (unsigned long)NCASE);
    return 0;
}
