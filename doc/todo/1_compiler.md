```md
# Internal C compiler todo
- [ ] Support includes with comments
- [ ] --verbose-cc
- [ ] Bundle zigcc
- [ ] Provide an interface for zigcc in the minc binary
- [ ] Provide the `-c` option to just output C code and not build it.
- [ ] Docs:
  - [ ] Link to an always-up-to-date list of natively supported cross-compilation targets
  - [ ] Reminder that nim is only required for building the compiler itself. Users don't need it
  - [ ] Reminder that ZigCC is bundled, and doesn't need to be manually installed
  - [ ] Reasons for using ZigCC as the internal compiler
        https://www.youtube.com/watch?v=YXrb-DqsBNU&t=506s
        https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html
        https://ziglang.org/learn/overview/#zig-is-also-a-c-compiler
  - [ ] No need for cmake/makefiles/etc. Compiler support is integrated into the source files.
  - [ ] Info on libc-musl-etc target options from zigcc
  - [ ] Reminder about the ease of Cross-compilation UX (installation of msvc,mingw,osxcross,etc)
- [ ] --unbounded (explicit opt-in for unbounded-C support)
- [ ] -ffunction-sections -fdata-sections --gc-sections --print-gc-sections
- [ ] -fvisibility=hidden   <- like id-Tech3
- [ ] other flags : https://developers.redhat.com/blog/2018/03/21/compiler-and-linker-flags-gcc
- [ ] Optimization options
  - [ ] -O4 ??   -O2 -flto instead?
  - [ ] ?mold on linux ?
- [ ] Build modes:
  - [ ] Debug    # All debug flags active
  - [ ] Release  # Optimization flags active
  - [ ] None     # No flags. Blank slate for --passC:" ... "
- [ ] Single Header option
- [ ] Redundant code management  (C codegen output)
  - [ ] ?maybe? import statement might partially solve this use-case ?
  - [ ] Only add used+public types and functions to output
  - [ ] Option to always add everything
```

```md
# For 2.0.0
- [ ] Auto-nim bindings option
```

