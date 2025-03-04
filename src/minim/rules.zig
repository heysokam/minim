//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Describes generic rules for the language.
//__________________________________________________________|
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const Tk   = @import("./tok/token.zig");
// @deps *Slate
const Lx = @import("../lib/slate.zig").Lx;


//______________________________________
/// @descr Tags for the languages that Minim can understand/target
pub const Lang = enum { none, Minim, Zig, C, };


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
    .{ "mut",      .kw_mut      },
    .{ "var",      .kw_var      },
    .{ "let",      .kw_let      },
    .{ "const",    .kw_const    },
    .{ "array",    .kw_array    },
    .{ "ptr",      .kw_ptr      },
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
  /// @descr List of (key,val) pairs of Operator Tokens, mapping their string representation with their Tk.Id
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

  //______________________________________
  /// @descr List of (key,val) pairs of Whitespace Tokens, mapping their string representation with their Tk.Id
  pub const Ws = Map.initComptime(.{
    .{ " ",  .wht_space   },      // ` `
    .{ "\n", .wht_newline },      // \n
    }); // Valid Whitespace characters

  //______________________________________
  /// @descr List of (key,val) pairs of Parenthesis Tokens, mapping their string representation with their Tk.Id
  pub const Par = Map.initComptime(.{
    // Standard
    .{ "(",  .sp_paren_L      }, // (
    .{ ")",  .sp_paren_R      }, // )
    .{ "{",  .sp_brace_L      }, // {
    .{ "}",  .sp_brace_R      }, // }
    .{ "[",  .sp_bracket_L    }, // [
    .{ "]",  .sp_bracket_R    }, // ]
    // Dot Paren
    .{ "[.", .sp_bracketDot_L }, // [.
    .{ ".]", .sp_bracketDot_R }, // .]
    .{ "{.", .sp_braceDot_L   }, // {.
    .{ ".}", .sp_braceDot_R   }, // .}
    .{ "(.", .sp_parenDot_L   }, // (.
    .{ ".)", .sp_parenDot_R   }, // .)
    // Dot Colon
    .{ "[:", .sp_bracketCol_L }, // [:
    .{ ":]", .sp_bracketCol_R }, // :]
    }); // Valid Whitespace characters
};


//____________________________________
// @section Lexeme Kinds
//____________________________
pub const LxKinds = struct {
  const Map = std.EnumSet(Lx.Id);
  /// @ref {@link rules.Pattern.Op}
  pub const Operator = Map.initMany(&.{
    // Operators
    .colon,     // :
    .eq,        // =
    .star,      // *
    .dot,       // .
    .plus,      // +
    .dash,      // -
    .slash_F,   // /
    .less,      // <
    .more,      // >
    .at,        // @
    .dollar,    // $
    .tilde,     // ~
    .amp,       // &
    .pcnt,      // %
    .pipe,      // |
    .excl,      // !
    .qmark,     // ?
    .hat,       // ^
    .slash_B,   // \
    }); //:: rules.LxKinds.Operator
  /// @ref {@link rules.Pattern.Ws}
  pub const Whitespace = Map.initMany(&.{
    // Whitespace
    .space,     // ` `
    .newline,   // \n
    .tab,       // \t
    .ret,       // \r
    }); //:: rules.LxKinds.Whitespace
  /// @ref {@link rules.Pattern.Paren}
  pub const Paren = Map.initMany(&.{
    .paren_L,   // (
    .paren_R,   // )
    .brace_L,   // {
    .brace_R,   // }
    .bracket_L, // [
    .bracket_R, // ]
    }); //:: rules.LxKinds.Paren
};


/// @descr Returns whether or not {@arg L} is an operator lexeme.
pub fn isOperator (L:Lx) bool { return LxKinds.Operator.contains(L.id); }
/// @descr Returns whether or not {@arg L} is a whitespace lexeme.
pub fn isWhitespace (L:Lx) bool { return LxKinds.Whitespace.contains(L.id); }
/// @descr Returns whether or not {@arg L} is a parenthesis, bracket or brace lexeme.
pub fn isPar (L:Lx) bool { return LxKinds.Paren.contains(L.id); }
/// @descr Returns whether or not {@arg L} is a dot lexeme.
pub fn isDot (L:Lx) bool { return L.id == Lx.Id.dot; }

