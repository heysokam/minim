//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Core logic for the Minim's Binary compiler
//___________________________________________________________|
pub const CC = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const cstr = zstd.cstr;
// @deps minim
const CLI = @import("./cli.zig");
const Cfg = @import("./cfg.zig");

pub const compile = struct {
  pub fn C (file :cstr, cli :CLI) !void {
    if (cli.cfg.verbose) zstd.prnt("  {s} {s} {s} {s} {s}\n", .{cli.cfg.zigBin, "cc", file, "-o", cli.cfg.output});
    try zstd.shell.run(&.{cli.cfg.zigBin, "cc", file, "-o", cli.cfg.output}, cli.A);
  }
};

pub const C = CC.compile.C;

