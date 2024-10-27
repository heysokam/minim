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


//______________________________________
/// @descr Tags for the languages that Minim can understand/target
pub const Lang  = enum { Minim, Zig, C, };


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

