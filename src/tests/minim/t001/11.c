[[noreturn]] static void one(void) {
  exit(0);
  return;
}
_Noreturn static void two(void) {
  exit(0);
  return;
}
__attribute__((noreturn)) static void thr(void) {
  exit(0);
  return;
}
