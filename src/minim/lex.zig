//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview
//!  Contains the Lexer of the language.
//!  Its process will create a list of lexemes,
//!  that will be used as the input for the Tokenizer process.
//! @note
//!  A lexeme is a sequence of characters in the source program
//!  that matches the pattern for a token
//!  and is identified by the lexical analyzer as an instance of that token.
//___________________________________________________________________________|
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const fail = zstd.fail;
const ByteBuffer = zstd.T.ByteBuffer;
// @deps minim.lex
pub const Ch = @import("./lex/char.zig");


//______________________________________
/// @descr Describes a Lexeme.
/// @out From the {@link Lex} Lexer process.
/// @in For the {@link Tok} Tokenizer process.
pub const Lx = struct {
  id   :Id,
  val  :ByteBuffer,

  const Id = enum {
    ident,
    number,
    colon,     // :
    eq,        // =
    star,      // *
    paren_L,   // (
    paren_R,   // )
    hash,      // #
    semicolon, // ;
    quote_S,   // '  (single quote)
    quote_D,   // "  (double quote)
    quote_B,   // `  (backtick quote)
    brace_L,   // {
    brace_R,   // }
    bracket_L, // [
    bracket_R, // ]
    dot,       // .
    comma,     // ,
    // Operators
    plus,      // +
    min,       // -
    slash,     // /
    less,      // <
    more,      // >
    at,        // @
    dollar,    // $
    tilde,     // ~
    amp,       // &
    pcnt,      // %
    pipe,      // |
    excl,      // !
    qmark,     // ?
    hat,       // ^
    bslash,    // \
    // Whitespace
    space,     // ` `
    newline,   // \n
    tab,       // \t
    ret,       // \r
  };
};
pub const LexemList = std.MultiArrayList(Lx);

pub const Lex = struct {
  A    :std.mem.Allocator,
  pos  :u64,
  buf  :ByteBuffer,
  res  :LexemList,

  /// @descr Returns the character located in the current position of the buffer
  pub fn ch(L:*Lex) u8 { return L.buf.items[L.pos]; }

  pub fn create(A :std.mem.Allocator) Lex {
    return Lex {
      .A   = A,
      .pos = 0,
      .buf = ByteBuffer.init(A),
      .res = LexemList{},
    };
  }

  pub fn create_with(A :std.mem.Allocator, data :[]const u8) !Lex {
    var result = Lex{
      .A   = A,
      .pos = 0,
      .buf = try ByteBuffer.initCapacity(A, data.len),
      .res = LexemList{},
    };
    try result.buf.appendSlice(data[0..]);
    return result;
  }


  pub fn destroy(L:*Lex) void {
    L.buf.deinit();
    L.res.deinit(L.A);
  }

  fn append_toLast(L:*Lex, C :u8) !void {
    const id = L.res.len-1;
    try L.res.items(.val)[id].append(C);
  }

  fn ident(L:*Lex) !void {
    try L.res.append(L.A, Lx{
      .id  = Lx.Id.ident,
      .val = ByteBuffer.init(L.A),
    });
    while (true) : (L.pos += 1) {
      const c = L.ch();
      if      (Ch.isIdent(c))         { try L.append_toLast(c); }
      else if (Ch.isContextChange(c)) { break; }
      else                            { fail("Unknown Identifier character '{c}' (0x{X})", .{c, c}); }
    }
    L.pos -= 1;
  }

  fn number(L:*Lex) !void {
    try L.res.append(L.A, Lx{
      .id  = Lx.Id.number,
      .val = ByteBuffer.init(L.A),
    });
    while (true) : (L.pos += 1) {
      const c = L.ch();
      if      (Ch.isNumeric(c))       { try L.append_toLast(c); }
      else if (Ch.isContextChange(c)) { break; }
      else                            { fail("Unknown Numeric character '{c}' (0x{X})", .{c, c}); }
    }
    L.pos -= 1;
  }

  fn append_single(L:*Lex, id :Lx.Id) !void {
    try L.res.append(L.A, Lx{
      .id  = id,
      .val = ByteBuffer.init(L.A),
    });
    try L.append_toLast(L.ch());
  }

  fn paren(L:*Lex) !void {
    const id = switch(L.ch()) {
      '(' => Lx.Id.paren_L,
      ')' => Lx.Id.paren_R,
      else => |char| fail("Unknown Paren character '{c}' (0x{X})", .{char, char})
    };
    try L.append_single(id);
  }

  fn eq      (L:*Lex) !void { try L.append_single(Lx.Id.eq);      }
  fn star    (L:*Lex) !void { try L.append_single(Lx.Id.star);    }
  fn colon   (L:*Lex) !void { try L.append_single(Lx.Id.colon);   }
  fn space   (L:*Lex) !void { try L.append_single(Lx.Id.space);   }
  fn newline (L:*Lex) !void { try L.append_single(Lx.Id.newline); }

  pub fn process(L:*Lex) !void {
    while (true) : (L.pos += 1) {
      if (L.pos == L.buf.items.len) return; // End of the input data
      const c = L.ch();
      switch (c) {
      'a'...'z', 'A'...'Z', '_', => try L.ident(),
      '0'...'9'                  => try L.number(),
      '*'                        => try L.star(),
      '(', ')'                   => try L.paren(),
      ':'                        => try L.colon(),
      '='                        => try L.eq(),
      ' '                        => try L.space(),
      '\n'                       => try L.newline(),
      else => |char| fail("Unknown first character '{c}' (0x{X})", .{char, char})
      }
    }
  }
};

