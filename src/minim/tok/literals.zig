//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Tokenizer Process: Literal Values
//__________________________________________________|
// @deps minim
const Tok = @import("../tok.zig");
const Tk  = Tok.Tk;

//____________________________
/// @descr Processes a number Lexeme into its Token representation, and adds it to the {@arg T.res} result.
/// @todo Should this process the numbers into different number kinds?
pub fn number (T:*Tok) !void {
  try T.res.append(T.A, Tk{
    .id  = Tk.Id.b_number,
    .val = T.lx().val,
  });
}

