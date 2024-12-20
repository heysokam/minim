//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Tokenizer: Report Process Status
//_______________________________________________|
// @deps minim
const Tok = @import("../tok.zig");

//____________________________
/// @descr Reports the contents of the {@arg T} tokenizer object to CLI
pub fn report (T:*Tok) void {
  Tok.prnt("--- minim.Tokenizer ---\n", .{});
  for (T.res.items(.id), T.res.items(.loc)) | id, loc | {
    Tok.prnt("{s} : {s}\n", .{@tagName(id), T.src[loc.start..loc.end]});
  }
  Tok.prnt("-----------------------\n", .{});
} //:: M.Tok.report

