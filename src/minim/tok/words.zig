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
  // Add a keyword if it exists in the Pattern list. Add an identifier otherwise
  try T.add(
    Pattern.Kw.get(l.from(T.src)) orelse Tk.Id.b_ident,
    l.loc);
} //:: M.Tok.ident

