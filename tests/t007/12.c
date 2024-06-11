#if defined(debug)
static int one = 1;
#elif defined(release)
static int one = 2;
#elif defined(thing)
static int one = 3;
#elif defined(other)
static int one = 4;
#else
static int one = 5;
#endif
