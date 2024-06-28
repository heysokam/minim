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
  /// @field {@link Tk.id} The Id of the Token
  id   :Tk.Id,
  /// @field {@link Tk.val} The string value of the Token
  val  :ByteBuffer,

  /// @descr {@link Tk.id} Valid kinds for Tokens
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
//____________________________
/// @descr Describes a list of {@link Tk} Token objects
/// @out From the Tokenizer process
/// @in To the Parser process
const TokenList = std.MultiArrayList(Tk);


//______________________________________
/// @note
///  A pattern is a description of the form that the lexemes of a token may take.
///  In the case of a keyword as a token, a pattern is the sequence of characters that form the keyword.
///  For identifiers and other tokens, the pattern is a more complex structure that can be matched by many strings.
const Pattern = struct {
  /// @descr List of (key,val) pairs of Tokens, mapping their string representation with their Tk.Id
  const Map = std.StaticStringMap(Tk.Id);
  /// @descr List of (key,val) pairs of Keyword Tokens, mapping their string representation with their Tk.Id
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

  //______________________________________
  /// @descr List of (key,val) pairs of Keyword Tokens, mapping their string representation with their Tk.Id
  /// @note
  ///  Valid Operator starter Characters
  ///  =   +   -   *   /   <   >
  ///  @   $   ~   &   %   |
  ///  !   ?   ^   .   :   \
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

/// @descr
///  Describes a Tokenizer process and its data.
///  @in A sequence of Lexemes and their containing characters  (Id,cstr)
///  @out The list of Tokens that those Lexemes represent  (Id,cstr)
pub const Tok = struct {
  A    :std.mem.Allocator,
  pos  :u64,
  buf  :LexemList,
  res  :TokenList,

  //__________________________
  /// @descr Returns the Lexeme located in the current position of the buffer
  pub fn lx(T:*Tok) Lx { return T.buf.get(T.pos); }

  //__________________________
  /// @descr Creates a new Tokenizer object from the given {@arg L} Lexer contents.
  pub fn create(L:*Lex) Tok {
    return Tok {
      .A   = L.A,
      .pos = 0,
      .buf = L.res,
      .res = TokenList{},
    };
  }

  //__________________________
  /// @descr Frees all resources owned by the Tokenizer object.
  pub fn destroy(T:*Tok) void {
    T.buf.deinit();
    T.res.deinit(T.A);
  }



  //__________________________
  /// @descr Processes an identifier Lexeme into its Token representation, and adds it to the {@link T.res} result.
  pub fn ident(T:*Tok) !void { _ = T; }
  //__________________________
  /// @descr Processes a number Lexeme into its Token representation, and adds it to the {@link T.res} result.
  pub fn number(T:*Tok) !void { _ = T; }
  //__________________________
  /// @descr Processes a Lexeme starting with `:` into its Token representation, and adds it to the {@link T.res} result.
  pub fn colon(T:*Tok) !void { _ = T; }
  //__________________________
  /// @descr Processes a Lexeme starting with `=` into its Token representation, and adds it to the {@link T.res} result.
  pub fn eq(T:*Tok) !void { _ = T; }
  //__________________________
  /// @descr Processes a Lexeme starting with `*` into its Token representation, and adds it to the {@link T.res} result.
  pub fn star(T:*Tok) !void { _ = T; }
  //__________________________
  /// @descr Processes a Lexeme starting with `(` or `)` into its Token representation, and adds it to the {@link T.res} result.
  pub fn paren(T:*Tok) !void { _ = T; }
  //__________________________
  /// @descr Processes a whitespace Lexeme into its Token representation, and adds it to the {@link T.res} result.
  pub fn space(T:*Tok) !void { _ = T; }
  //__________________________
  /// @descr Processes a newline Lexeme into its Token representation, and adds it to the {@link T.res} result.
  pub fn newline(T:*Tok) !void { _ = T; }


  //__________________________
  /// @descr Tokenizer Entry Point
  pub fn process(T:*Tok) !void {
    while (true) : (T.pos += 1) {
      if (T.pos == T.buf.len) return; // End of the input data
      const l = T.lx().id;
      switch (l) {
      .ident             => try T.ident(),
      .number            => try T.number(),
      .colon             => try T.colon(),
      .eq                => try T.eq(),
      .star              => try T.star(),
      .paren_L, .paren_R => try T.paren(),
      .space             => try T.space(),
      .newline           => try T.newline(),
      else => |lexem| fail("Unknown first lexeme '{s}'", .{@tagName(lexem)})
      }
    // .hash,      // #
    // .semicolon, // ;
    // .quote_S,   // '  (single quote)
    // .quote_D,   // "  (double quote)
    // .quote_B,   // `  (backtick quote)
    // .brace_L,   // {
    // .brace_R,   // }
    // .bracket_L, // [
    // .bracket_R, // ]
    // .dot,       // .
    // .comma,     // ,
    // Operators
    // .plus,      // +
    // .min,       // -
    // .slash,     // /
    // .less,      // <
    // .more,      // >
    // .at,        // @
    // .dollar,    // $
    // .tilde,     // ~
    // .amp,       // &
    // .pcnt,      // %
    // .pipe,      // |
    // .excl,      // !
    // .qmark,     // ?
    // .hat,       // ^
    // .bslash,    // \
    // Whitespace
    // .tab,       // \t
    // .ret,       // \r
    }
  }
};

