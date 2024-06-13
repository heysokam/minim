```md
# Essentials
- [ ] Function Definition (proc)
- [ ] Type declaration
  - [ ] Unions
```

```md
# Important
- [ ] Conditions
  - [ ] do {...} while (cond);   (nkDo ?)
  - [ ] Switch case
    - [ ] discard = donothing
- [ ] Array compound literals  array[int](0,1,2)  ->  (int[]){0,1,2}
```

```md
# Complete C
- [ ] For loops:  Complete support
- [ ] Include
  - [ ] (maybe?) Header include guards support  (todo: research if compilers still get confused about file names or not)
## Types
- [ ] Structs
  - [ ] Forward declare  https://gist.github.com/CMCDragonkai/aa6bfcff14abea65184a
  - [ ] Bitfields https://en.cppreference.com/w/c/language/bit_field
## Variables
- [ ] `{.volatile.}`
## Literals and Values
- [ ] Arrays: nested
## Functions
### Arguments
- [ ] `{.restrict.}`
- [ ] ...args version of varargs (@note parsing ... alone breaks the syntax. needs to be ...args or some alternative)
### Properties
- [ ] pure functions
  - [ ] `__attribute__ ((const))` and `__attribute__ ((pure))`
  - [ ] {.noconst.} pragma : Mark function as ((pure)) instead of ((const))
- [ ] compile time only `{.comptime.}`
```

