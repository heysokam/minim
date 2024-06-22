//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");
// @deps zstd
const echo = @import("../zstd.zig").echo;
const prnt = @import("../zstd.zig").prnt;
const fail = @import("../zstd.zig").fail;
const ByteBuffer = @import("../zstd/types.zig").ByteBuffer;
// @deps minim.lex
pub const Ch = @import("./lex/char.zig");

const Tk = struct {
  id   :Id,
  val  :ByteBuffer,

  const Id = enum {
    ident,
    number,
    paren_L, // (
    paren_R, // )
    colon,   // :
    space,   // ` `
    newline, // \n
    eq,      // =
    star,    // *
  };
};
const TokenList = std.MultiArrayList(Tk);

pub const Lex = struct {
  A    :std.mem.Allocator,
  pos  :u64,
  buf  :ByteBuffer,
  tok  :ByteBuffer,
  res  :TokenList,

  /// @descr Returns the character at located in the current position of the buffer
  pub fn ch(L:*Lex) u8 { return L.buf.items[L.pos]; }

  pub fn create(A :std.mem.Allocator) Lex {
    return Lex {
      .A   = A,
      .pos = 0,
      .tok = ByteBuffer.init(A),
      .buf = ByteBuffer.init(A),
      .res = TokenList{},
    };
  }

  pub fn create_with(A :std.mem.Allocator, data :[]const u8) !Lex {
    var result = Lex {
      .A   = A,
      .pos = 0,
      .buf = try ByteBuffer.initCapacity(A, data.len),
      .tok = ByteBuffer.init(A),
      .res = TokenList{},
    };
    try result.buf.appendSlice(data[0..]);
    return result;
  }


  pub fn destroy(L:*Lex) void {
    L.buf.deinit();
    L.tok.deinit();
    L.res.deinit(L.A);
  }

  fn append_toLast(L:*Lex, C :u8) !void {
    const id = L.res.len-1;
    try L.res.items(.val)[id].append(C);
  }

  fn ident(L:*Lex) !void {
    try L.res.append(L.A, Tk{
      .id  = Tk.Id.ident,
      .val = ByteBuffer.init(L.A),
    });
    while (true)  {
      const c = L.ch();
      if      (Ch.isIdent(c))         { try L.append_toLast(c); L.pos += 1; }
      else if (Ch.isContextChange(c)) { return; }
      else                            { fail("Unknown Identifier character '{c}' (0x{X})", .{c, c}); }
    }
  }

  fn number(L:*Lex) !void {
    try L.res.append(L.A, Tk{
      .id  = Tk.Id.number,
      .val = ByteBuffer.init(L.A),
    });
    while (true)  {
      const c = L.ch();
      if      (Ch.isNumeric(c))       { try L.append_toLast(c); L.pos += 1; }
      else if (Ch.isContextChange(c)) { return; }
      else                            { fail("Unknown Numeric character '{c}' (0x{X})", .{c, c}); }
    }
  }

  fn append_single(L:*Lex, id :Tk.Id) !void {
    try L.res.append(L.A, Tk{
      .id  = id,
      .val = ByteBuffer.init(L.A),
    });
    try L.append_toLast(L.ch());
    L.pos += 1;
  }

  fn paren(L:*Lex) !void {
    const id = switch(L.ch()) {
      '(' => Tk.Id.paren_L,
      ')' => Tk.Id.paren_R,
      else => |char| fail("Unknown Paren character '{c}' (0x{X})", .{char, char})
    };
    try L.append_single(id);
  }

  fn eq      (L:*Lex) !void { try L.append_single(Tk.Id.eq);      }
  fn star    (L:*Lex) !void { try L.append_single(Tk.Id.star);    }
  fn colon   (L:*Lex) !void { try L.append_single(Tk.Id.colon);   }
  fn space   (L:*Lex) !void { try L.append_single(Tk.Id.space);   }
  fn newline (L:*Lex) !void { try L.append_single(Tk.Id.newline); }

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

