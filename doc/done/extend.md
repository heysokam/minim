```md
# Done: Extend C
- [x] Functions
  - [x] Private (aka static) Function definitions unless explicitly specified otherwise
  - [x] noreturn pragma
    - [x] C23  {.noreturn.}       <- [[noreturn]]
    - [x] C11  {.noreturn_C11.}   <- _Noreturn
    - [x] GNU  {.noreturn_GNU.}   <- __attribute__((noreturn))
  - [x] Immutable arguments data by default  (const unless marked as mutable)
- [x] Variables
  - [x] Explicit empty designator "_"
  - [x] Private (aka static) Variable definitions unless explicitly specified otherwise
- [x] Standalone Pragmas
  - [x] {.warning:"msg".}   (#warning from -std=c23)
  - [x] {.emit: " ... ".}  # Writes the contents of the pragma literally into the output without any checks.
  - [x] (dummy) {.namespace: one.sub.}  and  {.namespace: _.}
- [x] Discard statement
  - [x] Single discard
  - [x] Multi-discard:   discard (one,two)
- [x] East-const rule always
- [x] Function calls: Command syntax
```

