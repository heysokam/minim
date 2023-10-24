// From : https://gist.github.com/m1lkweed/464a9271a37fc3ea5a6d8e346d826525
#include <stdio.h>

#ifndef __cplusplus
#define __builtin_bit_cast(type, arg) ( \
  (union{                               \
    typeof(({arg;})) in;                \
    typeof(type) out;                   \
  }){({arg;})}.out                      \
)
#endif

int main(){
  register double dbl = 1.0;
  long a = __builtin_bit_cast(long, dbl++);
  printf("%lx\n", a);
  printf("%g\n", dbl); //arg is evaluated once
  // Same as:  var two :long= cast[long](2.0'f)
  long two = ( union{double in; int out;} ){2.0}.out; // dbl++ == 2.0
}
