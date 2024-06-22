//:____________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
//! @fileoverview Core Logger functionality
//___________________________________________|
// @deps std
const std = @import("std");

//______________________________________
// @section Aliased exports from std
//____________________________
pub const prnt = @import("std").debug.print;
pub const fail = @import("std").debug.panic;


//______________________________________
/// @descr Outputs the {@arg msg} to CLI with an added \n at the end.
pub fn echo(msg :[]const u8) !void {
  // stdout for the output of the app, not for debugging messages.
  const stdout_file = std.io.getStdOut().writer();
  var bw = std.io.bufferedWriter(stdout_file);
  const stdout = bw.writer();
  try stdout.print("{s}\n", .{msg});
  try bw.flush();
}

