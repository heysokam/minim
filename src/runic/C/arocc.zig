//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
const arocc = @This();
// @deps std
const std  = @import("std");
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
const cstr = zstd.cstr;

const Aro = @import("../lib/arocc/src/aro.zig");
const Ast = Aro.Tree;
const ast = struct {
  fn get (src :cstr, A :std.mem.Allocator) !arocc.Ast {
    // Setup the Compiler
    var cc = try Aro.Compilation.initDefault(A, std.fs.cwd());
    defer cc.deinit();
    const source  = try cc.addSourceFromBuffer("<InMemory-SourceCode>", src);
    const builtin = try cc.generateBuiltinMacros(.include_system_defines, null);
    // Run the Preprocessor
    var pp = try Aro.Preprocessor.initDefault(&cc);
    defer pp.deinit();
    try pp.preprocessSources(&.{ source, builtin });
    // Return the AST
    return pp.parse();
  } //:: arocc.ast.get
}; //:: arocc.ast

