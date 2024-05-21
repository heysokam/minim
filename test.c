typedef int* i32;
//_________________________________________
int one(void);
int one(void) { return 1; }
//_________________________________________
int two(void);
int two(void) { return 2; }
///___Test____________________________________
int main(void) {
  // @descr thing
  if (one() == 1) return two();
  return 42;
}
