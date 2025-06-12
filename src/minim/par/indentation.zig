//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Parser Process: Indentation
//____________________________________________|
const indentation = @This();
// @deps zstd
const zstd = @import("zstd");
// @deps minim
const Tok = @import("../tok.zig");
const Tk  = Tok.Tk;
const Par = @import("../par.zig");


pub const Kind = packed struct {
  decr    :bool= false, // Can decrement
  eq      :bool= true,  // Can be equal
  incr    :bool= false, // Can increment
  scope   :bool= false, // Must update scope when requested
  __reserved_bits_04_07 :u4= 0,
  pub usingnamespace zstd.Flags(@This(), u8);

  //______________________________________
  // Preset: Cases
  pub fn equal () indentation.Kind { return indentation.Kind{
    .decr= false, .eq= true, .incr= false, .scope= false,  };}
  pub fn increase () indentation.Kind { return indentation.Kind{
    .decr= false, .eq= false, .incr= true, .scope= true,  };}
  pub fn decrease () indentation.Kind { return indentation.Kind{
    .decr= true, .eq= false, .incr= false, .scope= true,  };}
  pub fn any () indentation.Kind { return indentation.Kind{
    .decr= true, .eq= true, .incr= true, .scope= false,  };}
  pub fn incr_eq () indentation.Kind { return indentation.Kind{
    .decr= false, .eq= true, .incr= true, .scope= false,  };}

  //______________________________________
  // Preset: Case Checks
  pub fn is_any   (K :*const Kind) bool { return K.hasAll(.any()); }
  pub fn is_incr  (K :*const Kind) bool { return K.hasAny(.{.incr = true, .eq=false}); }
  pub fn is_decr  (K :*const Kind) bool { return K.hasAny(.{.decr = true, .eq=false}); }
  pub fn is_eq    (K :*const Kind) bool { return K.hasAny(.{.eq   = true           }); }
  pub fn is_scope (K :*const Kind) bool { return K.hasAny(.{.scope= true, .eq=false}); }
};

pub fn expect (P :*Par) void { P.expectAny(&.{Tk.Id.wht_newline, Tk.Id.wht_space}, "Indentation"); }

const std = @import("std");
/// @descr Entry point of the indentation parser process
pub fn parse (P:*Par, kind :indentation.Kind) void {
  // TODO: All tokens have indentation tags from the tokenizer
  //     : This function should manage:
  //     : - Expected Indentation tokens
  //     : - Expected Indentation levels
  //     : - Scope update when requested
  P.skip(Tk.Id.wht_space);
  P.skip(Tk.Id.wht_newline);
  P.skip(Tk.Id.wht_space);
  if (kind.is_scope()) {
    // TODO: P.scope.incr();
    // TODO: P.scope.decr();
    P.scope.increase(P.tk().indent) catch |err| P.fail("indentation.parse.error.{}\n", .{err});
  }
}

