//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");
// @deps z*std
const zstd = @import("./lib/zstd.zig");
// @deps minim
const M   = @import("./minim.zig");
const CLI = @import("./minim/cli.zig");
const Cfg = @import("./minim/cfg.zig");


//______________________________________
/// @section Entry Point
//____________________________
pub fn main() !void {
  var A = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer A.deinit();
  zstd.echo("Hello M.");

  //_____________________________
  // Get CLI options and config
  var cli = try CLI.init(A.allocator());
  defer cli.destroy();

  //_____________________________
  // Compile Process
  //_____________________________
  // Read the code
  const input = try zstd.files.read(cli.cfg.input, A.allocator(), .{.maxFileSize= cli.cfg.maxFileSize});
  defer A.allocator().free(input);
  //_____________________________
  // Preprocess
  const zm = try M.Pre.process(input, A.allocator());
  defer A.allocator().free(zm);
  //_____________________________
  // Generate AST
  var ast = try M.Ast.get(zm, A.allocator());
  defer ast.destroy();
  //_____________________________
  // Codegen
  var code = try M.Gen.C(&ast);
  defer code.destroy();
  //if (cli.cfg.verbose) code.report();
  //_____________________________
  // Write the code into a temp file
  const tmpFile = Cfg.default.dir.cache++"/tmp"++Cfg.default.fmt.ext++".c";
  try code.write(tmpFile);
  // TODO: clangFmtBin clangFmtFile
  //_____________________________
  // Compile the generated code into binaries
  try M.CC.C(tmpFile, cli);
  //_____________________________
  // Run the final binary when requested
  if (cli.cfg.run) try zstd.shell.run(&.{cli.cfg.output}, cli.A);
}

