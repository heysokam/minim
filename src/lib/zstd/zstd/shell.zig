//:____________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
//! @fileoverview Shell Commands and tools for CLI
//_________________________________________________|
// @deps std
const std = @import("std");
// @deps C stdlib
// const C = @import("C.zig");


/// @unsafe @libc
/// @descr Runs the given command using {@link C.stdlib.system} in non-capturing (aka shell-like) mode
const c = struct {
  // if (std.builtin.link_libc) {
  //   fn sh(cmd :[:0]const u8) void { _ = C.stdlib.system(cmd); }
  // }
};

const zig = struct {
  /// @unsafe @blocking
  /// @descr Runs the given command using {@link std.process.Child.spawnAndWait} in non-capturing (aka shell-like) mode
  /// @todo Broken. Doesn't work.
  fn sh(cmd :[:0]const u8, args :[:0]const u8) void {
    var A = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    var P = std.process.Child.init(&.{cmd, args}, A.allocator());
    _ = std.process.Child.spawnAndWait(&P) catch unreachable;
    A.deinit();
  }
};

// if (std.builtin.link_libc) {
//   pub const csh = c.sh;
// }
pub const zsh = zig.sh;

