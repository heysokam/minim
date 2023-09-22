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

## MinC vs Nim
In Nim with it's C backend, the Nim language is the owner of the rules for how applications must be written.  
In MinC, **C** is **the owner** of said rules.  

## MinC is Minimalistic by design
The `minc` compiler does not (and never will) support the complete feature-set of Nim:  
```md
# Supported
Strong-types
Modules
# Explicitly avoided by design
No Garbage Collector
No Exceptions
No Meta-programming
No ctypes. Types are translated verbatim. (aka no cint/cchar/cuint,cfloat,etc)
```

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
If you write `cint` or `int32` and you didn't define those symbols, the code won't compile in C because its not nim, its C.  
If you want to use `int32` as a type, you need to define it yourself before using it.  

## Compiler
MinC uses an StoS compiler that generates C code.  
The generated output code is standard, human-readable and editable C code.  
The output code is then compiled with a standard C compiler as usual.  

MinC can be used to create C libraries, because the output is normal C code.  

---

## Other
```md
# Name Styles
ᛟ minc
Min < C > niM
Min> C <niM
```
```md
# Notes
https://stackoverflow.com/questions/1472138/c-default-arguments
https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html
-std=c?? | https://en.wikipedia.org/wiki/C99 | https://en.wikipedia.org/wiki/C17 https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2244.htm
```
