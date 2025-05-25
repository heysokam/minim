//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview
//!  Adds zls support
//!  This file is not needed at all to build or use the project
//_________________________________________________________________|
pub fn build (B :*@import("std").Build) !void {
  const minim = B.addExecutable(.{
    .name             = "minim",
    .root_source_file = B.path("./src/minim.zig"),
    .target           = B.standardTargetOptions(.{}),
    .optimize         = B.standardOptimizeOption(.{}),
  });
  B.installArtifact(minim);
  // Dependencies: Project  (LSP support: zls)
  minim.root_module.addImport("zstd",  B.addModule("zstd",   .{.root_source_file= B.path("./bin/.lib/zstd/src/zstd.zig")   }));
  minim.root_module.addImport("slate", B.addModule("slate",  .{.root_source_file= B.path("./bin/.lib/slate/src/slate.zig") }));
  minim.root_module.addImport("minitest", B.addModule("minitest",  .{.root_source_file= B.path("./bin/.lib/minitest/src/minitest.zig") }));
}

