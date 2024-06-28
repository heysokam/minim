//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview
//!  Contains the Tokenizer of the language.
//!  Its process will create a list of tokens,
//!  that will be used as the input for the Parser process.
//! @note
//!  A token consists of an ID and optional attribute values.
//!  The token ID is an abstract symbol representing a kind of lexical unit,
//!  (e.g: a particular keyword, a sequence of input characters denoting an identifier, etc)
//___________________________________________________________________________|
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const fail = zstd.fail;
const ByteBuffer = zstd.T.ByteBuffer;
// @deps minim.lex
const Lex       = @import("./lex.zig").Lex;
const LexemList = @import("./lex.zig").LexemList;
const Lx        = @import("./lex.zig").Lx;

//______________________________________
/// @descr Describes a Token.
/// @out From the {@link Tok} Tokenizer process.
/// @in For the {@link Par} Parser process.
const Tk = struct {
  id   :Tk.Id,
  val  :ByteBuffer,

  const Id = enum {
    ident,
    // Specials
    colon,        // :
    paren_L,      // (
    paren_R,      // )
    eq,           // =
    hash,         // #  ##  #[  ]#  ##[  ]##
    semicolon,    // ;
    quote_S,      // '  (single quote)
    quote_D,      // "  (double quote)
    quote_B,      // `  (backtick quote)
    brace_L,      // {
    brace_R,      // }
    bracket_L,    // [
    bracket_R,    // ]
    comma,        // ,
    bracketDot_L, // [.
    bracketDot_R, // .]
    braceDot_L,   // {.
    braceDot_R,   // .}
    parenDot_L,   // (.
    parenDot_R,   // .)
    bracketCol_L, // [:
    bracketCol_R, // :]
    // Whitespace
    space,        // ` `
    newline,      // \n
    // Keywords
    kw_proc,      // pr proc
    kw_func,      // fn func
    kw_return,    // return
    kw_cast,      // cast
    kw_operator,  // op operator
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
};
const TokenList = std.MultiArrayList(Tk);


/// @note
///  A pattern is a description of the form that the lexemes of a token may take.
///  In the case of a keyword as a token, a pattern is the sequence of characters that form the keyword.
///  For identifiers and other tokens, the pattern is a more complex structure that can be matched by many strings.
const Pattern = struct {
  const Map = std.StaticStringMap(Tk.Id);
  const Kw = Map.initComptime(.{
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

  /// @descr Valid Operator starter Characters
  /// =   +   -   *   /   <   >
  /// @   $   ~   &   %   |
  /// !   ?   ^   .   :   \
  const Op = Map.initComptime(.{ 
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
    .{ "%",  .op_perc   },
    .{ "|",  .op_pipe   },
    .{ "!",  .op_excl   },
    .{ "?",  .op_qmark  },
    .{ "^",  .op_hat    },
    .{ "\\", .op_bslash }, // Except inside strings
    }); // Valid Operator character starters
};

pub const Tok = struct {
  A    :std.mem.Allocator,
  pos  :u64,
  buf  :LexemList,
  res  :TokenList,

  /// @descr Returns the Lexeme located in the current position of the buffer
  pub fn lx(T:*Tok) Lx { return T.buf.get(T.pos); }

  pub fn create(L:*Lex) Tok {
    return Tok {
      .A   = L.A,
      .pos = 0,
      .buf = L.res,
      .res = TokenList{},
    };
  }

  pub fn destroy(T:*Tok) void {
    T.buf.deinit();
    T.res.deinit(T.A);
  }




  pub fn process(T:*Tok) !void {
    while (true) : (T.pos += 1) {
      if (T.pos == T.buf.len) return; // End of the input data
      const l = T.lx();
      switch (l) {
      'a'...'z', 'A'...'Z', '_', => try T.ident(),
      '0'...'9'                  => try T.number(),
      '*'                        => try T.star(),
      '(', ')'                   => try T.paren(),
      ':'                        => try T.colon(),
      '='                        => try T.eq(),
      ' '                        => try T.space(),
      '\n'                       => try T.newline(),
      else => |char| fail("Unknown first character '{c}' (0x{X})", .{char, char})
      }
    }
  }


};

