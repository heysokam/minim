//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Parser Process: Indentation
//____________________________________________|
const indentation = @This();
// @deps minim
const Tok = @import("../tok.zig");
const Tk  = Tok.Tk;
const Par = @import("../par.zig");

//__________________________
/// Indentation
//__________________________
pub fn expect (P :*Par) void { P.expectAny(&.{Tk.Id.wht_newline, Tk.Id.wht_space}, "Indentation"); }

pub fn parse (P:*Par) void {
  P.skip(Tk.Id.wht_space);
  const update = P.tk().id == .wht_newline;
  P.skip(Tk.Id.wht_newline);
  if (update) P.depth.indent = P.tk().loc.len();
  P.skip(Tk.Id.wht_space);
}

