//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Tokenizer Contents Checks
//___________________________________________|
const find = @This();
// @deps std
const std = @import("std");
// @deps *Slate
const slate = @import("../../lib/slate.zig");
const Lx    = slate.Lx;
// @deps minim
const Tok   = @import("../tok.zig");
const rules = @import("../rules.zig");


//______________________________________
/// @descr Returns the position ID where searching loops should end at.
fn end (T :*Tok) usize { return T.buf.len -| T.pos; }


//______________________________________
pub const first = struct {
  /// @descr Returns whether or not there is a Lexeme ahead in the buffer that should be considered an identifier lexeme
  pub fn ident (T:*Tok) bool {
    for (0..find.end(T)) |id| if (rules.isIdentifier(T.next_at(id))) return true;
    return false;
  }
  /// @descr Returns whether or not there is a Lexeme ahead in the buffer that should be considered an context change lexeme
  pub fn contextChange (T:*Tok) bool {
    for (0..find.end(T)) |id| if (rules.isContextChange(T.next_at(id))) return true;
    return false;
  }
};

