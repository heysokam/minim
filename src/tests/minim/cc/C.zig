//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");
// @deps minim
const M = @import("../../../minim.zig");
const slate = @import("slate");
// @deps minim.tests
const t  = @import("../base.zig");
const it = t.it;


//______________________________________
// @section Compilation Target: C
//____________________________
var  C = t.title("minim.CC | Target: C");
test C { C.begin(); defer C.end();
const lang = M.Lang.C;

try it("should not error when the compiler runs", struct { fn f() !void {
  // Setup
  const code = try std.fmt.allocPrintZ(t.A,
    \\proc main*():int= return {d}
    , .{C.id});
  defer t.A.free(code);
  // Validate
  // Run & Check
  _= try t.run(code, lang);
}}.f);

try it("should return the expected result when run", struct { fn f() !void {
  // Setup
  const Expected :u8= @intCast(C.id);
  const code = try std.fmt.allocPrintZ(t.A,
    \\proc main*():int= return {d}
    , .{Expected});
  defer t.A.free(code);
  // Validate
  // Run
  const result = try t.run(code, lang);
  // Check
  try t.eq(result.code, Expected);
}}.f);

} //:: minim.CC | Target: C

