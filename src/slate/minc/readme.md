# minc | Minimalistic C Language
`Min> C <niM`
MinC is a minimalistic C language with nim syntax.  
It does not try to be feature-full, its only goal is to write Pure C.  

## Compiler
MinC uses an StoS compiler that generates C code.  
The generated output code is standard, human-readable and editable C code.  
The output code is then compiled with a standard C compiler as usual.  

## NOT nim
Don't be fooled by the nim syntax. MinC is not nim.  
MinC is just C with a different syntax face.  
If a type does not exist in C, the C compiler will error. Because minc is not nim, its C.  
With minc you write a different version of C that uses nim syntax.  

MinC does not use the nimc backend or compiler pipeline.  
This makes the entire nim language go away, and become just C with different grammar/syntax.  

If you think about minc as writing nim and then compiling it to C, you are already in the wrong mindset, because you are thinking of:  
... exceptions, the GC, codegen optimizations, the standard compiler, the type system, support for the nim stdlib, etc etc  
C has none of that, so MinC does not have it either _(unless you write it yourself)_.  

The `minc` compiler does not (and never will) support the complete feature-set of Nim:  
```md
# Supported
Strong-types
Modules
# Explicitly avoided by design
No ctypes. Types are translated verbatim. (aka no cint/cchar/cuint,cfloat,etc)
No Garbage Collector
No Exceptions
No Meta-programming
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

---

## Other
```md
# Name Styles
Min < C > niM
Min> C <niM
```
