//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Parser: Report Process Status
//_______________________________________________|
// @deps minim
const Par = @import("../par.zig");


//____________________________
/// @descr Reports the contents of the {@arg P} Parser object to CLI
pub fn report (P :*Par) void {
  Par.prnt("--- minim.Parser ---\n", .{});
  if (P.res.list.data != null) {
    for (P.res.list.data.?.items, 0..) | id, val | {
      Par.prnt("{s} : {any}\n", .{@tagName(id), val});
    }
    Par.prnt("--------------------\n", .{});
    Par.prnt("{s}\n", .{P.parsed.items});
  }
  Par.prnt("--------------------\n", .{});
}

