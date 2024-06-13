# Unmapped Nim nodes
## nkDo
```nim
arr.map(
  proc(el: int): string =
    echo el
    $el
)
# using sugar (not the module)
arr.map() do (el: int) -> string:
  echo el
  $el
```
