# Ident
- [ ] Standard
- [ ] Case Insensitive
- [ ] List: Valid Characters

# Pragmas
- [ ] {.context:ID.}
  - [ ] ID: Case Insensitive
- [ ] @ID
  - [ ] ID: Case Insensitive

# Emit Blocks
- [ ] [.emit.ID: .]
  - [ ] ID: Case Insensitive

# Operators
- [ ]  TS.`??`  ->  Zig.`orelse`
- [ ] Nim.`^1`  ->  Zig.`list.len - 1`

# Proc
- [ ] fix: Oneline/decl termination requiring `;`
- [ ] new: Multi-name single-type arguments syntax  `(one, two :T)`

# Data Binding
- [ ] `con thing`  `const thing`
- [ ] `let thing`
- [ ] `var thing`
- [ ] Declaration without assignment   `var thing :int;`    ->    `int thing;`  |  `var thing :int= undefined;`
- [ ] Assignment without keyword/type  `thing = val`        ->    `thing = val;`

[@include ./context.md]
