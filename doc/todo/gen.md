- [ ] `mut T` for zig primitives should codegen a pointer type `*T`
- [ ] Pointer, sentinel and C ptr
    ```ts
    arg06 : array[*, i32];
    arg07 : array[*c, i32];
    arg08 : array[1:0, i32];
    arg09 : array[:0, i32];
    arg10 : array[*:0, i32];
    arg11 : array[*c:0, i32];
    ```
    Many-item pointer: `[*]T`
    C-like Many-item pointer: `[*c]T` == `?[*]T`
    Minim:
      `ptr`, `ptr[]`, `ptr[c]`  (todo: Alternatives)
      `slice[T]`, `slice[T,ch]`, `array[N,T]`, `array[N,T,ch]`
