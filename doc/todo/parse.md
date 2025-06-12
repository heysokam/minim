# Visibility
- [x] Basic private/public mirroring Nim
- [ ] Refactor to public by default
  - [ ] Invert behavior
  - [ ] Add `{.private.}` pragma

# Identifier
- [x] Standard
- [ ] Case Insensitive
- [ ] List: Valid Characters

# Proc
- [x] new: Minimal support, no args
- [?] new: Basic Args
- [?] new: Basic Pragmas
- [ ] fix: Oneline/decl termination requiring `;`
- [ ] new: Multi-name single-type arguments syntax  `(one, two :T)`
- [ ] new: Minim rules allowing pragmas for every symbol

# Data Binding
- [ ] `con thing`  `const thing`
- [ ] `let thing`
- [ ] `var thing`
- [ ] Declaration without assignment   `var thing :int;`    ->    `int thing;`  |  `var thing :int= undefined;`
- [ ] Assignment without keyword/type  `thing = val`        ->    `thing = val;`

# Meaningful Indentation
- [x] Indentation: Tagging @Tokenizer stage
  - [x] Tag Types
  - [x] Tag All Tokens
- [ ] Scope: Tagging @Parser stage
  - [ ] Tag Types
  - [ ] Tag All Tokens
  - [ ] Increase
  - [ ] Decrease
  - [ ] Preserve through Indentation changes

# Blocks
- [ ] [.emit.ID: .]
  - [ ] ID: Case Insensitive
- [ ] Unnamed Blocks     `block: ...; break;`
- [ ] Named   Blocks     `block name: ...; break name;`
- [ ] Section (no scope) `section ?name: ...`

# Operators
- [ ] Affix Parsing: Pratt Parsing
  - [ ] Prefix
  - [ ] Infix
  - [ ] Postfix
- [ ]  TS.`??`  ->  Zig.`orelse`
- [ ] Nim.`^1`  ->  Zig.`list.len - 1`

# Pragmas
- [ ] {.context:ID.}
  - [ ] ID: Case Insensitive
- [ ] @ID
  - [ ] ID: Case Insensitive
- [ ] Namespace          `{.namespace: ?name.}`
  - [ ] Zig: Codegen into structs
  - [ ] C  : Dummy Tags
  - [ ] C  : Namespace Stack -> convert contained symbols to `name_one_thing()`
  - [ ] C  : Semantics Table -> convert `name.one.thing()` to `name_one_thing()`


[@include ./context.md]

