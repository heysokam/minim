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
The compiler will do what you said, not what it thinks you meant.  
MinC does not assume anything about your code, and it does not auto-resolve types/symbols either.  
There is no `auto` keyword, no implicit type resolution, and other similarly implicit behavior.  
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

