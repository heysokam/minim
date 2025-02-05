## Q
Is there any way to mark a const definition in such a way that it works only either at runtime or comptime,
without the compiler complaining about redundant comptime markers?

## A
You could try doing things that arent possible at runtime or comptime
### Runtime
Take its address using `@intFromPtr`/`@ptrFromInt`:
`@intFromPtr(&x)`
### Comptime
Discard it into a `_` variable inside a comptime block
`{ _ = comptime foo }`
