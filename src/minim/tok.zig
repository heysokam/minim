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
pub const Tok = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const fail = zstd.fail;
const prnt = zstd.prnt;
const ByteBuffer = zstd.T.ByteBuffer;
// @deps *Slate
const slate = @import("../lib/slate.zig");
const Ch    = slate.Ch;
const Lex   = slate.Lex;
// @deps minim
const M  = @import("./rules.zig");
const Lx = M.Lx;
const Tk = M.Tk;
const Pattern = M.Pattern;


/// @descr
///  Describes a Tokenizer process and its data.
///  @in A sequence of Lexemes and their containing characters  (Id,cstr)
///  @out The list of Tokens that those Lexemes represent  (Id,cstr)
A    :std.mem.Allocator,
pos  :u64,
buf  :Lx.List,
res  :Tk.List,

//__________________________
/// @descr Returns the Lexeme located in the current position of the buffer
fn lx(T:*Tok) Lx { return T.buf.get(T.pos); }
//__________________________
/// @descr Returns the Lexeme located {@arg id} positions ahead of the current position of the buffer.
fn next_at(T:*Tok, id :usize) Lx { return T.buf.get(T.pos+id); }
/// @descr Returns whether or not the next Lexeme in the buffer is an operator.
fn next_isOperator(T:*Tok) bool { return Ch.isOperator(Tok.next_at(T,1).val.items[0]); }
/// @descr Returns whether or not the next Lexeme in the buffer is an operator.
fn next_isWhitespace(T:*Tok) bool { return Ch.isWhitespace(Tok.next_at(T,1).val.items[0]); }
//__________________________
/// @descr Adds a single character to the last Token of the {@arg T.res} Tokenizer result.
fn append_toLast(T:*Tok, C :u8) !void {
  const id = T.res.len-1;
  try T.res.items(.val)[id].append(C);
}

//__________________________
/// @descr Creates a new Tokenizer object from the given {@arg L} Lexer contents.
pub fn create(L:*Lex) Tok {
  return Tok {
    .A   = L.A,
    .pos = 0,
    .buf = L.res,
    .res = Tk.List{},
  };
}

//__________________________
/// @descr Frees all resources owned by the Tokenizer object.
pub fn destroy(T:*Tok) void {
  T.buf.deinit(T.A);
  T.res.deinit(T.A);
}


//__________________________
/// @descr Processes an identifier Lexeme into its Token representation, and adds it to the {@arg T.res} result.
pub fn ident(T:*Tok) !void {
  const l = T.lx();
  if (Pattern.Kw.has(l.val.items)) {
    try T.res.append(T.A, Tk{
      .id  = Pattern.Kw.get(l.val.items).?,
      .val = l.val,
    });
  } else {
    try T.res.append(T.A, Tk{
      .id  = Tk.Id.b_ident,
      .val = l.val,
    });
  }
}
//__________________________
/// @descr Processes a number Lexeme into its Token representation, and adds it to the {@arg T.res} result.
/// @todo Should this process the numbers into different number kinds?
pub fn number(T:*Tok) !void {
  try T.res.append(T.A, Tk{
    .id  = Tk.Id.b_number,
    .val = T.lx().val,
  });
}
//__________________________
/// @descr Processes a Lexeme starting with `:` into its Token representation, and adds it to the {@arg T.res} result.
pub fn colon(T:*Tok) !void {
  if (!Tok.next_isOperator(T)) {
    try T.res.append(T.A, Tk{
      .id  = Tk.Id.sp_colon,
      .val = T.lx().val,
    });
  } else { fail("todo: colon operator case", .{}); }
}
//__________________________
/// @descr Processes a Lexeme starting with `=` into its Token representation, and adds it to the {@arg T.res} result.
pub fn eq(T:*Tok) !void {
  if (!Tok.next_isOperator(T)) {
    try T.res.append(T.A, Tk{
      .id  = Tk.Id.sp_eq,
      .val = T.lx().val,
    });
  } else { fail("todo: eq operator case", .{}); }
}
//__________________________
/// @descr Processes a Lexeme starting with `*` into its Token representation, and adds it to the {@arg T.res} result.
pub fn star(T:*Tok) !void {
  if (!Tok.next_isOperator(T)) {
    try T.res.append(T.A, Tk{
      .id  = Tk.Id.op_star,
      .val = T.lx().val,
    });
  } else { fail("todo: multi-star operator case", .{}); }
}
//__________________________
/// @descr Processes a Lexeme starting with `(` or `)` into its Token representation, and adds it to the {@arg T.res} result.
pub fn paren(T:*Tok) !void {
  const l = T.lx();
  try T.res.append(T.A, Tk{
    .id = switch (l.id) {
      .paren_L => Tk.Id.sp_paren_L,
      .paren_R => Tk.Id.sp_paren_R,
      else => unreachable,
      },
    .val = l.val,
  });
}
//__________________________
/// @descr Processes a whitespace Lexeme into its Token representation, and adds it to the {@arg T.res} result.
pub fn space(T:*Tok) !void {
  try T.res.append(T.A, Tk{
    .id  = Tk.Id.wht_space,
    .val = ByteBuffer.init(T.A),
  });
  while (true) : (T.pos += 1) { // Collapse all continuous Lexeme spaces into a single space Token.
    const l = T.lx();
    if (l.id != .space) { break; }
    try T.append_toLast(l.val.items[0]); // @warning Assumes spaces are never collaped in the Lexer
  }
  T.pos -= 1;
}
//__________________________
/// @descr Processes a newline Lexeme into its Token representation, and adds it to the {@arg T.res} result.
pub fn newline(T:*Tok) !void {
  try T.res.append(T.A, Tk{
    .id  = Tk.Id.wht_newline,
    .val = T.lx().val,
  });
}


//__________________________
/// @descr Tokenizer Entry Point
pub fn process(T:*Tok) !void {
  while (T.pos < T.buf.len) : (T.pos += 1) {
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

pub fn report(T:*Tok) void {
  std.debug.print("--- minim.Tokenizer ---\n", .{});
  for (T.res.items(.id), T.res.items(.val)) | id, val | {
    std.debug.print("{s} : {s}\n", .{@tagName(id), val.items});
  }
  std.debug.print("-----------------------\n", .{});
}

