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


// // FIX: Take out of butcher
// pub fn main() !void {
//   var A = std.heap.ArenaAllocator.init(std.heap.page_allocator);
//   defer A.deinit();
//   zstd.echo("Hello M.");
// }
//

const process = struct {
  fn parse (cli :*const CLI) !M.Ast {
    //_____________________________
    // Read the code
    const input = try zstd.files.read(cli.cfg.input, cli.A, .{.maxFileSize= cli.cfg.maxFileSize});
    defer cli.A.free(input);
    var src = try zstd.str.initCapacity(cli.A, input.len+1);
    defer src.deinit();
    src.appendSliceAssumeCapacity(input);
    src.appendAssumeCapacity(0);
    //_____________________________
    // Preprocess
    const zm = try M.Pre.process(&src);
    defer zm.deinit();
    //_____________________________
    // Generate AST
    var ast = try M.Ast.get(zm.items[0..:0], cli.A);
    errdefer ast.destroy();
    //if (cli.cfg.verbose) code.report();
    //_____________________________
    // Generate the target language AST
    return ast;
  }

  fn compile (ast :*const M.Ast, cli :CLI) !void {
    //_____________________________
    // Write the code into a cache file
    // FIX: Remove hardcoded C
    const tmpFile = Cfg.default.dir.cache++"/tmp"++Cfg.default.fmt.ext++".c";
    const code = try ast.gen();
    try zstd.files.write(code.items, tmpFile, .{});
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

  fn codegen (ast :*const M.Ast, cli :CLI) !void {_=ast;_=cli;
    return error.minim_todo_CLICodegenSupport;
  }

//   fn codegen (code :*const slate.C.Ast, cli :CLI) !void {
//     //_____________________________
//     // Write the code into a cache file
//     const tmpFile = Cfg.default.dir.cache++"/tmp"++Cfg.default.fmt.ext++".c";
//     try code.write(tmpFile);
//     //_____________________________
//     // Format the code
//     // TODO: clangFmtBin clangFmtFile
//     //_____________________________
//     // Copy the formatted code into the output file
//     try zstd.files.copy(tmpFile, cli.cfg.output, .{});
//   }
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

