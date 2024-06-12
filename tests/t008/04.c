#include <stdio.h>
static int const two(void) { return 2; }
int              main(void) {
  int const one = 1;
  printf("SingleLine %d %d %f %s", one, two(), 3.0f, "four");
  printf("Multi-line %d %d %f %s", one, two(), 3.0f, "four");
  return 42;
}
