```md
# Notes
? ? ? versions mean that their number has not been decided.

This list is a timeline. Time forward means moving downwards along the list.
Which means that Tasks are listed in reverse order, instead of below their corresponding title.
 -> To arrive at 0.9.0, all previously listed tasks must be completed.
  : Tasks listed under its label are meant for the next step (1.0.0) not for 0.9.0

Comments/Description right under a label are relevant only to the label right above  (not the content after)
  : (the list/content belongs to the next roadmap label).
```

```md
# 0.1.0 First Publishable
The language works, and can create complete applications.
Effort on supporting the entire feature-set of C continues until the last version before v1.0.0
```
```md
# 0.2.0 Arbitrary Raise to 0.2.0 to reflect the changes from one of the BIG commits
# 0.3.0 Binary Compilation Support
# 0.4.0 CaseOf Support
# 0.5.0 `proc` Typedefs and `{.persist.}` pragma
# 0.6.0 Runic sketch
# 0.7.0 Deep Rewrite/Refactor into `slate/fieldAccess`
# 0.7.5 `{.fallthrough.}` pragma
# 0.7.6 Explicit `{.fallthrough.}` for `case` blocks
# 0.7.8 `{.readonly.}` ptr T variables
# 0.8.0 Full UnitTests coverage
# 0.9.0 Enums   (including `{.unsafe.}` and `{.pure.}`)
# 0.10.0 Varargs
# 0.11.0 Unions
# 0.12.0 func
# 0.13.0 Arbitrary Blocks  (`block: thing`)
# 0.14.0 do..while  (`doWhile cond: body`)
```
```md
# 0.15.0 General Fixes   (leftovers at ./todo/0_basic.md)
- [ ] Switch case
  - [ ] discard = donothing
- [ ] Structs
  - [ ] Forward declare  https://gist.github.com/CMCDragonkai/aa6bfcff14abea65184a
  - [ ] Bitfields https://en.cppreference.com/w/c/language/bit_field
- [ ] Arrays: nested
- [ ] Array compound literals  array[int](0,1,2)  ->  (int[]){0,1,2}
- [ ] `{.volatile.}` variables
- [ ] `{.restrict.}`
- [ ] ...args version of varargs (@note parsing ... alone breaks the syntax. needs to be ...args or some alternative)
# 0.16.0 Advanced For Loops
# 0.17.0 Compiler Ergonomics
# ?.?.? Bugfixes
- [ ] `raw  *:array[32, unsigned char]`   -X->   `unsigned char raw[32];`   -bug->   `char raw;`
```

---
```md
# 0.?.0 Crash-Test to prepare for v1.0.0
```
```md
- [ ] Complete ./todo/0_basic.md
- [ ] Complete ./todo/2_compiler.md
- [ ] Complete ./todo/C_features.md
# 1.0.0 Complete C support
Focused Work on extensions can be started
```
```md
- [ ] Complete ./todo/1_extend.md
- [ ] Complete ./todo/3_parser.md
- [ ] Solve    ./todo/problems.md
# 2.0.0 Complete MinC Features
```
```md
# 3.0.0 Runic : C to MinC Translator
```

---
```md
_likely never reached, just noting for future reference_
# ?.?.? Meta-programming
```
