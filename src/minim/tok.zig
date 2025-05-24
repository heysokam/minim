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
//!
//! @descr
//!  Describes a Tokenizer process and its data.
//!  @in A sequence of Lexemes and their containing characters  (Id,cstr)
//!  @out The list of Tokens that those Lexemes represent  (Id,cstr)
//___________________________________________________________________________|
pub const Tok = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
// @deps *Slate
const slate   = @import("../lib/slate.zig");
const Ch      = slate.Ch;
const Lex     = slate.Lex;
const Lx      = slate.Lx;
const source  = slate.source;
pub const Loc = slate.Loc;
// @deps minim
const M       = @import("./rules.zig");
const Pattern = M.Pattern;
pub const Tk  = @import("./tok/token.zig");


A    :std.mem.Allocator,
pos  :source.Pos,
src  :source.Code,
buf  :Lx.List,
res  :Tk.List,


//______________________________________
// @section Create/Destroy
//____________________________
/// @descr Creates a new Tokenizer object from the given {@arg L} Lexer contents.
pub fn create (L:*Lex) !Tok {
  return Tok {
    .A   = L.A,
    .pos = 0,
    .src = L.src,
    .buf = try L.res.clone(L.A),
    .res = Tk.List{},
  };
} //:: M.Tok.create
//__________________
/// @descr Frees all resources owned by the Tokenizer object.
pub fn destroy (T:*Tok) void {
  T.buf.deinit(T.A);
  T.res.deinit(T.A);
} //:: M.Tok.destroy


//______________________________________
// @section General Tools
//____________________________
pub const fail   = zstd.fail;
pub const prnt   = zstd.prnt;
pub const report = @import("./tok/cli.zig").report;


//______________________________________
// @section State/Data Management
pub const data       = @import("./tok/data.zig");
pub const lx         = data.lx;
pub const next_at    = data.next_at;
pub const add_toLast = data.add.toLast;
pub const add        = data.add.one;
pub const move       = data.move;
//______________________________________
// @section State/Data Checks
pub const check                = @import("./tok/check.zig");
pub const next_isNumber        = check.next.isNumber;
pub const next_isOperator      = check.next.isOperator;
pub const next_isWhitespace    = check.next.isWhitespace;
pub const next_isDot           = check.next.isDot;
pub const next_isPar           = check.next.isPar;
pub const next_isSpecial       = check.next.isSpecial;
pub const next_isContextChange = check.next.isContextChange;
//______________________________________
// @section State/Data Search
pub const find               = @import("./tok/find.zig");
pub const find_ident         = find.first.ident;
pub const find_contextChange = find.first.contextChange;


//______________________________________
// @section Process: Words
pub const words = @import("./tok/words.zig");
pub const ident = words.ident;
//______________________________________
// @section Process: Whitespace
pub const whitespace = @import("./tok/whitespace.zig");
pub const space      = whitespace.space;
pub const newline    = whitespace.newline;
pub const eof        = whitespace.eof;
//______________________________________
// @section Process: Symbols / Operators
pub const symbols   = @import("./tok/symbols.zig");
pub const star      = symbols.star;
pub const paren     = symbols.paren;
pub const colon     = symbols.colon;
pub const semicolon = symbols.semicolon;
pub const eq        = symbols.eq;
pub const at        = symbols.at;
pub const dot       = symbols.dot;
pub const comma     = symbols.comma;
pub const hash      = symbols.hash;
pub const excl      = symbols.excl;
pub const question  = symbols.question;
pub const brace     = symbols.brace;
pub const bracket   = symbols.bracket;
pub const quote     = symbols.quote;
pub const dash      = symbols.dash;
//______________________________________
// @section Process: Literals
pub const literals = @import("./tok/literals.zig");
pub const number   = literals.number;


//______________________________________
// @section Process: Entry Point
//____________________________
/// @descr Tokenizer Entry Point
pub fn process (T:*Tok) !void {
  while (T.pos < T.buf.len) : (T.pos += 1) {
    const l = T.lx().id;
    switch (l) {
    .ident     => try T.ident(),
    .number    => try T.number(),
    .space     => try T.space(),
    .newline   => try T.newline(),
    .hash      => try T.hash(),       // #
    .excl      => try T.excl(),       // !
    .question  => try T.question(),   // ?
    .colon     => try T.colon(),      // :
    .semicolon => try T.semicolon(),  // ;
    .dot       => try T.dot(),        // .
    .comma     => try T.comma(),      // ,
    .eq        => try T.eq(),         // =
    .star      => try T.star(),       // *
    .at        => try T.at(),         // @
    .dash      => try T.dash(),       // -
    .paren_L,                         // (
    .paren_R   => try T.paren(),      // )
    .brace_L,                         // {
    .brace_R   => try T.brace(),      // }
    .bracket_L,                       // [
    .bracket_R => try T.bracket(),    // ]
    .quote_S,                         // '  (single quote)
    .quote_D,                         // "  (double quote)
    .quote_B   => try T.quote(),      // `  (backtick quote)
    .EOF       => try T.eof(),        // 0x0  (the null character 0 is treated as an EOF marker)
    else => |lexem| Tok.fail("Unknown first lexeme '{s}'", .{@tagName(lexem)})
    }
  // Operators
  // .plus,      // +
  // .min,       // -
  // .slash,     // /
  // .less,      // <
  // .more,      // >
  // .dollar,    // $
  // .tilde,     // ~
  // .amp,       // &
  // .pcnt,      // %
  // .pipe,      // |
  // .hat,       // ^
  // .bslash,    // \
  // Whitespace
  // .tab,       // \t
  // .ret,       // \r
  }
} //:: M.Tok.process

