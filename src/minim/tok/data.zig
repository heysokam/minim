//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Tokenizer: Data Management
//_______________________________________________|
// @deps *Slate
const slate = @import("../../lib/slate.zig");
const Lx    = slate.Lx;
// @deps minim
const Tok = @import("../tok.zig");

//____________________________
/// @descr Returns the Lexeme located in the current position of the buffer
pub fn lx (T :*Tok) Lx { return T.buf.get(T.pos); }


//____________________________
/// @descr Adds a single character to the last Token of the {@arg T.res} Tokenizer result.
pub fn append_toLast (T:*Tok, C :u8) !void {
  const id = T.res.len-1;
  try T.res.items(.val)[id].append(C);
}

//____________________________
/// @descr Returns the Lexeme located {@arg id} positions ahead of the current position of the buffer.
pub fn next_at (T:*Tok, id :usize) Lx { return T.buf.get(T.pos+id); }

