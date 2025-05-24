//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Tokenizer Contents Checks
//___________________________________________|
// @deps std
const std = @import("std");
// @deps *Slate
const slate = @import("../../lib/slate.zig");
const Lx    = slate.Lx;
// @deps minim
const Tok   = @import("../tok.zig");
const rules = @import("../rules.zig");

pub const next = struct {
  /// @descr Returns whether or not the next Lexeme in the buffer is a number lexeme.
  pub fn isNumber (T:*Tok) bool { return rules.isNumber(T.next_at(1)); }
  /// @descr Returns whether or not the next Lexeme in the buffer is an operator lexeme.
  pub fn isOperator (T :*Tok) bool { return rules.isOperator(T.next_at(1)); }
  /// @descr Returns whether or not the next Lexeme in the buffer is a whitespace lexeme.
  pub fn isWhitespace (T:*Tok) bool { return rules.isWhitespace(T.next_at(1)); }
  /// @descr Returns whether or not the next Lexeme in the buffer is a dot lexeme.
  pub fn isDot (T:*Tok) bool { return rules.isDot(T.next_at(1)); }
  /// @descr Returns whether or not the next Lexeme in the buffer is a parenthesis, bracket or brace lexeme.
  pub fn isPar (T:*Tok) bool { return rules.isPar(T.next_at(1)); }
  /// @descr Returns whether or not the next Lexeme in the buffer is considered a special lexeme
  pub fn isSpecial (T:*Tok) bool { return rules.isSpecial(T.next_at(1)); }
  /// @descr Returns whether or not the next Lexeme in the buffer is considered a context change lexeme
  pub fn isContextChange (T:*Tok) bool { return rules.isContextChange(T.next_at(1)); }
}; //:: Tok.next

