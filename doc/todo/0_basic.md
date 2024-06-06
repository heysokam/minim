```md
# Refactor Redo
- [ ] Multi-word types  (eg: unsigned T)
  - [ ] signed
  - [ ] unsigned
  - [ ] long
  - [ ] short
  - [ ] double, triple and quadruple worded types
- [ ] Conditions
  - [ ] when defined(symbol)
  - [ ] Operators:  (and,&&) (or,||) (&,&) (|,|)
- [ ] Operators
  - [ ] Infix
    - [ ] Arithmetic : + - * / %
    - [ ] Bitwise    : & | << >>
    - [ ] Asignment  : += -= *= /= %=  |= ^= ~=   <<= >>=
    - [ ] Logical    : && || == != < > <= >=
    - [ ] Postfix    : ++ --  (nim parser has no postfix, other than * for visibility)
- [ ] Arrays
  - [ ] indexed access
- [ ] Type declaration
  - [ ] Structs
    - [ ] Declaration
    - [ ] Definition
    - [ ] Designated Initialization
    - [ ] Forward declare  https://gist.github.com/CMCDragonkai/aa6bfcff14abea65184a
    - [ ] Field access
      - [ ] Value access    thing.sub
      - [ ] Pointer access  thing->sub
    - [ ] Construction: Function Parameters
    - [ ] Construction: Reassignment
    - [ ] {.stub.} for using the non-typedef version of the struct
    - [ ] Compound Literals
- [ ] Explicit casting
  - [ ] cast[T](...) syntax
  - [ ] Alternative syntax
    - [ ] val as Type
    - [ ] val @ Type
- [ ] Pointer dereference   one[] = val   ->   *one = val
- [ ] obj->field   pointer access syntax ->
- [ ] For loops:  Basic support
- [ ] Switch case
  - [ ] case ... of:
  - [ ] else: == default:
```

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
- [ ] Conditions : Arbitrary condition tree support
- [ ] Multi-word pointer types  (eg: ptr unsigned long long int)
- [ ] (maybe?) Header include guards support  (todo: research if compilers still get confused about file names or not)
```

---

```md
_Post Refactor_

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

