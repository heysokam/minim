``` md
# Name Styles
ᛟ minc
Min < C > niM
Min> C <niM
```

``` md
# MinC properties lost on compilation:
- let vs const
- call vs command
```

``` md
# Notes
-Wno-error=warning-name  <- how to pass build-errors when migrating
https://stackoverflow.com/questions/1472138/c-default-arguments
https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html
-std=c?? | https://en.wikipedia.org/wiki/C99 | https://en.wikipedia.org/wiki/C17 https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2244.htm
clang vers status -> https://clang.llvm.org/c_status.html
```

------------------------------------------------------------------------

# Other
``` c
// Standard Initializers
struct A { int a; };
struct B { A a; int b };
B b = { 1, 1 };
// Should be:
B b;
memset(&b, 0xff, sizeof(b)); // if your locals are zeroed by default including padding
b.a.a = 1;
b.b = 1;

// Achieved by:  Struct Designated Initializer
B b = { .a.a= 1, .b=1 };
```

``` c
// Array Designated Initializer
u32 arr[] = {
  [2] = 19,
  }
// [0] = 0,   <- Implied because its missing
// [1] = 0,   <- Implied because its missing
```

``` c
// Non-GNU-exclusive {.noreturn.} pragma
// Crucial:  This is how you solve it for -compile-time- decided,
//           not codegen decided!!!
// Why bother with preprocessor Bs? MinC StoS -is- the preprocessor!
#if C23
#define MINC_NORETURN [[noreturn]]
#elif C11
#define MINC_NORETURN _Noreturn
#elif __GNUC__
#define MINC_NORETURN __attribute__((noreturn))
#endif
```
