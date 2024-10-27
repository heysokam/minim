//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Tokenizer Contents Checks
//___________________________________________|
// @deps *Slate
const slate = @import("../../lib/slate.zig");
const Ch    = slate.Ch;
// @deps minim
const Tok = @import("../tok.zig");

/// @descr Returns whether or not the next Lexeme in the buffer is an operator lexeme.
pub fn next_isOperator (T :*Tok) bool { return Ch.isOperator(Tok.next_at(T,1).val.items[0]); }
/// @descr Returns whether or not the next Lexeme in the buffer is a whitespace lexeme.
pub fn next_isWhitespace (T:*Tok) bool { return Ch.isWhitespace(Tok.next_at(T,1).val.items[0]); }
/// @descr Returns whether or not the next Lexeme in the buffer is a dot lexeme.
pub fn next_isDot (T:*Tok) bool { return Ch.isDot(Tok.next_at(T,1).val.items[0]); }
/// @descr Returns whether or not the next Lexeme in the buffer is a parenthesis, bracket or brace lexeme.
pub fn next_isPar (T:*Tok) bool { return Ch.isPar(Tok.next_at(T,1).val.items[0]); }

