# No Sideffects Functions
References:
- [GCC's Manual](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#Common-Function-Attributes)
- [const vs pure attributes](https://stackoverflow.com/questions/29117836/attribute-const-vs-attribute-pure-in-gnu-c)

## TL;DR: In MinC ...
1. `func name (arg :T) :T` definitions are always marked with the `const` attribute
2. `func name (arg :T) :T {.pure.}` definitions are always marked with the `pure` attribute
3. Marking a `proc` with `{.pure.}` won't do anything

## `func name (arg :T) :T`
Calls to functions whose return value is not affected by changes to the observable state of the program  
and that have no observable effects on such state other than to return a value  
may lend themselves to optimizations such as common subexpression elimination.  
Declaring such functions with the const attribute allows the Compiler to avoid emitting some calls  
in repeated invocations of the function with the same argument values.

For example,
```nim
func square (arg :int) :int
```
```c
__attribute__ ((const)) int square (int arg);
```
tells the Compiler that subsequent calls to function square with the same argument value  
can be replaced by the result of the first call regardless of the statements in between.

The const attribute prohibits a function from reading objects that affect its return value between successive invocations.  
However, functions declared with the attribute can safely read objects that do not change their return value,   
such as non-volatile constants.

The const attribute imposes greater restrictions on a function’s definition than the similar pure attribute.  
Declaring the same function with both the const and the pure attribute is diagnosed.  
Because a const function cannot have any observable side effects  
it does not make sense for it to return void. Declaring such a function is diagnosed.

Note that a function that has pointer arguments and examines the data pointed to  
must not be declared const if the pointed-to data might change between successive invocations of the function.  
In general, since a function cannot distinguish data that might change from data that cannot,  
const functions should never take pointer or, in C++, reference arguments.  
Likewise, a function that calls a non-const function usually must not be const itself.

## `func name (arg :T) :T {.pure.}`
Calls to functions that have no observable effects on the state of the program other than to return a value  
may lend themselves to optimizations such as common subexpression elimination.   
Declaring such functions with the pure attribute allows the Compiler to avoid emitting some calls  
in repeated invocations of the function with the same argument values.

The pure attribute prohibits a function from modifying the state of the program  
that is observable by means other than inspecting the function’s return value.  
However, functions declared with the pure attribute can safely read any non-volatile objects,  
and modify the value of objects in a way that does not affect their return value or the observable state of the program.

For example,
```nim
func hash (arg :ptr char) :int {.pure.}
```
```c
__attribute__ ((pure)) int hash (char *);
```
tells the Compiler that subsequent calls to the function hash with the same string  
can be replaced by the result of the first call provided the state of the program observable by hash, 
including the contents of the array itself, does not change in between.  
Even though hash takes a non-const pointer argument it must not modify the array it points to,  
or any other object whose value the rest of the program may depend on.  
However, the caller may safely change the contents of the array between successive calls to the function  
(doing so disables the optimization).  
The restriction also applies to member objects referenced by the this pointer in C++ non-static member functions.

Some common examples of pure functions are strlen or memcmp.  
Interesting non-pure functions are functions with infinite loops  
or those depending on volatile memory or other system resource, that may change between consecutive calls  
(such as the standard C feof function in a multithreading environment).

The pure attribute imposes similar but looser restrictions on a function’s definition than the const attribute:  
pure allows the function to read any non-volatile memory,  
even if it changes in between successive invocations of the function.  
Declaring the same function with both the pure and the const attribute is diagnosed.  
Because a pure function cannot have any observable side effects  
it does not make sense for such a function to return void.  
Declaring such a function is diagnosed.

