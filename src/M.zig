//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("./lib/zstd.zig");
// @deps minim
const M     = @import("./minim.zig");
const CLI   = @import("./minim/cli.zig");
const Cfg   = @import("./minim/cfg.zig");
const slate = @import("./lib/slate.zig");

const process = struct {
  fn parse (cli :*const CLI) !slate.C.Ast {
    //_____________________________
    // Read the code
    const input = try zstd.files.read(cli.cfg.input, cli.A, .{.maxFileSize= cli.cfg.maxFileSize});
    defer cli.A.free(input);
    //_____________________________
    // Preprocess
    const zm = try M.Pre.process(input, cli.A);
    defer cli.A.free(zm);
    //_____________________________
    // Generate AST
    var ast = try M.Ast.get(zm, cli.A);
    defer ast.destroy();
    //if (cli.cfg.verbose) code.report();
    //_____________________________
    // Generate the target language AST
    return try M.Gen.C(&ast);
  }

  fn compile (code :*const slate.C.Ast, cli :CLI) !void {
    //_____________________________
    // Write the code into a cache file
    const tmpFile = Cfg.default.dir.cache++"/tmp"++Cfg.default.fmt.ext++".c";
    try code.write(tmpFile);
    //_____________________________
    // Format the code
    // TODO: clangFmtBin clangFmtFile
    //_____________________________
    // Compile the generated code into binaries
    try M.CC.C(tmpFile, cli);
    //_____________________________
    // Run the final binary when requested
    if (cli.cfg.run) try zstd.shell.run(&.{cli.cfg.output}, cli.A);
  }

  fn codegen (code :*const slate.C.Ast, cli :CLI) !void {
    //_____________________________
    // Write the code into a cache file
    const tmpFile = Cfg.default.dir.cache++"/tmp"++Cfg.default.fmt.ext++".c";
    try code.write(tmpFile);
    //_____________________________
    // Format the code
    // TODO: clangFmtBin clangFmtFile
    //_____________________________
    // Copy the formatted code into the output file
    try zstd.files.copy(tmpFile, cli.cfg.output, .{});
  }
};

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
  // Parse
  var code = try process.parse(&cli);
  defer code.destroy();

  //_____________________________
  // Run the main process
  switch (cli.cfg.cmd) {
    .compile => try process.compile(&code, cli),
    .codegen => try process.codegen(&code, cli),
    .none    => zstd.fail("Command type Cmd.none should never be run.\n", .{}),
  }
}

