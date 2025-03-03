//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("./lib/zstd.zig");
// @deps minim
const slate = @import("./lib/slate.zig");
const CLI   = @import("./minim/cli.zig");
const M     = struct {
  usingnamespace @import("./minim.zig");
  const Cfg = @import("./minim/cfg.zig");

  // TODO: Move M.log to its own file
  const log = struct {
    const Prefix = M.Cfg.Prefix++": ";
    const prnt = zstd.prnt;
    fn echo (msg :zstd.cstr) void { zstd.prnt("{s}\n", .{msg}); }
    fn info (msg :zstd.cstr) void { zstd.prnt("{s}{s}\n", .{M.log.Prefix, msg}); }
  };
};


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
    // FIX: Change to Ast.read()
    const input = try zstd.files.read(cli.cfg.input, cli.A, .{.maxFileSize= cli.cfg.maxFileSize});
    defer cli.A.free(input);
    var src = zstd.str.init(cli.A);
    defer src.deinit();
    try src.appendSlice(input);
    try src.append(0);
    //_____________________________
    // Preprocess
    if (cli.cfg.verbose) M.log.prnt("{s}Preprocessing code from file:\n  {s}\n", .{M.log.Prefix, cli.cfg.input});
    var zm = try M.Pre.process(&src);
    defer zm.deinit();
    //_____________________________
    // Generate AST
    if (cli.cfg.verbose) M.log.info("Parsing AST for the resulting preprocessed code.");
    var ast = try M.Ast.get(try zm.toOwnedSliceSentinel(0), .C, cli.A); // FIX: Remove hardcoded C
    errdefer ast.destroy();
    //_____________________________
    // Generate the target language AST
    return ast;
  }

  fn compile (ast :*const M.Ast, cli :CLI) !void {
    //_____________________________
    // Write the code into a cache file
    // FIX: Remove hardcoded C
    const tmpFile = try std.fmt.allocPrint(cli.A, "{s}/tmp{s}.c", .{cli.cfg.dir.cache, cli.cfg.fmt.ext});
    defer cli.A.free(tmpFile);
    if (cli.cfg.verbose) M.log.prnt("{s}Generating the target's language source code to file:\n  {s}\n", .{M.log.Prefix, tmpFile});
    const code = try ast.gen();
    defer code.deinit();
    try zstd.files.write(code.items, tmpFile, .{});
    //_____________________________
    // Format the code
    // TODO: clangFmtBin clangFmtFile
    //_____________________________
    // Compile the generated code into binaries
    if (cli.cfg.verbose) M.log.info("Compiling the target language's source code with command:");
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

