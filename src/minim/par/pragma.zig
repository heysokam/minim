//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
const pragma = @This();
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
// @deps minim
const Tok    = @import("../tok.zig").Tok;
const Tk     = Tok.Tk;
const Par    = @import("../par.zig").Par;
const Ast    = @import("../ast.zig").Ast;


//____________________________
/// @descr Triggers an error if {@arg id} isn't the current Token in the {@arg P} Parser.
pub fn expect (P:*Par, id :Tk.Id) void { P.expect(id, "Pragma"); }

//____________________________
pub fn parse (P:*Par) !?Ast.Pragma.List {
  if (P.tk().id != Tk.Id.sp_braceDot_L) return null;
  pragma.expect(P, Tk.Id.sp_braceDot_L);
  P.move(1);
  P.ind();
  var result = Ast.Pragma.List.create(P.A);
  P.ind();
  pragma.expect(P, Tk.Id.b_ident);
  try result.incl(Ast.Pragma.new(P.tk().val.items));
  P.move(1);
  P.ind();
  pragma.expect(P, Tk.Id.sp_braceDot_R);
  P.move(1);
  return result;
}

