//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Parser: State Checks
//_____________________________________|
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
const cstr = zstd.cstr;
// @deps minim
const Par = @import("../par.zig").Par;
const Tok = @import("../tok.zig").Tok;
const Tk  = Tok.Tk;


//____________________________
/// @descr Triggers an error if {@arg id} isn't the current Token in the {@arg P} Parser.
pub fn expect (P:*Par, id :Tk.Id, kind :cstr) void {
  if (P.tk().id != id) P.fail("Unexpected Token for {s}. Expected '{s}', but found:  {d}:'{s}':{s}",
    .{kind, @tagName(id), P.pos, @tagName(P.tk().id), P.tk().from(P.src)});
} //:: Par.check.expect

//____________________________
/// @descr Triggers an error if any of the {@arg ids} are not the current Token in the {@arg P} Parser.
pub fn expectAny (P:*Par, ids :[]const Tk.Id, kind :cstr) void {
  for (ids) | id | if (P.tk().id == id) { return; };
  P.fail("Unexpected Token for {s}. Expected '{any}', but found:  {d}:'{s}'", .{kind, ids, P.pos, @tagName(P.tk().id)});
} //:: Par.check.expectAny

//____________________________
/// @descr Returns whether or not the {@arg P} parser is at its last position or not
pub fn last (P:*Par) bool { return P.pos == P.buf.len-1; }

//____________________________
/// @descr Returns whether or not the {@arg P} parser is at the end or not
pub fn end (P:*Par) bool { return P.pos >= P.buf.len-1; }

