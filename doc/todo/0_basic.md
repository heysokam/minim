```md
# Essentials
- [ ] Type declaration
  - [ ] Enums
  - [ ] Unions
- [ ] Function Definition (proc)
  - [ ] varargs
```

```md
# Important
- [ ] Conditions
  - [ ] do {...} while (cond);
  - [ ] Switch case
    - [ ] discard = donothing
    - [ ] Mandatory explicit fallthrough, otherwise (break;) auto
- [ ] Array compound literals  (int[]){0,1,2}
```

```md
# Complete C
- [ ] For loops:  Complete support
- [ ] Multi-word pointer types  (eg: ptr unsigned long long int)
- [ ] Include
  - [ ] (maybe?) Header include guards support  (todo: research if compilers still get confused about file names or not)
```

---

```md
_Post Refactor_

# Types
- [ ] Structs
  - [ ] Forward declare  https://gist.github.com/CMCDragonkai/aa6bfcff14abea65184a

# Variables
- [ ] `{.volatile.}`
- [ ] `{.readonly.}` without explicit typedef

# Literals and Values
- [ ] Arrays: nested

# Functions
## Arguments
- [ ] `{.restrict.}`
## Properties
- [ ] pure functions `__attribute__ ((pure))`
- [ ] compile time only `{.comptime.}`
```

