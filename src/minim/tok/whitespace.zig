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
  try T.res.append(T.A, Tk{
    .id  = Tk.Id.wht_space,
    .val = zstd.ByteBuffer.init(T.A),
  });
  while (true) : (T.pos += 1) { // Collapse all continuous Lexeme spaces into a single space Token.
    const l = T.lx();
    if (l.id != .space) { break; }
    try T.append_toLast(l.val.items[0]); // @warning Assumes spaces are never collapsed in the Lexer
  }
  T.pos -= 1;
}

//____________________________
/// @descr Processes a newline Lexeme into its Token representation, and adds it to the {@arg T.res} result.
pub fn newline (T:*Tok) !void {
  try T.res.append(T.A, Tk{
    .id  = Tk.Id.wht_newline,
    .val = T.lx().val,
  });
}

