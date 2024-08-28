//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");
const eq  = std.mem.eql;
const ok = std.testing.expect;
const check = std.testing.expectEqualStrings;
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
const echo = zstd.echo;
const prnt = zstd.prnt;
const sh   = zstd.sh;
// @deps *Slate
const slate = @import("../../lib/slate.zig");
const C     = slate.C;
const Lex   = slate.Lex;
// @deps minim
const M   = @import("../../minim.zig");
const Tok = M.Tok;
const Par = M.Par;
const Ast = M.Ast;
const Gen = M.Gen;


const Title = "Basic Checks";
test "00 | dummy check" {
  // Should pass a dummy check
  const cm = @embedFile("./00.cm");
  const zm = @embedFile("./00.zm");
  const c  = @embedFile("./00.c");
  const z  = @embedFile("./00.zig");
  try check(cm, "");
  try check(c,  "");
  try check(zm, "");
  try check(z,  "");
}

test "01 | Basic Code Generation" {
  // Should do basic code generation
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const A = arena.allocator();

  const cm = @embedFile("./01.cm");
  const zm = @embedFile("./01.zm");
  const c  = @embedFile("./01.c");
  const z  = @embedFile("./01.zig");
  try ok(!eq(u8, c,z));
  try ok(!eq(u8, cm,zm));

  // Lexer
  var L = try Lex.create_with(A, cm);
  defer L.destroy();
  try L.process();
  L.report();

  // Tokenizer
  var T = Tok.create(&L);
  defer T.destroy();
  try T.process();
  T.report();

  // Parser
  var P = Par.create(&T);
  defer P.destroy();
  try P.process();
  P.report();
  const ast = P.res;
  try ok(ast.lang == .C);
  try ok(!ast.empty());

  // Codegen
  const code = try Gen.C(&ast);
  const out = try std.fmt.allocPrint(A, "{s}", .{code});
  code.report();
  try check(out, c);
}


test "hello.42" {
  var A = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer A.deinit();

  const retT   = "int";
  const fname  = "main";
  const result = "42";

  var body = C.Func.Body.create(A.allocator());
  try body.add(C.Stmt.Return.new(C.Expr.Literal.Int.new(.{ .val= result })));
  const f = C.Func{
    .retT= C.Ident.Type{ .name= retT, .type= .i32 },
    .name= C.Ident.Name{ .name= fname },
    .body= body,
    }; // << Func{ ... }
  const out = try std.fmt.allocPrint(A.allocator(), "{s}", .{f});
  // prnt("{s}", .{f});

  try check(out, retT++" const "++fname++"(void) { return "++result++"; }\n");
}

