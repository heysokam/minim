.. code:: md

   # Problems
   - [ ] Better readonly pragma: Const types how?
     - [ ] ? type MyType = ptr char {.immutable.}
     - [ ] ? type MyType = ptr {.immutable.} char
     - [ ] ? type MyType {.readonly.} = ptr char
     - [ ] ? type MyType = ptr Const[char]     ?howto: Const[T] ?
     - [ ] ? type MyType = lent ptr char    <- char const * const  (aka incorrect)
