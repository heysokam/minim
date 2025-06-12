//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
const pragma = @This();
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
// @deps minim
const Tok = @import("../tok.zig").Tok;
const Tk  = Tok.Tk;
const Par = @import("../par.zig").Par;
const Ast = @import("../ast.zig").Ast;


//____________________________
/// @descr Triggers an error if {@arg id} isn't the current Token in the {@arg P} Parser.
pub fn expect (P:*Par, id :Tk.Id) void { P.expect(id, "Pragma"); }

//____________________________
pub fn parse (P:*Par) !Ast.Pragma.Store.Pos {
  if (P.tk().id != Tk.Id.sp_braceDot_L) return .None;
  pragma.expect(P, Tk.Id.sp_braceDot_L);
  P.move(1);
  P.ind(.any());
  var result = Ast.Pragma.List.create(P.A);
  // FIX: Multi-pragma Support
  pragma.expect(P, Tk.Id.b_ident);
  try result.incl(Ast.Pragma.from(P.tk().from(P.src)));
  P.move(1);
  P.ind(.any());
  pragma.expect(P, Tk.Id.sp_braceDot_R);
  P.move(1);
  return P.res.add_pragmas(result);
} //:: Par.pragma.parse

