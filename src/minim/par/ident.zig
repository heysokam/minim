//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
const ident = @This();
const std = @import("std");
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


pub const @"type" = struct {
  pub const qualifier = struct {
    // FIX: Parse Type Qualifiers separately
    // array[N,T] array[N,T,S]
    // slice[T] slice[T,S]
    // proc name [T](....)
    // cast[T](....)
  };

  pub const name = struct {
    fn end (P:*Par) bool {
      const multiword = P.tk().id == .wht_space and P.next_at(1).id == Tk.Id.b_ident; // @?maybe? Support for line breaks inside multiword types ??
      return switch (P.tk().id) {
        .sp_eq, .sp_paren_R, .sp_semicolon => true,
        else => false,
      } or !multiword;
    } //:: par/ident.type.name.end

    //__________________________
    /// @descr Starts parsing an Ident.Type.name from the current Token, and returns the result.
    pub fn parse (P:*Par) source.Loc {
      var result = source.Loc{};
      while (P.tk().id == Tk.Id.b_ident) {
        if (result.none()) { result = P.tk().loc; }
        else               { result.add(P.tk().loc); }
        P.move(1);
        if (ident.type.name.end(P)) { break; }
        if (P.tk().id == Tk.Id.wht_space) {
          result.add(P.tk().loc);
          P.move(1);
        }
      }
      return result;
    } //:: par/ident.type.name.parse
  }; //:: par/ident.type.name

  //______________________________________
  /// @descr
  ///  Starts parsing an Ident.Type.Array object from the current Token, and returns the position of the result.
  ///  Will fail if the next few tokens do not not match the Ident.Type.Array pattern
  fn array (P:*Par, is :struct {
      mut :bool, ptr :bool, opt :bool
    }) anyerror!Ast.Data.Store.Pos {
    const isSlice = P.tk().id == .kw_slice;
    P.move(1);
    P.ind();
    // FIX: Should send to ident.type.qualifier.parse(....)
    // Start:  [
    P.expect(Tk.Id.sp_bracket_L, "Ident.Type.array");
    P.move(1);
    P.ind();
    var count :?source.Loc= null;
    if (!isSlice) {
      // Items Count:  number, ident or _
      P.expectAny(&.{Tk.Id.b_number, Tk.Id.b_ident}, "Ident.Type.array");
      count = P.tk().loc;
      P.move(1);
      P.ind();
      // Count-Type Separator:  ,
      P.expect(Tk.Id.sp_comma, "Ident.Type.array");
      P.move(1);
      P.ind();
    }
    // Type and Pragma   // TODO: Static Typechecking
    var result = Ast.Type.Array.create(try ident.type.parse(P, true));
    result.array.count  = count;
    result.array.mut    = if (isSlice) is.mut else true;
    result.array.ptr    = is.ptr;
    result.array.opt    = is.opt;
    result.array.pragma = try pragma.parse(P);
    // Add the result to the Ast.Extras list
    const pos = try P.res.add_type(result);
    P.ind();
    // End:  ]
    P.expect(Tk.Id.sp_bracket_R, "Ident.Type.array");
    P.move(1);
    return pos;
  }

  //______________________________________
  /// @descr
  ///  Starts parsing an Ident.Type object from the current Token, and returns the position of the result.
  ///  Will fail if the next few tokens do not not match the Ident.Type pattern
  pub fn parse (P:*Par, isMut :bool) !Ast.Data.Store.Pos {
    P.expectAny(&.{
      Tk.Id.kw_array, Tk.Id.kw_slice,
      Tk.Id.kw_ptr, Tk.Id.sp_question,
      Tk.Id.b_ident}, "Ident.Type");
    // ?T
    const opt = P.tk().id == .sp_question;
    if (opt) { P.move(1); P.ind(); }
    // ptr T
    const ptr = P.tk().id == .kw_ptr;
    if (ptr) { P.move(1); P.ind(); }
    // array[N,T] slice[T]
    if (P.tk().id == .kw_array or P.tk().id == .kw_slice) return ident.type.array(P, .{.mut=isMut, .ptr=ptr, .opt=opt});
    // other cases
    var result = Ast.Type{.any= Ast.Type.Any{ // TODO: Static Typechecking
      .name    = .{},
      .mut     = isMut,
      .ptr     = ptr,
      .opt     = opt,
      .pragma  = .None,
      }};
    result.any.name = ident.type.name.parse(P);
    P.ind();
    result.any.pragma = try pragma.parse(P);
    var dummyPragmas = @import("slate").Pragma.List.create(P.A);
    defer dummyPragmas.destroy();
    const hasReadonly = (P.res.data.pragmas.at(result.any.pragma) orelse dummyPragmas).has(.readonly);
    if (ptr) result.any.mut = !hasReadonly;
    return P.res.add_type(result);
  } //:: par/ident.type.parse
}; //:: par/ident.type

