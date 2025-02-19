//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");
// @deps minim
const Tok = @import("../tok.zig");
const Tk  = Tok.Tk;
const Par = @import("../par.zig");


//____________________________
/// @descr Returns the Lexeme located {@arg id} positions ahead of the current position of the buffer.
pub fn next_at (P :*Par, id :usize) Tk { return P.buf.get(P.pos+id); }
//____________________________
/// @descr Returns the Token located in the current position of the buffer
pub fn tk (P :*Par) Tk { return next_at(P,0); }
//__________________________
/// @descr
///  Moves the current position of the Parser by {@arg N} Tokens
///  Moving by positive numbers will append to {@arg P.parsed} the string of every token found on each step.
pub fn move (P:*Par, N :i64) void {
  if (N == 0) return;
  if (std.math.sign(N) < 0) {
    P.pos += @intCast(N);
    return;
  }
  for (0..@intCast(N)) |step| {
    P.parsed.appendSlice(P.tk().from(P.src)) catch
      |err| std.debug.panic("Parser {s}: Something went wrong at step `{d}` when advancing the position by `{d}`.\n", .{@errorName(err), step, N});
    P.pos += 1;
  }
} //:: Par.data.move

//__________________________
/// @descr
///  Moves the Parser forwards by 1 only if the {@arg id} Token is found at the current position.
///  Does nothing if we are already at the last token.
pub fn skip (P:*Par, id :Tk.Id) void {
  if (P.last()) return;
  if (P.tk().id == id){ P.move(1); }
} //:: Par.data.skip

