///
/// Alternative to closures1.c, with automation macros
/// https://stackoverflow.com/questions/4393716/is-there-a-a-way-to-achieve-closures-in-c
///

///_______________________________________________________________________________________________
/// Automation Macro
///_____________________________________
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <stdarg.h>
typedef unsigned char u8;

#define NAME_CLOSURE(t) ClosureStruct_ ## t

#define DEF_CLOSURE(t) \
typedef struct {       \
t (*p)();              \
size_t sargs;          \
size_t cargs;          \
u8*    args;           \
} NAME_CLOSURE(t);


///_______________________________________________________________________________________________
/// Defining a closure
///_____________________________________
DEF_CLOSURE(int)  // define closure struct that returns an int

int zFunc(NAME_CLOSURE(int)* cp, int j, int k) {
  va_list jj;
  va_start(jj, cp->args);    // get the address of the first argument
  int i = va_arg(jj, int);
  printf("zFunc() i = %d, j = %d, k = %d\n", i, j, k);
  return i + j + k;
}

typedef struct { char xx[24]; } thing1;

int z2func( NAME_CLOSURE(int) * cp, int i) {
  va_list jj;
  va_start(jj, cp->args);    // get the address of the first argument
  thing1 a = va_arg(jj, thing1);
  printf("z2func() i = %d, %s\n", i, a.xx);
  return 0;
}


///_______________________________________________________________________________________________
/// Usage
///_____________________________________
int mainxx(void) {
  ClosureStruct* p;
  NAME_CLOSURE(int) *pint;

  int x;
  thing1 xpxp = { "1234567890123" };

  p = makeClosure(funcadd, 256);
  x = 4;  pushClosureArg(p, sizeof(int), &x);
  x = 10;  pushClosureArg(p, sizeof(int), &x);

  p->p(p, 1, 2, 3);

  free(p);

  pint = makeClosure(z2func, sizeof(thing1));
  pushClosureArg(pint, sizeof(thing1), &xpxp);

  int k = pint->p(pint, 45);

  free(pint);

  pint = makeClosure(zFunc, sizeof(int));
  x = 5; pushClosureArg(pint, sizeof(int), &x);

  k = pint->p(pint, 12, 7);
  return 0;
}
