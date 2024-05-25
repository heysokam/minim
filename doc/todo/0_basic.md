```md
# Refactor Redo
- [ ] Standalone Pragmas
  - [ ] {.define: symbol.}   (note: remember when defined(...) )
- [ ] Function calls: Call(syntax)
- [ ] Doc Comments
- [ ] Type declaration
  - [ ] Type aliasing    typedef char* str;
  - [ ] Mutable pointer to immutable data    {.readonly.} pragma
- [ ] Multi-word types  (eg: unsigned T)
  - [ ] signed
  - [ ] unsigned
  - [ ] long
  - [ ] short
  - [ ] double, triple and quadruple worded types
- [ ] Conditions
  - [ ] when defined(symbol)
  - [ ] Sketch   : Single condition only
  - [ ] While
  - [ ] if/elif/else blocks
  - [ ] Operators:  (and,&&) (or,||) (&,&) (|,|)
  - [ ] Multi-condition support (recursive)
- [ ] break
- [ ] continue
- [ ] Operators
  - [ ] Prefix   + - & ! * -- ++
  - [ ] Infix
    - [ ] Arithmetic : + - * / %
    - [ ] Bitwise    : & | << >>
    - [ ] Asignment  : += -= *= /= %=  |= ^= ~=   <<= >>=
    - [ ] Logical    : && || == != < > <= >=
    - [ ] Postfix    : ++ --  (nim parser has no postfix, other than * for visibility)
- [ ] Arrays
  - [ ] indexed access
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
- [ ] addr
- [ ] Explicit casting
- [ ] Pointer dereference   one[] = val   ->   *one = val
- [ ] obj->field   pointer access syntax ->
- [ ] For loops:  Basic support
- [ ] Ternary operator   let one = if condition: 1 else: 2
- [ ] Switch case
  - [ ] case ... of:
  - [ ] else: == default:
```

```md
# Essentials
- [ ] Enums
- [ ] Unions
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
- [ ] {.pragma:once.} and header include guards support
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

