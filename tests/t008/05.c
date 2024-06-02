#include <stdio.h>
int main(void) {
  int const one = 1;
  printf("Hello World %p", &one);
  printf("Hello World %p", &one);
  return 42;
}
