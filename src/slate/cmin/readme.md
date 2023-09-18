# minc | Minimalistic C Language
Wordplay of `cmin<->nimc`  
In essence, minc is a minimalistic C language written with nim syntax.
It does not try to be feature-full, its only goal is to write Pure C.  

It does not (and never will) support the feature-set of Nim:  
```md
# Minimalistic C
Strong-typed
Modules
# Explicitly avoided by design
No ctypes. Types are translated verbatim. (aka no cint/cchar/cuint,cfloat,etc)
No Garbage Collector
No Exceptions
No Meta-programming
```

## Compiler
minc uses a Nim-to-C compiler that generates C code.  
The generated code is human-readable, platform-agnostic and editable C code.  
This code is then compiled with a standard C compiler as usual.  

