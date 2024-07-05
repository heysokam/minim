const std  = @import("std");
const zstd  = @import("../../lib/zstd.zig");

const todo = struct {
  /// @descr {@link Tk.id} Valid kinds for Tokens
  //pub const Id = m(m(m(m( // Merge (m) all language enums into one
  //  Base, Wht), Sp), Kw), Op);
  pub const Id = union(enum) {
    B    :Base,
    Wht  :Whitespace,
    Sp   :Special,
    Kw   :Keyword,
    Op   :Operator,
  };

  pub const Base = enum {
    ident,   // Identifiers (aka names)
    number,  // Any int/uint/float/etc
    string,  // Any string or character
  };

  pub const Whitespace = enum {
    space,        // ` `
    newline,      // \n
  };

  pub const Special = enum {
    star,         // *  (not the operator)
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
  };


  pub const Keyword = enum {
    // Keywords
    proc,      // pr proc
    func,      // fn func
    Return,    // return
    cast,      // cast
    operator,  // op operator
    void,      // void
    // Operators: Keywords
    eq,        // eq
    And,       // and &&
    Or,        // or  ||
    not,       // not !
    xor,       // xor ^
    shl,       // shl <<
    shr,       // shr >>
    div,       // div /
    mod,       // mod %
    in,        // in
    notin,     // notin
    is,        // is
    isnot,     // isnot
    of,        // of
    as,        // as
    from,      // from
  };

  pub const Operator = enum {
    // Operators: Specials
    star,      // Operators starting with *
    dot,       // Operators starting with .
    colon,     // Operators starting with :
    eq,        // `eq` and Operators starting with =
    // Operators: Standard
    plus,      // Operators starting with +
    min,       // Operators starting with -
    slash,     // Operators starting with /
    less,      // Operators starting with <
    more,      // Operators starting with >
    at,        // Operators starting with @
    dollar,    // Operators starting with $
    tilde,     // Operators starting with ~
    amp,       // Operators starting with &
    pcnt,      // Operators starting with %
    pipe,      // Operators starting with |
    excl,      // Operators starting with !
    qmark,     // Operators starting with ?
    hat,       // Operators starting with ^
    bslash,    // Operators starting with \
  };
};

pub const Pattern = struct {
  /// @descr List of (key,val) Tokens, mapping their string representation with their Tk.Id
  const Map = zstd.Map(todo.Id);
  /// @descr List of (key,val) pairs of Keyword Tokens, mapping their string representation with their Tk.Id
  pub const Kw = Map.initComptime(.{
    // Keywords
    .{ "fn",       todo.Id{.Kw=.func     }},
    .{ "func",     todo.Id{.Kw=.func     }},
    .{ "pr",       todo.Id{.Kw=.proc     }},
    .{ "proc",     todo.Id{.Kw=.proc     }},
    .{ "return",   todo.Id{.Kw=.Return   }},
    .{ "cast",     todo.Id{.Kw=.cast     }},
    .{ "op",       todo.Id{.Kw=.operator }},
    .{ "operator", todo.Id{.Kw=.operator }},
    // Operator Keywords
    .{ "eq",       todo.Id{.Kw=.eq       }}, // Same as ==
    .{ "and",      todo.Id{.Kw=.And      }}, // Same as &&
    .{ "or",       todo.Id{.Kw=.Or       }}, // Same as ||
    .{ "not",      todo.Id{.Kw=.not      }}, // Same as !
    .{ "xor",      todo.Id{.Kw=.xor      }}, // Same as ^
    .{ "shl",      todo.Id{.Kw=.shl      }}, // Same as <<
    .{ "shr",      todo.Id{.Kw=.shr      }}, // Same as >>
    .{ "div",      todo.Id{.Kw=.div      }}, // Same as / for ints
    .{ "mod",      todo.Id{.Kw=.mod      }}, // Same as %
    .{ "in",       todo.Id{.Kw=.in       }}, // Same as B.contains(A)
    .{ "notin",    todo.Id{.Kw=.notin    }}, // Same as !B.contains(A)
    .{ "is",       todo.Id{.Kw=.is       }}, // Same as typeof(A) == typeof(B)
    .{ "isnot",    todo.Id{.Kw=.isnot    }}, // Same as typeof(A) != typeof(B)
    .{ "of",       todo.Id{.Kw=.of       }},
    .{ "as",       todo.Id{.Kw=.as       }}, // Same as casting.  A as B  ->  cast[B](A)
    .{ "from",     todo.Id{.Kw=.from     }},
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
    .{ ":",  todo.Id{.Op=.colon  }}, // Except :
    .{ "=",  todo.Id{.Op=.eq     }}, // Except =
    .{ "*",  todo.Id{.Op=.star   }}, // Except *:
    .{ ".",  todo.Id{.Op=.dot    }}, // Except .
    // Standard
    .{ "+",  todo.Id{.Op=.plus   }},
    .{ "-",  todo.Id{.Op=.min    }},
    .{ "/",  todo.Id{.Op=.slash  }},
    .{ "<",  todo.Id{.Op=.less   }},
    .{ ">",  todo.Id{.Op=.more   }},
    .{ "@",  todo.Id{.Op=.at     }}, // Except @. Same as casting.  A@B  ->   cast[B](A)
    .{ "$",  todo.Id{.Op=.dollar }},
    .{ "~",  todo.Id{.Op=.tilde  }},
    .{ "&",  todo.Id{.Op=.amp    }},
    .{ "%",  todo.Id{.Op=.pcnt   }},
    .{ "|",  todo.Id{.Op=.pipe   }},
    .{ "!",  todo.Id{.Op=.excl   }},
    .{ "?",  todo.Id{.Op=.qmark  }},
    .{ "^",  todo.Id{.Op=.hat    }},
    .{ "\\", todo.Id{.Op=.bslash }}, // Except inside strings
    }); // Valid Operator character starters
};


test "1234" {
  std.debug.print("{any}\n", .{todo.Id});
  std.debug.print("{any}\n", .{Pattern.Kw.values()});
  std.debug.print("{any}\n", .{Pattern.Op.values()});
}



const bkp = struct {
  const OneBigEnum = struct {
    /// @descr {@link Tk.id} Valid kinds for Tokens
    pub const All = enum {
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
      .{ "%",  .op_perc   },
      .{ "|",  .op_pipe   },
      .{ "!",  .op_excl   },
      .{ "?",  .op_qmark  },
      .{ "^",  .op_hat    },
      .{ "\\", .op_bslash }, // Except inside strings
      }); // Valid Operator character starters
  };
};

