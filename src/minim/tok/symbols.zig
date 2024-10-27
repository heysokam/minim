//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Tokenizer Process: Symbols & Operators
//_______________________________________________________|
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
// @deps minim
const Tok = @import("../tok.zig");
const Tk  = Tok.Tk;


//____________________________
/// @descr Processes a Lexeme starting with `*` into its Token representation, and adds it to the {@arg T.res} result.
pub fn star (T:*Tok) !void {
  if (!Tok.next_isOperator(T)) {
    try T.res.append(T.A, Tk{
      .id  = Tk.Id.op_star,
      .val = T.lx().val,
    });
  } else { Tok.fail("todo: multi-star operator case", .{}); }
}

//____________________________
/// @descr Processes a Lexeme starting with `(` or `)` into its Token representation, and adds it to the {@arg T.res} result.
pub fn paren (T:*Tok) !void {
  const l = T.lx();
  // FIX: (. case
  try T.res.append(T.A, Tk{
    .id = switch (l.id) {
      .paren_L => Tk.Id.sp_paren_L,
      .paren_R => Tk.Id.sp_paren_R,
      else => Tok.fail("Found an unexpected case in Tok.paren():  id:`{s}`  val:`{s}`", .{@tagName(l.id), l.val.items}),
      },
    .val = l.val,
  });
}

//____________________________
/// @descr Processes a Lexeme starting with `:` into its Token representation, and adds it to the {@arg T.res} result.
pub fn colon (T:*Tok) !void {
  // FIX: :] case
  if (!Tok.next_isOperator(T)) {
    try T.res.append(T.A, Tk{
      .id  = Tk.Id.sp_colon,
      .val = T.lx().val,
    });
  // FIX: Colon operator case
  } else { Tok.fail("todo: colon operator case", .{}); }
}

//__________________________
/// @descr Processes a semicolon Lexeme into its Token representation, and adds it to the {@arg T.res} result.
pub fn semicolon (T:*Tok) !void {
  try T.res.append(T.A, Tk{
    .id  = Tk.Id.sp_semicolon,
    .val = T.lx().val,
  });
}

//____________________________
/// @descr Processes a Lexeme starting with `=` into its Token representation, and adds it to the {@arg T.res} result.
pub fn eq (T:*Tok) !void {
  if (!Tok.next_isOperator(T)) {
    try T.res.append(T.A, Tk{
      .id  = Tk.Id.sp_eq,
      .val = T.lx().val,
    });
  } else { Tok.fail("todo: eq operator case", .{}); }
}

//__________________________
/// @descr Processes a hash Lexeme into its Token representation, and adds it to the {@arg T.res} result.
pub fn at (T:*Tok) !void {
  // FIX: @ operator case
  try T.res.append(T.A, Tk{
    .id  = Tk.Id.op_at,
    .val = T.lx().val,
  });
}

//__________________________
/// @descr Processes a hash Lexeme into its Token representation, and adds it to the {@arg T.res} result.
pub fn hash (T:*Tok) !void {
  try T.res.append(T.A, Tk{
    .id  = Tk.Id.sp_hash,
    .val = T.lx().val,
  });
}

//__________________________
/// @descr Processes a Lexeme starting with `.` into its Token representation, and adds it to the {@arg T.res} result.
pub fn dot (T:*Tok) !void {
  // Special .} .] .) cases
  if (T.next_isPar()) {
    var val = zstd.str.init(T.A);
    try val.appendSlice(T.lx().val.items);
    const id = switch (T.next_at(1).id) {
      .brace_R   => Tk.Id.sp_braceDot_R,
      .bracket_R => Tk.Id.sp_bracketDot_R,
      .paren_R   => Tk.Id.sp_parenDot_R,
      else => unreachable
      }; //:: id
    T.pos += 1;
    try val.appendSlice(T.lx().val.items);
    try T.res.append(T.A, Tk{
      .id  = id,
      .val = val,
    });
    return;
  }
  // FIX: Dot operator case
  if (T.next_isOperator()) { Tok.fail("todo: dot operator case", .{}); }
  // Single dot case
  try T.res.append(T.A, Tk{
    .id  = Tk.Id.op_dot,
    .val = T.lx().val,
  });
}
//__________________________
/// @descr Processes a comma Lexeme into its Token representation, and adds it to the {@arg T.res} result.
pub fn comma (T:*Tok) !void {
  try T.res.append(T.A, Tk{
    .id  = Tk.Id.sp_comma,
    .val = T.lx().val,
  });
}


//__________________________
/// @descr Processes a Lexeme starting with `{` or `}` into its Token representation, and adds it to the {@arg T.res} result.
pub fn brace (T:*Tok) !void {
  const l = T.lx();
  switch (l.id) {
    .brace_R => { try T.res.append(T.A, Tk{
      .id  = Tk.Id.sp_brace_R,
      .val = l.val,
      });}, //:: .brace_R
    .brace_L => {
      // Find {
      var id = Tk.Id.sp_brace_L;
      var val = zstd.str.init(T.A);
      try val.appendSlice(l.val.items);
      // Find {.
      if (T.next_isDot()) {
        T.pos += 1;
        try val.appendSlice(T.lx().val.items);
        id = Tk.Id.sp_braceDot_L;
      }
      try T.res.append(T.A, Tk{
        .id  = id,
        .val = val,
        });}, //:: .brace_L
    else => unreachable,
  }
}
//__________________________
/// @descr Processes a Lexeme starting with `[` or `]` into its Token representation, and adds it to the {@arg T.res} result.
pub fn bracket (T:*Tok) !void {
  const l = T.lx();
  switch (l.id) {
    // FIX: ]#  ]## cases
    .bracket_R => { try T.res.append(T.A, Tk{
      .id  = Tk.Id.sp_bracket_R,
      .val = l.val,
      });}, //:: .bracket_R
    .bracket_L => {
      // Find [
      var id = Tk.Id.sp_bracket_L;
      var val = zstd.str.init(T.A);
      try val.appendSlice(l.val.items);
      // Find [.
      if (T.next_isDot()) {
        T.pos += 1;
        try val.appendSlice(T.lx().val.items);
        id = Tk.Id.sp_bracketDot_L;
      }
      try T.res.append(T.A, Tk{
        .id  = id,
        .val = val,
        });
      }, //:: .bracket_L
    else => unreachable,
  }
}
//__________________________
/// @descr Processes a quote Lexeme into its Token representation, and adds it to the {@arg T.res} result.
pub fn quote (T:*Tok) !void {
  try T.res.append(T.A, Tk{
    .id = switch (T.lx().id) {
      .quote_S => Tk.Id.sp_quote_S,
      .quote_D => Tk.Id.sp_quote_D,
      .quote_B => Tk.Id.sp_quote_B,
      else => unreachable,
      }, //:: .id
    .val = T.lx().val,
  });
}

