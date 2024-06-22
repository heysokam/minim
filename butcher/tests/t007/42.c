if (debug) {
  static int one = 1;
} else if (release) {
  static int one = 2;
} else if (thing) {
  static int one = 3;
} else if (other) {
  static int one = 4;
} else {
  static int one = 5;
}
