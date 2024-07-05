//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Describes generic rules for the language.
//__________________________________________________________|
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const cstr = zstd.cstr;
const ByteBuffer = zstd.ByteBuffer;
// @deps *Slate
const slate = @import("../lib/slate.zig");

pub const Lang  = enum { Zig, C };
pub const Value = slate.Value;
pub const Lx    = slate.Lx;


//______________________________________
/// @descr Describes a Token.
/// @out From the {@link Tok} Tokenizer process.
/// @in For the {@link Par} Parser process.
pub const Tk = struct {
  /// @field {@link Tk.id} The Id of the Token
  id   :Tk.Id,
  /// @field {@link Tk.val} The string value of the Token
  val  :ByteBuffer,

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
    };

  //____________________________
  /// @descr Describes a list of {@link Tk} Token objects
  /// @out From the Tokenizer process
  /// @in To the Parser process
  pub const List = zstd.List(Tk);
};


//______________________________________
/// @note
///  A pattern is a description of the form that the lexemes of a token may take.
///  In the case of a keyword as a token, a pattern is the sequence of characters that form the keyword.
///  For identifiers and other tokens, the pattern is a more complex structure that can be matched by many strings.
pub const Pattern = struct {
  /// @descr List of (key,val) pairs of Tokens, mapping their string representation with their Tk.Id
  const Map = zstd.Map(Tk.Id);
  /// @descr List of (key,val) pairs of Keyword Tokens, mapping their string representation with their Tk.Id
  pub const Kw = Map.initComptime(.{
    // Keywords
    .{ "fn",       .kw_func     },
    .{ "func",     .kw_func     },
    .{ "pr",       .kw_proc     },
    .{ "proc",     .kw_proc     },
    .{ "return",   .kw_return   },
    .{ "cast",     .kw_cast     },
    .{ "op",       .kw_operator },
    .{ "operator", .kw_operator },
    // Operator Keywords
    .{ "eq",       .op_eq       }, // Same as ==
    .{ "and",      .op_and      }, // Same as &&
    .{ "or",       .op_or       }, // Same as ||
    .{ "not",      .op_not      }, // Same as !
    .{ "xor",      .op_xor      }, // Same as ^
    .{ "shl",      .op_shl      }, // Same as <<
    .{ "shr",      .op_shr      }, // Same as >>
    .{ "div",      .op_div      }, // Same as / for ints
    .{ "mod",      .op_mod      }, // Same as %
    .{ "in",       .op_in       }, // Same as B.contains(A)
    .{ "notin",    .op_notin    }, // Same as !B.contains(A)
    .{ "is",       .op_is       }, // Same as typeof(A) == typeof(B)
    .{ "isnot",    .op_isnot    }, // Same as typeof(A) != typeof(B)
    .{ "of",       .op_of       },
    .{ "as",       .op_as       }, // Same as casting.  A as B  ->  cast[B](A)
    .{ "from",     .op_from     },
    }); // << Kw = ...

  //______________________________________
  /// @descr List of (key,val) pairs of Keyword Tokens, mapping their string representation with their Tk.Id
  /// @note
  ///  Valid Operator starter Characters
  ///  =   +   -   *   /   <   >
  ///  @   $   ~   &   %   |
  ///  !   ?   ^   .   :   \
  pub const Op = Map.initComptime(.{
    // Specials
    .{ ":",  .op_colon  }, // Except :
    .{ "=",  .op_eq     }, // Except =
    .{ "*",  .op_star   }, // Except *:
    .{ ".",  .op_dot    }, // Except .
    // Standard
    .{ "+",  .op_plus   },
    .{ "-",  .op_min    },
    .{ "/",  .op_slash  },
    .{ "<",  .op_less   },
    .{ ">",  .op_more   },
    .{ "@",  .op_at     }, // Except @. Same as casting.  A@B  ->   cast[B](A)
    .{ "$",  .op_dollar },
    .{ "~",  .op_tilde  },
    .{ "&",  .op_amp    },
    .{ "%",  .op_pcnt   },
    .{ "|",  .op_pipe   },
    .{ "!",  .op_excl   },
    .{ "?",  .op_qmark  },
    .{ "^",  .op_hat    },
    .{ "\\", .op_bslash }, // Except inside strings
    }); // Valid Operator character starters
};

