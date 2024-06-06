```md
# Refactor Redo
- [ ] Booleans without stdbool.h  (-std=c23)
```

```md
# TODO: Extend C
- [ ] Typed Pointer notation for function/array function arguments  (Modern C, page 19)
- [ ] Compiler interface within the code:
  - [ ] {.compile: "file.c".}         # Passes the file to zigcc as one of the files to cache
  - [ ] {.compile: "/some/folder/".}  # Passes a glob of all files in the given folder to zigcc
  - [ ] {.compile: ("/some/folder/", "exceptions").}  # Passes a filtered glob of files in the given folder to zigcc
- [ ] {.passL: "-lm".}                # Sends the given flags to the compiler in the linker section of the command
- [ ] {.passC: "-I/some/folder".}     # Sends the given flags to the compiler in the source compilation section of the command
- [ ] Object extension   (type MyType = object of ... )
- [ ] Variant types
- [ ] Generics
- [ ] {.namespace: one.sub.}  and  {.namespace: _.}   (full support)
- [ ] Modules
- [ ] Function calls: dot.syntax()   https://en.wikipedia.org/wiki/Uniform_Function_Call_Syntax
- [ ] Enum-arrays
- [ ] range[A..B] : Range limited numbers
- [ ] For loops: Range based
- [ ] Operators
  - [ ] Custom infix Operators
  - [ ] int div vs /
- [ ] CERT C compliance (clang-tidy automated pass  +  -Weverything -Werror)
- [ ] ?maybe? Member functions? (very undecided, feels like too much handholding)
- [ ] C function aliases for modules
      https://developers.redhat.com/blog/2020/06/03/the-joys-and-perils-of-aliasing-in-c-and-c-part-2
      proc funcName {.alias: "glfwFuncName".}
      alias funcName = glfwFuncName
- [ ] Zig-like Error!Result
- [ ] {.rename: "name".}  <-- like `exportc`, but signaling what it actually does in MinC
- [ ] {.symbol: "name".}  <-- for literal symbols, ignoring imports/modules/etc
- [ ] Unbounded C
  - [ ] Make int/uint/long/etc illegal. Allow its usage through --unbounded
  - [ ] --noDiscard
  - [ ] Forbid asignment in conditionals
  - [ ] Sideffects
    - [ ] __attribute__ ((pure))
    - [ ] write-only memory idea from herose (like GPU write-only mem)
  - [ ] Forbid tentative definitions in const (aka /*comptime*/ constexpr) but allow in var/let
  - [ ] Bounds Safety
        https://discourse.llvm.org/t/rfc-c-buffer-hardening/65734/90
        https://llvm.swoogo.com/2023eurollvm/session/1414468/keynote-%E2%80%9C-fbounds-safety%E2%80%9D-enforcing-bounds-safety-for-production-c-code
  - [ ] Struct: Packing/Alignment codegen
        https://metricpanda.com/rival-fortress-update-35-avoiding-automatic-structure-padding-in-c/
        http://www.catb.org/esr/structure-packing/
- [ ] {.unreachable.} unreachable macro (clang.17) https://releases.llvm.org/17.0.1/tools/clang/docs/ReleaseNotes.html#c2x-feature-support
- [ ] {.emitfrom: (file.c, firstline, lastline).}
- [ ] static: blocks -> Convert to nimscript and run them literally
- [ ] iterators
- [ ] distinct types -> wrap the type inside a named struct
      type Handle = distinc int   ->   typedef struct int_d { int data; } Handle;
- [ ] if/elif/else variable asignment autoexpand
- [ ] Default Arguments
- [ ] Named Arguments
- [ ] Nim casting as builtin bit_cast for bit reinterpretation. Leave @ and as for C-like casting
      https://gist.github.com/m1lkweed/464a9271a37fc3ea5a6d8e346d826525
      var one :int= cast[int](0.5'f)   ->   int one = ( union{float in; int out;} ){0.5f}.out;
- [ ] Multi-Types
  - [ ] Type Unions        (nim/ts)  ->  type Thing = One or  Two    # Accepts either One or Two, but not both
  - [ ] Type Intersections (ts)      ->  type Thing = One and Two    # Inherits all properties of One and Two (including methods)
        (WRN: Be careful with type intersections. They can become type-gymnastics combined with Generics, and we really want generics first)
- [ ] Literal types  (Typescript)   type Thing = 50 | 100;   # Accepts only the literal values given and nothing else. (could map to C enums? something else?)
- [ ] Explicitly Nullable types. Forbid implicit nulls unless specified otherwise
      (maybe through Option? :think:  also remember (ts)  thing?.one()  syntax)
```
