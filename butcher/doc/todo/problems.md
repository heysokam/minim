```md
# Problems
- [x] Better readonly pragma: Const types how?
  - [x] ? type MyType = ptr char {.immutable.}
  - [_] ? type MyType = ptr {.immutable.} char
  - [_] ? type MyType {.readonly.} = ptr char
  - [_] ? type MyType = ptr Const[char]     ?howto: Const[T] ?
  - [_] ? type MyType = lent ptr char    <- char const * const  (aka incorrect)
```
