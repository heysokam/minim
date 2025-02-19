//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Tokenizer: Report Process Status
//_______________________________________________|
// @deps minim
const Tok = @import("../tok.zig");

//____________________________
/// @descr Reports the contents of the {@arg T} tokenizer object to CLI
pub fn report (T:*Tok) void {
  Tok.prnt("--- minim.Tokenizer ---\n", .{});
  for (T.res.items(.id), T.res.items(.loc)) |id, loc| {
    Tok.prnt("{s} : {s}\n", .{@tagName(id), loc.from(T.src)});
  }
  Tok.prnt("-----------------------\n", .{});
} //:: M.Tok.report

// TODO: Tokenizer Autogen
// var T = try M.Tok.create(&L);
// defer T.destroy();
// try T.process();
// for (T.res.items(.id), T.res.items(.loc), 0..) |tk, loc, id| std.debug.print("minim.Tk{{.id= .{s}, .loc= slate.source.Loc{{.start= {d: >3}, .end= {d: >3} }}}}, // {d: >2}: `{s}`\n", .{@tagName(tk), loc.start, loc.end, id, loc.from(code)});

