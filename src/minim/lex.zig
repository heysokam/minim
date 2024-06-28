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
  /// @field {@link Lx.id} The Id of the Lexeme
  id   :Id,
  /// @field {@link Lx.val} The string value of the Lexeme
  val  :ByteBuffer,

  /// @descr {@link Lx.id} Valid kinds for Lexemes
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
//____________________________
/// @descr Describes a list of {@link Lx} Lexeme objects
/// @out From the Lexer process
/// @in To the Tokenizer process
pub const LexemList = std.MultiArrayList(Lx);


//______________________________________
/// @descr
/// Describes a Lexer process and its data.
/// @in A sequence of ascii characters  (cstr)
/// @out The list of lexemes that those characters represent.
//____________________________
pub const Lex = struct {
  /// @field {@link Lex.A} The Allocator used by the Lexer
  A    :std.mem.Allocator,
  /// @field {@link Lex.pos} The current {@link Lex.buf} position read by the Lexer.
  pos  :u64,
  /// @field {@link Lex.buf} The sequence of ascii characters that are being lexed.
  buf  :ByteBuffer,
  /// @field {@link Lex.res} The list of lexemes resulting from the Lexer process.
  res  :LexemList,

  //__________________________
  /// @descr Returns the character located in the current position of the buffer
  pub fn ch(L:*Lex) u8 { return L.buf.items[L.pos]; }

  //__________________________
  /// @descr Creates a new empty Lexer object.
  pub fn create(A :std.mem.Allocator) Lex {
    return Lex {
      .A   = A,
      .pos = 0,
      .buf = ByteBuffer.init(A),
      .res = LexemList{},
    };
  }

  //__________________________
  /// @descr Creates a new Lexer object from the given {@arg data}.
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


  //__________________________
  /// @descr Frees all resources owned by the Lexer object.
  pub fn destroy(L:*Lex) void {
    L.buf.deinit();
    L.res.deinit(L.A);
  }

  //__________________________
  /// @descr Adds a single character to the last lexeme of the {@link L.res} Lexer result.
  fn append_toLast(L:*Lex, C :u8) !void {
    const id = L.res.len-1;
    try L.res.items(.val)[id].append(C);
  }

  //__________________________
  /// @descr Processes an identifier into a Lexeme, and adds it to the {@link L.res} result.
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

  //__________________________
  /// @descr Processes a number into a Lexeme, and adds it to the {@link L.res} result.
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

  //__________________________
  /// @descr Adds a single {@link Lx} lexeme with {@arg id} to the result, and appends a single character into its {@link Lx.val} field.
  fn append_single(L:*Lex, id :Lx.Id) !void {
    try L.res.append(L.A, Lx{
      .id  = id,
      .val = ByteBuffer.init(L.A),
    });
    try L.append_toLast(L.ch());
  }

  //__________________________
  /// @descr Processes a single `(` character into a Lexeme, and adds it to the {@link L.res} result.
  fn paren(L:*Lex) !void {
    const id = switch(L.ch()) {
      '(' => Lx.Id.paren_L,
      ')' => Lx.Id.paren_R,
      else => |char| fail("Unknown Paren character '{c}' (0x{X})", .{char, char})
    };
    try L.append_single(id);
  }

  //__________________________
  /// @descr Processes a single `=` character into a Lexeme, and adds it to the {@link L.res} result.
  fn eq (L:*Lex) !void { try L.append_single(Lx.Id.eq); }
  //__________________________
  /// @descr Processes a single `*` character into a Lexeme, and adds it to the {@link L.res} result.
  fn star (L:*Lex) !void { try L.append_single(Lx.Id.star); }
  //__________________________
  /// @descr Processes a single `:` character into a Lexeme, and adds it to the {@link L.res} result.
  fn colon (L:*Lex) !void { try L.append_single(Lx.Id.colon); }
  //__________________________
  /// @descr Processes a single ` ` character into a Lexeme, and adds it to the {@link L.res} result.
  fn space (L:*Lex) !void { try L.append_single(Lx.Id.space); }
  //__________________________
  /// @descr Processes a single `\n` character into a Lexeme, and adds it to the {@link L.res} result.
  fn newline (L:*Lex) !void { try L.append_single(Lx.Id.newline); }


  //__________________________
  /// @descr Lexer Entry Point
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

