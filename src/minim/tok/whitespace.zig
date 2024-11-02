//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Tokenizer Process: Whitespace
//______________________________________________|
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
// @deps *Slate
const slate = @import("../../lib/slate.zig");
const Lx    = slate.Lx;
// @deps minim
const Tok = @import("../tok.zig");
const Tk  = Tok.Tk;


//____________________________
/// @descr Processes a whitespace Lexeme into its Token representation, and adds it to the {@arg T.res} result.
pub fn space (T:*Tok) !void {
  const start = T.pos;
  var   end   = T.pos;
  while (true) : (T.pos += 1) { // Collapse all continuous Lexeme spaces into a single space Token.
    if (T.lx().id != .space) { break; }
    end += 1; // @warning Assumes spaces are never collapsed in the Lexer
  }
  try T.add(Tk.Id.wht_space, .{.start= start, .end= end});
  T.pos -= 1;
}

//____________________________
/// @descr Processes a newline Lexeme into its Token representation, and adds it to the {@arg T.res} result.
pub fn newline (T:*Tok) !void {
  try T.add(Tk.Id.wht_newline, T.lx().loc);
}

