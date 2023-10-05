```c
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

```c
// Array Designated Initializer
u32 arr[] = {
  [2] = 19,
  }
// [0] = 0,   <- Implied because its missing
// [1] = 0,   <- Implied because its missing
```

```c
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
