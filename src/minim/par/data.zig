//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps minim
const Tok = @import("../tok.zig");
const Tk  = Tok.Tk;
const Par = @import("../par.zig");


//____________________________
/// @descr Returns the Token located in the current position of the buffer
pub fn tk (P :*Par) Tk { return P.buf.get(P.pos); }
//____________________________
/// @descr Returns the Lexeme located {@arg id} positions ahead of the current position of the buffer.
pub fn next_at (P :*Par, id :usize) Tk { return P.buf.get(P.pos+id); }
//__________________________
/// @descr Moves the current position of the Parser by {@arg n} Tokens
pub fn move (P:*Par, n :i64) void {
  P.parsed.appendSlice(P.tk().val.items) catch {};
  P.pos += @intCast(n);
}
//__________________________
/// @descr Moves the Parser forwards by 1 only if the {@arg id} Token is found at the current position.
pub fn skip (P:*Par, id :Tk.Id) void {
  //if (P.end()) P.fail("Tried to skip a token, but we are already at the end.  '{s}':{d}:'{s}'", .{@tagName(id), P.pos, @tagName(P.tk().id)});
  if (P.last()) return;
  if (P.tk().id == id){ P.move(1); }
}

