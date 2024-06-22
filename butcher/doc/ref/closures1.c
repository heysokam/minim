///
/// https://stackoverflow.com/questions/4393716/is-there-a-a-way-to-achieve-closures-in-c
///

///_______________________________________________________________________________________________
/// Definition
///_____________________________________
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <stdarg.h>

typedef unsigned char u8;
typedef struct {
  void (*p)();   // pointer to the function of this closure
  size_t sargs;  // size of the memory area allocated for closure data
  size_t cargs;  // current memory area in use for closure data
  u8*    args;   // pointer to the allocated closure data area
} ClosureStruct;

void* makeClosure(void (*p)(), size_t sargs){
  // allocate the space for the closure management data and the closure data itself.
  // we do this with a single call to calloc() so that we have only one pointer to manage.
  ClosureStruct* cp = calloc(1, sizeof(ClosureStruct) + sargs);

  if (cp) {
    cp->p     = p;              // save a pointer to the function
    cp->sargs = sargs;          // save the total size of the memory allocated for closure data
    cp->cargs = 0;              // initialize the amount of memory used
    cp->args  = (u8*)(cp + 1);  // closure data is after closure management block
  }

  return cp;
}

void* pushClosureArg(void* cp, size_t sarg, void* arg){
  if (cp) {
    ClosureStruct* p = cp;
    if (p->cargs + sarg <= p->sargs) {
      // there is room in the closure area for this argument
      // make a copy of the argument and remember our new end of memory
      memcpy(p->args + p->cargs, arg, sarg);
      p->cargs += sarg;
    }
  }
  return cp;
}


///_______________________________________________________________________________________________
/// Usage
///_____________________________________
// example functions that we will use with closures

// funcadd() is a function that accepts a closure with two int arguments
// along with three additional int arguments.
// it is similar to the following function declaration:
//  void funcadd(int x1, int x2, int a, int b, int c);
//
void funcadd(ClosureStruct* cp, int a, int b, int c) {
  // using the variable argument functionality
  // we will set our variable argument list address to the closure argument memory area
  // and then start pulling off the arguments that are provided by the closure.
  va_list jj;
  va_start(jj, cp->args);    // get the address of the first argument
  int x1 = va_arg(jj, int);  // get the first argument of the closure
  int x2 = va_arg(jj, int);
  printf("funcadd() = %d\n", a + b + c + x1 + x2);
}

int zFunc(ClosureStruct* cp, int j, int k) {
  va_list jj;
  va_start(jj, cp->args);    // get the address of the first argument
  int i = va_arg(jj, int);
  printf("zFunc() i = %d, j = %d, k = %d\n", i, j, k);
  return i + j + k;
}

typedef struct { char xx[24]; } thing1;

int z2func(ClosureStruct* cp, int i) {
  va_list jj;
  va_start(jj, cp->args);    // get the address of the first argument
  thing1 a = va_arg(jj, thing1);
  printf("z2func() i = %d, %s\n", i, a.xx);
  return 0;
}

int mainxx(void) {
  ClosureStruct* p;

  int x;
  thing1 xpxp = { "1234567890123" };

  p = makeClosure(funcadd, 256);
  x = 4;  pushClosureArg(p, sizeof(int), &x);
  x = 10;  pushClosureArg(p, sizeof(int), &x);

  p->p(p, 1, 2, 3);

  free(p);

  p = makeClosure(z2func, sizeof(thing1));
  pushClosureArg(p, sizeof(thing1), &xpxp);

  p->p(p, 45);
  free(p);

  p = makeClosure(zFunc, sizeof(int));
  x = 5; pushClosureArg(p, sizeof(int), &x);

  p->p(p, 12, 7);

  return 0;
}

///_______________________________________________________________________________________________
/// Expected Output
///_____________________________________
/*

funcadd() = 20
z2func() i = 45, 1234567890123
zFunc() i = 5, j = 12, k = 7

*/

