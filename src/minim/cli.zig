//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview CLI options management for the minim compiler.
//_______________________________________________________________|
pub const CLI = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
// @deps minim
const Cfg = @import("./cfg.zig");

opts  :zstd.CLI,
cfg   :Cfg,

const Error = error { MissingCommandArg, MissingFileArg  };
const check = struct {
  fn args (cli :*CLI) !void { switch (cli.cfg.cmd) {
    .compile => if (cli.opts.args.items.len != 2) return CLI.Error.MissingFileArg,
    .codegen => if (cli.opts.args.items.len != 3) return CLI.Error.MissingFileArg,
    .none    => return CLI.Error.MissingCommandArg,
    } //:: switch (cli.cfg.cmd) { ... }
  }

  // TODO:
  // #_______________________________________
  // # @section CLI Error check
  // #_____________________________
  // proc err (msg :string) :void=
  //   echo &"{cfg.Prefix}  Error  {msg}"
  //   stopAndHelp()
  // #_____________________________
  // proc check (cli :opts.CLI) :void=
  //   if "version" in cli.opts.long  : stopAndVersion()
  //   if "h" in cli.opts.short       : stopAndHelp()
  //   for opt in cli.opts.long       :
  //     if opt notin KnownLong       : err "Found an unknown long option: "&opt
  //   for opt in cli.opts.short      :
  //     if opt notin KnownShort      : err "Found an unknown short option: "&opt
  //   if cli.args.len < 1            : err "MinC was called without arguments."
  //   if cli.args.len != 3           : err "MinC was called with an incorrect number of arguments: " & $cli.args.len
  //   if cli.args[0] notin KnownCmds : err "Found an unknown command: "&cli.args[0]
  // #_____________________________
  // const KnownCmds  :HashSet[string]=  ["c","cc"].toHashSet
  // const KnownShort :HashSet[string]=  ["v","q","h","r"].toHashSet
  // const KnownLong  :HashSet[string]=  [
  //   "help","version","verbose","quiet",
  //   "zigBin", "clangFmtBin",
  //   "binDir","cacheDir","codeDir",
  //   "cfile","path","passL","passC",
  //   "os","cpu",
  //   ].toHashSet
  //

};


fn getSystem (cli :*CLI) !zstd.System {
  const host = zstd.System.host();
  const os   = cli.opts.hasLong("os");
  const cpu  = cli.opts.hasLong("cpu");
  if (!os and !cpu) return host;
  var result :zstd.System= host;
  if (cli.opts.hasLong("os") ) result.os  = zstd.System.parse.os(try cli.opts.getLong("os"));
  if (cli.opts.hasLong("cpu")) result.cpu = zstd.System.parse.cpu(try cli.opts.getLong("cpu"));
  result.abi =
    if (!cli.opts.hasLong("abi")) zstd.System.parse.abi(try cli.opts.getLong("abi"))
    else                          zstd.System.default.abi(result.cpu, result.os);
  return result;
}


pub fn init (A :std.mem.Allocator) !CLI {
  var result = CLI{
    .opts = try zstd.CLI.init(A),
    .cfg  = Cfg{},
    }; //:: result
  // Arguments
       if (result.opts.hasArgAt("c",  0)) { result.cfg.cmd = .compile; }
  else if (result.opts.hasArgAt("cc", 0)) { result.cfg.cmd = .codegen; }
  try CLI.check.args(&result);
  // Single Flags
  if (result.opts.hasShort('q') or result.opts.hasLong("quiet")) result.cfg.quiet = true;
  if (result.opts.hasShort('v') or result.opts.hasLong("verbose")) result.cfg.verbose = true;
  result.cfg.quiet = result.cfg.quiet and !result.cfg.verbose; // Override quiet with verbose
  if (result.opts.hasShort('r')) result.cfg.run = true;
  // Folders
  if (result.opts.hasLong("cacheDir")) result.cfg.dir.cache = try result.opts.getLong("cacheDir");
  if (result.opts.hasLong("binDir")  ) result.cfg.dir.bin   = try result.opts.getLong("binDir");
  if (result.opts.hasLong("codeDir") ) result.cfg.dir.code  = try result.opts.getLong("codeDir");
  // Binaries
  if (result.opts.hasLong("zigBin")      ) result.cfg.zigBin   = try result.opts.getLong("zigBin");
  if (result.opts.hasLong("clangFmtBin") ) result.cfg.fmt.bin  = try result.opts.getLong("clangFmtBin");
  if (result.opts.hasLong("clangFmtFile")) result.cfg.fmt.file = try result.opts.getLong("clangFmtFile");
  // Compile Options
  if (result.opts.hasLong("release")) result.cfg.mode = .release;
  result.cfg.system = try result.getSystem();
  // TODO: path    HashSet[Path]
  // TODO: passC   HashSet[string]
  // TODO: passL   HashSet[string]
  // TODO: cfile   HashSet[Path]
  // Return the resulting configuration
  return result;
}

pub fn destroy (cli :*CLI) void { cli.opts.destroy(); }


// TODO:
pub const help = struct {
  // #_______________________________________
  // # @section CLI Help
  // #_____________________________
  // const Help = """
  // {cfg.Prefix}  Usage
  //   minc [cmd] -(opt) [input] [output]
  //
  //  Usage  Options (single letter)
  //   -h   : Print this notice and quit
  //   -v   : Activate verbose mode
  //   -r   : Run the final binary after compilation finishes
  //
  //  Usage  Options (word)
  //   --help              : Print this notice and quit
  //   --version           : Print the version and quit
  //   --verbose           : Activate verbose mode
  //   --quiet             : Activate quiet mode (ignored when verbose). Silences debug messages from the logger, even when the compiler is built in debug mode.
  //
  //   --binDir:path       : Changes the default bin path where other paths will be searched for when relevant (default:  {cfg.binDir})
  //   --binDir:path       : Define the path where the compiled content will be output  (default:  {cfg.binDir})
  //   --cacheDir:path     : Defined the path where the temporary/intermediate files will be output  (default:  {cfg.mincCache})
  //   --codeDir:path      : Define the folder where the C code will be output  (default:  {getCurrentDir()})
  //
  //   --zigBin:path       : Changes the default path of the ZigCC binary  (default:  {cfg.zigBin})
  //   --clangFmtBin:path  : Changes the default path of the clang-format binary  (default:  {cfg.clangFmtBin})
  //   --clangFmtFile:path : Sets the path of the clang-format options file. Will not be passed to clang-format when omitted.
  //
  //   --cfile:path        : Extra C source code file that should be added to the compilation command for building the final binary.
  //   --path:path         : Defines a path that will be `-Ipath` included in the compilation command for building the final binary.
  //   --passC:"arg"       : Defines an extra argument that will be passed to the compiler command when building the final binary.
  //   --passL:"arg"       : Defines an extra argument that will be passed to the linking command when building the final binary.
  //   --os:value          : Defines the target OS that the final binary will be built for.
  //   --cpu:value         : Defines the target CPU architecture that the final binary will be built for.
  //
  //  Usage  Compilation
  //           --=|=--
  //   [cmd]      | Description
  //   ___________|__________________________________________
  //   c          | Compile to Binary using ZigCC
  //   cc         | Compile to Code
  //   ___________|__________________________________________
  //           --=|=--
  //   [argument] | Description
  //   ___________|__________________________________________
  //   input      | Path of the root file that will be processed/compiled
  //              | - Can be a relative or absolute
  //              | - Must be a single and valid MinC file
  //              | - Its folder will be used as the root folder for path resolution of import/include calls
  //   ___________|____________________________________________
  //   output     | Path of the output file where the minc process will be sent
  //              | - Can be a relative or absolute
  //              | - Will be a single C file with .c extension  (#TODO: Multifile)
  //              |   Will contain all of the relevant code amalgamated into a single file
  //   ___________|____________________________________________
  // """
  // proc stopAndHelp= quit fmt Help
  // proc stopAndVersion= quit fmt """
  // {cfg.Prefix}  Version  {cfg.Version}"""
};

