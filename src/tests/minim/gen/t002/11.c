static Thing1 thing1 = (Thing1) { 0 };
static Thing2 thing2 = (Thing2) { .one = 1, .two = 2 };
static Thing3 thing3 = (Thing3) {
  .one   = 11,
  .two   = 22,
  .three = &(Thing2) {.one = 111, .two = 222}
};
