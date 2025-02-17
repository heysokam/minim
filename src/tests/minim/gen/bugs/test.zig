//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps minim
const M = @import("../../../../minim.zig");
// @deps minim.tests
const t  = @import("../../base.zig");
const it = t.it;

const Bugs = t.title("minim.Gen | Bug Fixes");
test Bugs { Bugs.begin(); defer Bugs.end();

try it("should generate the correct code for the return type of functions", struct { fn f() !void {
  // Setup
  const ret      = t.case.Hello42.res.lex[9];
  const code     = t.case.Hello42.src;
  const Expected = ret.from(code);
  // Validate
  try t.eq_str(Expected, "int");
  // Run
  var ast = try M.Ast.get2(code, .{}, t.A);
  defer ast.destroy();
  const result = ast.data.types.at(
    ast.data.nodes.items()[0].Proc.retT
  ).?.any.name.from(code);
  // Check
  try t.eq_str(result, Expected);
}}.f);

} //:: minim.Gen | Bug Fixes

