//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
const ident = @This();
// @deps *Slate
const source = @import("../../lib/slate.zig").source;
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
  return Ast.Ident{.name= P.tk().loc};
} //:: par/ident.name


pub const typ = struct {
  pub const name = struct {
    fn end (P:*Par) bool {
      return switch (P.tk().id) {
        .sp_eq, .sp_paren_R, .sp_semicolon => true,
        else => false,
      };
    } //:: par/ident.typ.name.end

    //__________________________
    /// @descr Starts parsing an Ident.Type.name from the current Token, and returns the result.
    pub fn parse (P:*Par) source.Loc {
      var result = source.Loc{};
      while (P.tk().id == Tk.Id.b_ident) {
        if (result.none()) { result = P.tk().loc; }
        else               { result.add(P.tk().loc); }
        P.move(1);
        if (ident.typ.name.end(P)) { break; }
        if (P.next_at(1).id == Tk.Id.wht_space) {
          result.add(P.tk().loc);
          P.move(1);
        }
      }
      return result;
    } //:: par/ident.typ.name.parse
  }; //:: par/ident.typ.name

  //______________________________________
  /// @descr
  ///  Starts parsing an Ident.Type object from the current Token, and returns the Id of the result.
  ///  Will fail if the next few tokens do not not match the Ident.Type pattern
  pub fn parse (P:*Par) !Ast.Extras.List.Pos {
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
      const count = P.tk().loc;
      P.move(1);
      P.ind();
      // Count-Type Separator:  ,
      P.expect(Tk.Id.sp_comma, "Ident.Type.array");
      P.move(1);
      P.ind();
      // Type and Pragma
      var arr = Ast.Type.Array.create(try ident.typ.parse(P)); // TODO: Static Typechecking
      arr.array.count  = count;
      arr.array.ptr    = ptr;
      arr.array.pragma = try pragma.parse(P);
      // Add the result to the Ast.Extras list
      const result = try P.res.add_type(arr);
      P.ind();
      // End:  ]
      P.expect(Tk.Id.sp_bracket_R, "Ident.Type.array");
      P.move(1);
      return result;
    }
    return P.res.add_type(Ast.Type{.any= Ast.Type.Any{ // TODO: Static Typechecking
      .name   = ident.typ.name.parse(P),
      .mut    = true,  // FIX: How to parse mutability correctly for all type cases ??
      .ptr    = ptr,
      .pragma = try pragma.parse(P),
      }});
  } //:: par/ident.typ.parse
}; //:: par/ident.typ
