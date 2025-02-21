while (someCall(1) && otherThing(42)) {
  static int one = 1;
  if (one) {
    return one;
  } else if (2) {
    continue;
  } else {
    break;
  }
}
