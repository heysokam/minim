.. code:: md

   # Done: Extend C
   - [x] Immutable data by default  (const unless marked as mutable)
     - [x] Function arguments
   - [x] Private (aka static) symbols unless explicitly specified otherwise
     - [x] Function definitions
     - [x] Variable definitions
   - [x] Discard statement
   - [x] Function calls: Command syntax
   - [x] noreturn pragma
     - [x] C23  {.noreturn.}       <- [[noreturn]]
     - [x] C11  {.noreturn_C11.}   <- _Noreturn
     - [x] GNU  {.noreturn_GNU.}   <- __attribute__((noreturn))
   - [x] East-const rule always
   - [x] Booleans without stdbool.h  (-std=c23)
   - [x] {.warning:"msg".}   (#warning from -std=c23)
   - [x] Alternative type casting syntax
     - [x] val as Type
     - [x] val @ Type
   - [x] {.namespace: one.sub.}  and  {.namespace: _.}
   - [x] {.emit: " ... ".}  # Writes the contents of the pragma literally into the output without any checks.
   - [x] include some/path   for .cm files (with amalgamation)
   - [x] Multi-discard:   discard (one,two)
   - [x] Explicit empty designator "_"
