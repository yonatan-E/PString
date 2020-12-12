#include "pstring.h"
#include "string.h"
#include "stdio.h"

int main() {
    Pstring ps;
    ps.len = 10;
    strncpy(ps.str, "HezKKkKkPOp", 11);
    Pstring ps2;
    ps2.len = 10;
    strncpy(ps2.str, "Heyhellopop", 11);

    printf("rslt: %d\n", pstrijcmp(&ps, &ps2, 2, 5));

    return 0;
}