//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
const ident = @This();
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
const cstr = zstd.cstr;
// @deps minim
const Tok    = @import("../tok.zig").Tok;
const Tk     = Tok.Tk;
const Par    = @import("../par.zig").Par;
const Ast    = @import("../ast.zig").Ast;
const pragma = @import("./pragma.zig");


//__________________________
/// @descr
///  Creates an Ident object from the current Token, and returns it.
///  Will fail if the current Token is not an Identifier
pub fn name (P:*Par) Ast.Ident {
  P.expect(Tk.Id.b_ident, "Ident");
  return Ast.Ident{.name= P.tk().val.items};
}

pub const typ = struct {
  pub const name = struct {
    fn end (P:*Par) bool {
      const t = P.tk().id;
      return t == .sp_eq or t == .sp_paren_R or t == .sp_semicolon;
    } //:: M.Par.ident.name.end

    //__________________________
    /// @descr Starts parsing an Ident.Type.name from the current Token, and returns the result.
    pub fn parse (P:*Par) !cstr {
      var result = zstd.str.init(P.A);
      while (P.tk().id == Tk.Id.b_ident) {
        try result.appendSlice(P.tk().val.items);
        P.move(1);
        P.skip(Tk.Id.wht_space);  // TODO: ?Respect formatting inside multi-word typenames (between words)?
        if (ident.typ.name.end(P)) { break; }
        try result.append(' ');
      }
      return result.items;
    } //:: M.Par.ident.name.parse
  }; //:: M.Par.ident.name

  //__________________________
  /// @descr
  ///  Starts parsing an Ident.Type object from the current Token, and returns the result.
  ///  Will fail if the next few tokens do not not match the Ident.Type pattern
  pub fn parse (P:*Par) !Ast.Type {
    P.expectAny(&.{Tk.Id.kw_array, Tk.Id.kw_ptr, Tk.Id.b_ident}, "Ident.Type");
    // ptr T
    const ptr = P.tk().id == .kw_ptr;
    if (ptr) { P.move(1); P.ind(); }
    // array[N, T]
    if (P.tk().id == .kw_array) {
      P.move(1);
      P.ind();
      // Start:  [
      P.expect(Tk.Id.sp_bracket_L, "Ident.Type.array");
      P.move(1);
      P.ind();
      // Items Count:  number, ident or _
      P.expectAny(&.{Tk.Id.b_number, Tk.Id.b_ident}, "Ident.Type.array");
      const count = P.tk().val.items;
      P.move(1);
      P.ind();
      // Count-Type Separator:  ,
      P.expect(Tk.Id.sp_comma, "Ident.Type.array");
      P.move(1);
      P.ind();
      // Type and Pragma
      var array = Ast.Type.Array{ // TODO: Static Typechecking
        .count  = count,
        .ptr    = ptr,
        .type   = try ident.typ.parse(P),
        .pragma = try pragma.parse(P),
        }; //:: array
      P.ind();
      // End:  ]
      P.expect(Tk.Id.sp_bracket_R, "Ident.Type.array");
      P.move(1);
      return Ast.Type{.array= &array};
    }
    return Ast.Type{.any= Ast.Type.Any{ // TODO: Static Typechecking
      .name   = try ident.typ.name.parse(P),
      .mut    = true,  // FIX: How to parse mutability correctly for all type cases ??
      .ptr    = ptr,
      .pragma = try pragma.parse(P),
      }};
  }
}; //:: M.Par.ident.typ

