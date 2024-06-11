#if defined(debug) || defined(release)
static int one = 1;
#elif !defined(release) && defined(thing)
static int one = 2;
#elif !defined(thing) && !defined(other)
static int one = 3;
#elif defined(one) || defined(two) && defined(thr) && !defined(fou) || !defined(fiv)
static int one = 4;
#else
static int one = 5;
#endif
