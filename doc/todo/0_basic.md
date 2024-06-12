```md
# Essentials
- [ ] Type declaration
  - [ ] Unions
- [ ] Function Definition (proc)
  - [ ] varargs
    - [ ] ... operator
    - [ ] varargs keyword
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
  - [ ] Bitfields
## Variables
- [ ] `{.volatile.}`
## Literals and Values
- [ ] Arrays: nested
## Functions
### Arguments
- [ ] `{.restrict.}`
### Properties
- [ ] pure functions
  - [ ] `__attribute__ ((const))` and `__attribute__ ((pure))`
  - [ ] {.noconst.} pragma : Mark function as ((pure)) instead of ((const))
- [ ] compile time only `{.comptime.}`
```

