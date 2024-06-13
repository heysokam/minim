```md
# Complete C
## Modules and Namespacing
- [ ] Include
  - [ ] (maybe?) Header include guards support  (todo: research if compilers still get confused about file names or not)
## Conditions
- [ ] do {...} while (cond);   (nkDo ?)
- [ ] Switch case
  - [ ] discard = donothing
## Loops
- [ ] For loops:  Complete support
## Types
- [ ] Structs
  - [ ] Forward declare  https://gist.github.com/CMCDragonkai/aa6bfcff14abea65184a
  - [ ] Bitfields https://en.cppreference.com/w/c/language/bit_field
## Variables
- [ ] `{.volatile.}`
## Literals and Values
- [ ] Arrays: nested
- [ ] Array compound literals  array[int](0,1,2)  ->  (int[]){0,1,2}
## Functions
### Arguments
- [ ] `{.restrict.}`
- [ ] ...args version of varargs (@note parsing ... alone breaks the syntax. needs to be ...args or some alternative)
### Properties
- [ ] compile time only `{.comptime.}`
```

```md
# Bugfixes
- [ ] `raw  *:array[32, unsigned char]`   -X->   `unsigned char raw[32];`   -bug->   `char raw;`
```
