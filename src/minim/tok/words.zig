//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Tokenizer Process: Whitespace
//______________________________________________|
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
// @deps minim
const rules   = @import("../rules.zig");
const Pattern = rules.Pattern;
const Tok     = @import("../tok.zig");
const Tk      = Tok.Tk;

/// @descr Processes an identifier Lexeme into its Token representation, and adds it to the {@arg T.res} result.
pub fn ident (T :*Tok) !void {
  const l = T.lx();
  if (Pattern.Kw.has(l.val.items)) {
    try T.res.append(T.A, Tk{
      .id  = Pattern.Kw.get(l.val.items).?,
      .val = l.val,
    });
  } else {
    try T.res.append(T.A, Tk{
      .id  = Tk.Id.b_ident,
      .val = l.val,
    });
  }
} //:: M.Tok.ident

