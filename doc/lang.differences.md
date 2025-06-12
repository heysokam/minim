## Public/Private symbols
### C
Everything is public by default _(struct fields cant be private)_.
Mark with `static` to make them private.
### Zig
Everything is private by default _(struct fields cant be private)_.
Mark with `pub` to make it public
### Nim
Everything is private by default
Mark with `*` to make it public
### Minim
Everything is public by default
`*` is ignored
Use `{.private.}` to mark as private (does nothing on object fields)


## Mutability
### C, Zig
Everything is mutable by default  _(eg: proc arguments)_
Mark with `const` to make it immutable
### Nim
Everything is immutable by default  _(eg: proc arguments)_
Mark with `var` to make it mutable.
### Minim
Everything is immutable by default  _(eg: proc arguments)_
Mark with `mut` to make it mutable.

