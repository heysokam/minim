# ᛟ minc | Minimalistic C Language
`Min> C <niM`  
MinC is a minimalistic C language with nim syntax.  
It does not try to be feature-full, its only goal is to write Pure C.  

### MinC is C
MinC is a different version of C that uses nim syntax.  
If a type does not exist in C, the C compiler will error.  
It can use C libraries without wrappers, because the compiler outputs (human-readable) C.  

### MinC extends C
```md
Strong-types
Modules
Namespaces  (dot syntax)
... : See the todo+done sections
```

### MinC is Minimalistic
MinC does as little as possible to ensure compliance to its rules, and gets out of the way.  

MinC extends C, but it does so in a minimal way.  
Its extensions are things that you would manually write in modern C code,  
but MinC allows their expression with a cleaner, more readable and minimal syntax.  

### MinC is Modern
MinC targets C23 first.  
It also has sane defaults for building for modern 64bits targets in a safe/sanitized way.  
It is also not afraid of breaking backwards compatibility with its default options.  
But... unbounded and complete usage of C features is allowed as an explicit opt-in.  
If you want to build C99 code and target old platforms, you can.  

### MinC is Explicit
In MinC you write imperatively and explicitly.  
MinC does not assume anything about your code, and it does not auto-resolve types/symbols either.  
There is no `auto` keyword, no implicity type resolution, and other similarly implicit behavior.  
Everything is translated literally. And there are no symbol overloads either.  
What you said is what you meant.  

### MinC can seamlessly be (and stay) out of the way
**Case1**: You have an existing C project that you want to use, but you don't like C syntax.  
```md
1. Do whatever you need to do to extend and build that project with extra C files.  
2. Order the MinC compiler to output your generated C code into paths that the C buildsystem can recognize.  
3. Build your C project like before.  
```
No other changes needed.  

**Case2**: You prefer MinC syntax, but you don't want people to know that you use it.  
```md
1. Create a private repository that contains your .cm files.  
2. Create a public repository.  
3. Order the MinC compiler to output your generated C code into the public repo.  
4. Keep your private repo private.  
```
People will only have to deal with (and/or use as a library)   
your (human-readable, formatted, and standard) C code instead.  

**Case3**: Lets say you regret choosing MinC and want to remove it from your project:  
```md
1. Build your .cm files into .c files once.  
2. Erase all your .cm files, and any other trace of minc, completely from your project.  
3. Keep using your generated (human-readable, formatted, and standard) C code instead.  
```
Remember, MinC is C.  

### MinC is NOT nim
MinC is not nim, its C.  
If you think about MinC as writing nim and then compiling it to C, you are already in the wrong mindset, because you are thinking of:  
```md
- nim types
- nim's stdlib
- exceptions
- garbage collection
- codegen optimizations
- nim libraries
- dynamically allocated types (aka: string, seq[T], openArray[T], etc)
- symbol overloads
- meta-programming
- the nim compiler
- etc etc  
```
C has none of that, so MinC does not have it either _(unless you write it yourself)_.  

MinC does **not** use the Nim's c backend or semantic passes of its compiler pipeline.  
This makes the entire nim language go away, and it becomes just C with different grammar/syntax.  

In Nim with it's C backend, the Nim language is the owner of how applications must be written.  
In MinC, **C** is **the owner** of said rules.  
If something is illegal in C, it will be illegal in MinC, even if its legal in Nim.  

**No Nim types**:
Types are translated verbatim.  
```nim
var thing :int= 1
```
```C
// Result
int thing = 1;
```
*Important*: Note how we haven't written `cint`, we wrote `int`.  
`cint` is not a valid C type. It's a Nim type.  
If you write `cint`, `cfloat`, `int32`, etc, and you didn't define those symbols, the code won't compile in C.  
If you want to use nim's types, you need to create the types yourself first before using them.  

### Compiler
MinC uses an StoS compiler that generates C code.  
The generated output code is standard, human-readable and editable C code.  
The output code is then compiled with a regular C compiler as usual.  

MinC can be used to create C libraries, because the output is normal C code.  

Cross-compilation is a first class citizen.  
Thanks to the internal usage of the ZigCC compiler interface,  
building for any target is as easy as passing `-target=` to the compiler command.  

---
```md
# Done:
- [x] Function Definition (proc)
- [x] Return
- [x] Main function
- [x] Static/Extern
  - [x] Variables
  - [x] Functions
- [x] Header include
- [x] Function calls: Call(syntax)
- [x] Doc Comments
- [x] Type declaration
  - [x] Type aliasing    typedef char* str;
  - [x] Mutable pointer to immutable data    {.readonly.} pragma
- [x] Variable definition:
  - [x] Immutable : Let/Const
  - [x] Mutable   : Var
- [ ] Conditions
  - [x] Sketch   : Single condition only
  - [x] While
  - [x] if/elif/else blocks
- [x] Variable asignment
- [x] Tentative variable definition
- [x] Multi-line strings
- [x] Character literals
- [x] break
- [x] continue
- [x] Defines
  - [x] {.define: symbol.}
  - [x] when defined(symbol)
- [x] {.error:"msg".}
- [x] Multi-word types  (eg: unsigned T)
  - [x] signed
  - [x] unsigned
  - [x] long
  - [x] short
  - [x] double, triple and quadruple worded types
- [x] Operators
  - [x] Prefix   + - & ! * -- ++
  - [x] Infix
    - [x] Arithmetic : + - * / %
    - [x] Bitwise    : & | << >>
    - [x] Asignment  : += -= *= /= %=  |= ^= ~=   <<= >>=
    - [x] Postfix  ++ --  (nim parser has no postfix, other than * for visibility)
- [x] Arrays
  - [x] Sized
  - [x] Unknown size  one :array[_,char]   ->   char one[]
  - [x] Initialization
  - [x] indexed access
  - [x] Designated Initialization
- [x] Structs
  - [x] Declaration
  - [x] Definition
  - [x] Designated Initialization
  - [x] Forward declare  https://gist.github.com/CMCDragonkai/aa6bfcff14abea65184a
  - [x] Field access
    - [x] Return statement
- [x] Character literals: Resolve to 'c' everywhere
# Done: Extend C
- [x] Immutable data by default  (const unless marked as mutable)
  - [x] Function arguments
- [x] Private (aka static) symbols unless explicitly specified otherwise
  - [x] Function definitions
  - [x] Variable definitions
- [x] Discard statement
- [x] Function calls: Command syntax
- [x] noreturn pragma
  - [x] C23  {.noreturn.}       <- [[noreturn]]
  - [x] C11  {.noreturn_C11.}   <- _Noreturn
  - [x] GNU  {.noreturn_GNU.}   <- __attribute__((noreturn))
- [x] East-const rule always
- [x] Booleans without stdbool.h  (-std=c23)
- [x] {.warning:"msg".}   (#warning from -std=c23)
```
```md
# TODO:
- [ ] For loops:  Basic support
- [ ] Operators
  - [ ] Infix
    - [ ] Logical   && || == != < > <= >=
- [ ] Structs
  - [ ] Construction: Function Parameters
  - [ ] Construction: Reassignment
  - [ ] {.stub.} for using the non-typedef version of the struct  (todo: Find better word than stub. innerdef or similar)
- [ ] Conditions
  - [ ] Complete : Arbitrary condition tree support
  - [ ] Switch case
    - [ ] case ... of:
    - [ ] discard = donothing
    - [ ] Mandatory explicit fallthrough, otherwise (break;) auto
    - [ ] else: == default:
  - [ ] Operators:  (and,&&) (or,||) (&,&) (|,|)
  - [ ] do {...} while (cond);
- [ ] 0.0f suffix for floats
- [ ] Explicit casting
- [ ] addr
- [ ] Enums
- [ ] Ternary operator   let one = if condition: 1 else: 2
- [ ] Unions
- [ ] varargs
- [ ] obj->field   pointer access syntax ->
- [ ] C restrict keyword
- [ ] C volatile keyword
- [ ] {.persistent.}  (aka static memory)  https://modelingwithdata.org/arch/00000070.htm
- [ ] Multi-word pointer types  (eg: ptr unsigned long long int)
- [ ] Arrays: nested
```
```md
# TODO: Extend C
- [ ] Typed Pointer notation for function/array function arguments  (Modern C, page 19)
- [ ] Compiler interface within the code:
  - [ ] {.compile: "file.c".}         # Passes the file to zigcc as one of the files to cache
  - [ ] {.compile: "/some/folder/".}  # Passes a glob of all files in the given folder to zigcc
  - [ ] {.compile: ("/some/folder/", "exceptions").}  # Passes a filtered glob of files in the given folder to zigcc
- [ ] {.emit: " ... ".}               # Writes the contents of the pragma literally into the output without any checks.
- [ ] {.passL: "-lm".}                # Sends the given flags to the compiler in the linker section of the command
- [ ] {.passC: "-I/some/folder".}     # Sends the given flags to the compiler in the source compilation section of the command
- [ ] Object extension   (type MyType = object of ... )
- [ ] Variant types
- [ ] Generics
- [ ] Modules
- [ ] Function calls: dot.syntax()
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
```
```md
# Problems
- [ ] Better readonly pragma: Const types how?
  - [ ] ? type MyType = ptr char {.immutable.}
  - [ ] ? type MyType = ptr {.immutable.} char
  - [ ] ? type MyType {.readonly.} = ptr char
  - [ ] ? type MyType = ptr Const[char]     ?howto: Const[T] ?
  - [ ] ? type MyType = lent ptr char    <- char const * const  (aka incorrect)
```
```md
# Internal C compiler todo
- [ ] --verbose-cc
- [ ] Bundle zigcc
- [ ] Provide an interface for zigcc in the minc binary
- [ ] Provide the `-c` option to just output C code and not build it.
- [ ] Docs:
  - [ ] Link to an always-up-to-date list of natively supported cross-compilation targets
  - [ ] Reminder that nim is only required for building the compiler itself. Users don't need it
  - [ ] Reminder that ZigCC is bundled, and doesn't need to be manually installed
  - [ ] Reasons for using ZigCC as the internal compiler
        https://www.youtube.com/watch?v=YXrb-DqsBNU&t=506s
        https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html
        https://ziglang.org/learn/overview/#zig-is-also-a-c-compiler
  - [ ] No need for cmake/makefiles/etc. Compiler support is integrated into the source files.
  - [ ] Info on libc-musl-etc target options from zigcc
  - [ ] Reminder about the ease of Cross-compilation UX (installation of msvc,mingw,osxcross,etc)
- [ ] --unbounded (explicit opt-in for unbounded-C support)
- [ ] -ffunction-sections -fdata-sections --gc-sections --print-gc-sections
- [ ] -fvisibility=hidden   <- like id-Tech3
- [ ] other flags : https://developers.redhat.com/blog/2018/03/21/compiler-and-linker-flags-gcc
- [ ] Optimization options
  - [ ] -O4 ??   -O2 -flto instead?
  - [ ] ?mold on linux ?
- [ ] Build modes:
  - [ ] Debug    # All debug flags active
  - [ ] Release  # Optimization flags active
  - [ ] None     # No flags. Blank slate for --passC:" ... "
```
```md
# Extend Parser (maybe)
- [ ] Preserve non-doc comments
- [ ] Preserve empty lines
- [ ] Multi-value discard
- [ ] Pragmas for types (not just symbols)
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
```nim
proc recurseSolve (code :PNode; idents :var seq[PNode]) :void=
  if code.kind == nkDotExpr:
    result.add code[^1]
    recurseSolve(code[0], idents)
  else:
    ...
```
---

### Other
```md
# Name Styles
ᛟ minc
Min < C > niM
Min> C <niM
```
```md
# MinC properties lost on compilation:
- let vs const
- call vs command
```
```md
# Notes
-Wno-error=warning-name  <- how to pass build-errors when migrating
https://stackoverflow.com/questions/1472138/c-default-arguments
https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html
-std=c?? | https://en.wikipedia.org/wiki/C99 | https://en.wikipedia.org/wiki/C17 https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2244.htm
clang vers status -> https://clang.llvm.org/c_status.html
```
