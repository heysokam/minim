//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @descr Describes a Token.
//! @out From the {@link Tok} Tokenizer process.
//! @in For the {@link Par} Parser process.
//______________________________________________|
pub const Tk = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
// @deps *Slate
const source = @import("../../lib/slate.zig").source;


/// @field The location of the string value of the Token in the source code.
loc  :source.Loc,
/// @field The unique identifier of the Token
id   :Tk.Id,


pub fn create_at (I : Tk.Id, start :source.Pos, end :source.Pos) Tk { return Tk.create(I, source.Loc{.start= start, .end= end}); }
pub fn create (I : Tk.Id, L :source.Loc) Tk { return Tk{.id= I, .loc= L}; }

pub const slice = struct {
  //______________________________________
  /// @descr Returns the string value of the Token located at the {@arg L.loc} of {@arg src}.
  /// @note Returns an empty string when {@arg T.loc} does not represent a valid location.
  /// @note Does not perform bounds check on {@arg src}. It will fail when the location is out of bounds.
  pub fn from (T :*const Tk, src :source.Code) source.Code { return T.loc.from(src); }
}; //:: Tk.slice
pub const from = slice.from;


//______________________________________
/// @descr {@link Tk.id} Valid kinds for Tokens
pub const Id = enum {
  // Base
  b_ident,
  b_number,
  // Specials
  sp_star,         // *  (not the operator)
  sp_colon,        // :
  sp_paren_L,      // (
  sp_paren_R,      // )
  sp_eq,           // =
  sp_hash,         // #  ##  #[  ]#  ##[  ]##
  sp_semicolon,    // ;
  sp_quote_S,      // '  (single quote)
  sp_quote_D,      // "  (double quote)
  sp_quote_B,      // `  (backtick quote)
  sp_brace_L,      // {
  sp_brace_R,      // }
  sp_bracket_L,    // [
  sp_bracket_R,    // ]
  sp_comma,        // ,
  sp_bracketDot_L, // [.
  sp_bracketDot_R, // .]
  sp_braceDot_L,   // {.
  sp_braceDot_R,   // .}
  sp_parenDot_L,   // (.
  sp_parenDot_R,   // .)
  sp_bracketCol_L, // [:
  sp_bracketCol_R, // :]
  // Whitespace
  wht_space,        // ` `
  wht_newline,      // \n
  // Keywords
  kw_proc,      // pr proc
  kw_func,      // fn func
  kw_return,    // return
  kw_cast,      // cast
  kw_operator,  // op operator
  kw_void,      // void
  kw_var,       // var
  kw_let,       // let
  kw_const,     // const
  kw_array,     // array
  kw_ptr,       // ptr
  // Operators: Specials
  op_star,      // Operators starting with *
  op_dot,       // Operators starting with .
  op_colon,     // Operators starting with :
  op_eq,        // `eq` and Operators starting with =
  // Operators: Keywords
  op_and,       // and &&
  op_or,        // or  ||
  op_not,       // not !
  op_xor,       // xor ^
  op_shl,       // shl <<
  op_shr,       // shr >>
  op_div,       // div /
  op_mod,       // mod %
  op_in,        // in
  op_notin,     // notin
  op_is,        // is
  op_isnot,     // isnot
  op_of,        // of
  op_as,        // as
  op_from,      // from
  // Operators: Standard
  op_plus,      // Operators starting with +
  op_min,       // Operators starting with -
  op_slash,     // Operators starting with /
  op_less,      // Operators starting with <
  op_more,      // Operators starting with >
  op_at,        // Operators starting with @
  op_dollar,    // Operators starting with $
  op_tilde,     // Operators starting with ~
  op_amp,       // Operators starting with &
  op_pcnt,      // Operators starting with %
  op_pipe,      // Operators starting with |
  op_excl,      // Operators starting with !
  op_qmark,     // Operators starting with ?
  op_hat,       // Operators starting with ^
  op_bslash,    // Operators starting with \

  pub fn format (tk :Tk.Id, comptime _:zstd.cstr, _:std.fmt.FormatOptions, writer :anytype) !void {
    try writer.print("{s}", .{@tagName(tk)});
  }
  };

//____________________________
/// @descr Describes a list of {@link Tk} Token objects
/// @out From the Tokenizer process
/// @in To the Parser process
pub const List = zstd.List(Tk);
