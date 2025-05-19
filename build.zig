//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview
//!  Adds zls support
//!  This file is not needed at all to build or use the project
//_________________________________________________________________|
pub fn build (B :*@import("std").Build) !void {
  // Dependencies: Project  (LSP support: zls)
  B.addModule("zstd",     .{.root_source_file= B.path("./bin/.lib/zstd/src/zstd.zig")});
  B.addModule("slate",    .{.root_source_file= B.path("./bin/.lib/slate/src/slate.zig") });
  B.addModule("minitest", .{.root_source_file= B.path("./bin/.lib/minitest/src/minitest.zig") });
}

