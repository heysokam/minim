# ᛟ minc | Minimalistic C Language
`Min> C <niM`
MinC is a minimalistic C language with nim syntax.  
It does not try to be feature-full, its only goal is to write Pure C.  

## MinC is C
MinC is a different version of C that uses nim syntax.  
If a type does not exist in C, the C compiler will error. Because MinC is not nim, its C.  
MinC can use C libraries without wrappers, because the compiler outputs human-readable C.

## MinC is NOT nim
MinC does **not** use the Nim's c backend or compiler pipeline.  
This makes the entire nim language go away, and become just C with different grammar/syntax.  

If you think about MinC as writing nim and then compiling it to C, you are already in the wrong mindset, because you are thinking of:  
... the nim's stdlib, exceptions, garbage collection, codegen optimizations, the standard compiler, nim libraries, etc etc  
C has none of that, so MinC does not have it either _(unless you write it yourself)_.  

## MinC is Minimalistic by design
```md
# MinC extends C
Strong-types
Modules
... : See the todo+done sections
```
The `minc` compiler does not (and never will) support the complete feature-set of Nim:  
```md
# MinC will never be Nim
No Garbage Collector
No Exceptions
No Meta-programming
No ctypes. Types are translated verbatim. (aka no cint/cchar/cuint,cfloat,etc)
```
## MinC vs Nim
In Nim with it's C backend, the Nim language is the owner of the rules for how applications must be written.  
In MinC, **C** is **the owner** of said rules.  

### No Nim types
Types are translated verbatim.  
```nim
var thing :int= 1
```
```C
// Result
int thing = 1;
```
**Important**: Note how we haven't written `cint`, we wrote `int`.  

### No Nim ctypes
`cint` is not a valid C type. It's a Nim type.  
If you write `cint` or `int32` and you didn't define those symbols, the code won't compile in C.  
If you want to use `int32` as a type, you need to define it yourself before using it.  

## Compiler
MinC uses an StoS compiler that generates C code.  
The generated output code is standard, human-readable and editable C code.  
The output code is then compiled with a standard C compiler as usual.  

MinC can be used to create C libraries, because the output is normal C code.  

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
# Done: Extend C
- [x] Immutable data by default  (const unless marked as mutable)
  - [x] Function arguments
- [x] Private (aka static) symbols unless explicitly specified otherwise
  - [x] Function definitions
  - [x] Variable definitions
- [x] Discard statement
- [x] Function calls: Command syntax
- [x] noreturn pragma
```
```md
# TODO:
- [ ] East-const rule always
- [ ] Variable asignment
- [ ] Multi-line strings
- [ ] Character literals
- [ ] Arrays
  - [ ] Sized
  - [ ] Unknown size  one :array[_,char]   ->   char one[]
  - [ ] Initialization
- [ ] Structs
  - [ ] Declaration
  - [ ] Definition
  - [ ] Field access
- [ ] For loops:  Basic support
- [ ] Conditions
  - [ ] Complete : Arbitrary condition tree support
  - [ ] Switch case
    - [ ] case ... of:
    - [ ] discard = donothing
    - [ ] Mandatory explicit fallthrough, otherwise (break;) auto
    - [ ] else: == default:
  - [ ] Operators:  (and,&&) (or,||) (&,&) (|,|)
  - [ ] do {...} while (cond);
- [ ] break
- [ ] continue
- [ ] Multi-word types  (eg: unsigned T)
- [ ] Operators
  - [ ] Prefix   + - & ! *
  - [ ] Infix
    - [ ] Arithmetic : + - * / %
    - [ ] Bitwise    : & | << >>
    - [ ] Logical    : && || == != < > <= >=
    - [ ] Asignment  : += -= *= /=   &= ^= ~= &=   <<= >>=
  - [ ] Postfix  ++ --
- [ ] Explicit casting
- [ ] addr
- [ ] {.persistent.}  (aka static memory)  https://modelingwithdata.org/arch/00000070.htm
- [ ] Ternary operator   let one = if condition: 1 else: 2
- [ ] Enums
- [ ] obj->field   pointer access syntax ->
- [ ] C restrict keyword
- [ ] Unions
# TODO: Extend
- [ ] {.emit: " ... ".}
- [ ] Object extension   (type MyType = object of ... )
- [ ] Variant types
- [ ] Generics
- [ ] Modules
- [ ] Function calls: dot.syntax()
- [ ] Enum-arrays
- [ ] range[A..B] : Range limited numbers
- [ ] For loops: Range based
- [ ] int div vs /
- [ ] CERT C compliance (clang-tidy automated pass  +  -Weverything -Werror)
- [ ] ?maybe? Member functions? (very undecided, feels like too much handholding)
- [ ] C function aliases for modules
      https://developers.redhat.com/blog/2020/06/03/the-joys-and-perils-of-aliasing-in-c-and-c-part-2
      proc funcName {.alias: "glfwFuncName".}
      alias funcName = glfwFuncName
- [ ] Zig-like Error!Result
# Problems
- [ ] Preserve non-doc comments
- [ ] Preserve empty lines
- [ ] Allow pragmas for types (not just symbols)
- [ ] Better readonly pragma: Const types how?
  - [ ] ? type MyType = ptr char {.immutable.}
  - [ ] ? type MyType = ptr {.immutable.} char
  - [ ] ? type MyType {.readonly.} = ptr char
  - [ ] ? type MyType = ptr Const[char]     ?howto: Const[T] ?
  - [ ] ? type MyType = lent ptr char
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
---

## Other
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
https://stackoverflow.com/questions/1472138/c-default-arguments
https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html
-std=c?? | https://en.wikipedia.org/wiki/C99 | https://en.wikipedia.org/wiki/C17 https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2244.htm
```
