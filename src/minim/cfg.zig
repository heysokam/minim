//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Configuration management for the minim compiler.
//_________________________________________________________________|
const Cfg = @This();
// @deps std
const builtin = @import("builtin");
// @deps zstd
const zstd   = @import("../lib/zstd.zig");
const cstr   = zstd.cstr;
const System = zstd.System;

const BuildMode = enum { debug, release };
const Cmd = enum { none, compile, codegen };
const Dirs = struct {
  /// @descr Folder where all source code files will be searched for
  src   :cstr  = Cfg.default.dir.src,
  /// @descr Folder where all binaries will be output
  bin   :cstr  = Cfg.default.dir.bin,
  /// @descr Folder where intermediate/temporary files will be output
  cache :cstr  = Cfg.default.dir.cache,
  /// @descr Folder where the resulting code will be output
  code  :?cstr = Cfg.default.dir.code,
  }; //:: Dirs
const Fmt = struct {
  /// @descr Command to run for formatting the output code
  bin  :cstr= Cfg.default.fmt.bin,
  /// @descr Temporary output/intermediate file of the formatter
  ext  :cstr= Cfg.default.fmt.ext,
  }; //:: Fmt

quiet       :bool      =  Cfg.default.quiet,
verbose     :bool      =  Cfg.default.verbose,
run         :bool      =  false,
mode        :BuildMode =  Cfg.BuildMode.debug,
cmd         :Cmd       =  Cfg.Cmd.none,
input       :cstr      =  Cfg.Undefined.input,
output      :cstr      =  Cfg.Undefined.output,
zigBin      :cstr      =  Cfg.default.zigBin,
dir         :Dirs      =  Cfg.Dirs{},
fmt         :Fmt       =  Cfg.Fmt{},
system      :System    =  Cfg.default.system,
maxFileSize :usize     =  50*1024,


pub fn defaults () Cfg { return Cfg{}; }

pub const Undefined = struct {
  pub const input  = "UndefinedInput";
  pub const output = "UndefinedOutput";
};

pub const default = struct {
  const verbose = if (builtin.mode == .Debug) true else false;
  const quiet   = true and !Cfg.default.verbose;
  pub const dir = struct {
    const src         = "src";
    const bin         = "bin";
    pub const cache   = default.dir.bin++"/.cache/M";
    const code :?cstr = null;
  };
  const zigBin = Cfg.default.dir.bin++"/.zig/zig";
  pub const fmt = struct {
    const bin :cstr= "clang-format";
    pub const ext :cstr= ".fmt";
  };
  const system = System.host();
};

