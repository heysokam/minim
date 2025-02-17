//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview
//!  - Adds zls support
//!  - Adds support for building with confy from Zig's buildsystem
//!  This file is not needed at all to build or use the project
//_________________________________________________________________|
pub fn build (B :*@import("std").Build) !void {
  // Declare the project's confy builder
  const confy = B.addExecutable(.{
    .name             = "confy-builder",
    .root_source_file = B.path("./src/build.zig"),
    .target           = B.standardTargetOptions(.{}),
    .optimize         = B.standardOptimizeOption(.{}),
  });
  B.installArtifact(confy);
  // Dependencies: Builder
  confy.root_module.addImport("zstd",  B.addModule("zstd",  .{.root_source_file= B.path("./bin/.lib/zstd/src/zstd.zig") }));
  confy.root_module.addImport("confy", B.addModule("confy", .{.root_source_file= B.path("./bin/.lib/confy/src/confy.zig") }));

  // Dependencies: Project  (LSP support: zls)
  confy.root_module.addImport("zstd",  B.addModule("zstd",   .{.root_source_file= B.path("./bin/.lib/zstd/src/zstd.zig")   }));
  confy.root_module.addImport("slate", B.addModule("slate",  .{.root_source_file= B.path("./bin/.lib/slate/src/slate.zig") }));
  confy.root_module.addImport("ztest", B.addModule("ztest",  .{.root_source_file= B.path("./bin/.lib/ztest/src/ztest.zig") }));

  // Add support for `zig build run (-- arg1 arg2 arg3)`
  const R = B.addRunArtifact(confy);
  R.step.dependOn(B.getInstallStep());
  if (B.args) |arg| R.addArgs(arg);
  B.step("run", "Run the project's confy builder").dependOn(&R.step);
}

