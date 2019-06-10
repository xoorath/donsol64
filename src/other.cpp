#include <stdio.h>

constexpr float someVal = 5.0f;
constexpr float someVal2 = 5.5f * someVal;

extern "C" {
void xo_other() {
    
    printf("cpp %f\n", someVal2);
}
}