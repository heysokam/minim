//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Tokenizer: Data Management
//_______________________________________________|
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
// @deps *Slate
const slate  = @import("../../lib/slate.zig");
const source = slate.source;
const Lx    = slate.Lx;
// @deps minim
const Tok = @import("../tok.zig");
const Tk  = @import("../tok.zig").Tk;


pub const add = struct {
  //__________________________
  /// @descr Increments the end position of the last Token of {@arg T.res} by a single character.
  /// @note Ensures that the character is equal to {@arg C} on safe builds.
  pub fn toLast (T:*Tok, C :u8) void {
    const items :[]source.Loc= T.res.items(.loc);
    const last  :source.Pos=   T.res.len-1;
    items[last].end += 1;
    zstd.ensure(T.src[items[last].end] == C, "Tried to append a character to the last Lexeme of a Lexer, but the characters do not match.");
  } //:: Tok.add.toLast

  //____________________________
  /// @descr Adds one token to the {@arg T.res} Tokenizer result.
  pub fn one (T:*Tok, id :Tk.Id, loc :Tok.Loc) !void {
    try T.res.append(T.A, Tk.create(id, loc, slate.Depth{.indent= T.depth_level, .scope= slate.Scope.Id.None}));
  } //:: Tok.add.one
};

//____________________________
/// @descr Returns the Lexeme located {@arg id} positions ahead of the current position of the buffer.
pub fn next_at (T:*Tok, id :usize) Lx { return T.buf.get(T.pos+id); }
//____________________________
/// @descr Returns the Lexeme located in the current position of the buffer
pub fn lx (T :*Tok) Lx { return T.next_at(0); }
//____________________________
/// @descr Moves the current position of the {@arg T} Tokenizer by {@arg N} tokens.
pub fn move (T :*Tok, N :source.Pos) void { T.pos +|= N; }
