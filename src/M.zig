//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");
// @deps z*std
const zstd = @import("./lib/zstd.zig");
// @deps minim
const M = @import("./minim.zig");


//______________________________________
/// @section Entry Point
//____________________________
pub fn main() !void {
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const A = arena.allocator();
  _=A;
  zstd.echo("Hello M.");

  // var L = M.Lex.create(A);
  // defer L.destroy();


  // // Lexer
  // var L = try Lex.create_with(A, cm);
  // defer L.destroy();
  // try L.process();
  // L.report();

  // // Tokenizer
  // var T = Tok.create(&L);
  // defer T.destroy();
  // try T.process();
  // T.report();

  // // Parser
  // var P = Par.create(&T);
  // defer P.destroy();
  // try P.process();
  // P.report();
  // const ast = P.res;
  // try ok(ast.lang == .C);
  // try ok(!ast.empty());

  // // Codegen
  // const code = try Gen.C(&ast);
  // const out = try std.fmt.allocPrint(A, "{s}", .{code});
  // code.report();
  // try check(out, c);
}

