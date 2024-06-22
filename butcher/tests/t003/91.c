int const main(void) {
  int one = 1;
  do { /* block thing */
    int two = 2;
    break;
    two = 3;
  } while (false); /* << block thing: ... */
}
