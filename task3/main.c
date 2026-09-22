#include "context.h"
#include <stdio.h>
#include <stdlib.h>

context_t ctx;
extern int set_ctx(context_t *ctx);
extern void jmp_to(context_t *ctx, int value);
int i;

void oh_p() {
    if (i == 0)
        jmp_to(&ctx, 2);
    else if (i == 2)
        jmp_to(&ctx, 3);
    else
        exit(0);
}

int main() {
    i = set_ctx(&ctx);
    printf("%d", i);
    oh_p();
    printf("[Error]: This line should not be printed!");
}
