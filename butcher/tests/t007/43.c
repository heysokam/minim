if (debug || release) {
  static int one = 1;
} else if (!release || thing) {
  static int one = 2;
} else if (!thing && !other) {
  static int one = 3;
} else if (one || two || thr && !fou || !fiv) {
  static int one = 4;
} else {
  static int one = 5;
}
