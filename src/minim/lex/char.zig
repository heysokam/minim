//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Character identification tools
//________________________________________________|
// @deps std
const std = @import("std");


//______________________________________
// @section Forward exports from std
//____________________________
pub const isWhitespace   = std.ascii.isWhitespace;
pub const isAlphanumeric = std.ascii.isAlphanumeric;
pub const isDigit        = std.ascii.isDigit;
pub const isHex          = std.ascii.isHex;


//______________________________________
// @section Extensions to std.ascii
//____________________________
/// @descr Returns whether or not the {@arg C} is a valid identifier character
pub fn isIdent(C :u8) bool {
  if (isAlphanumeric(C)) { return true; }
  return switch (C) { // Search for other valid chars
    '_' => true,
    else => false,
  };
}

//__________________
/// @descr Returns whether or not the {@arg C} is a valid numeric character
/// @note Not the same as {@link std.isDigit}
pub fn isNumeric(C :u8) bool {
  if (isDigit(C) or isHex(C)) return true;
  return switch (C) { // Search for other valid chars
    '\'', 'x','b','o', 'f','F', 'u','U', 'i','I' => true,
    else => false,
  };
}

//__________________
/// @descr Returns whether or not the {@arg C} is a character that should trigger a context switch
pub fn isContextChange(C :u8) bool {
  if (isWhitespace(C)) { return true; }
  return switch (C) { // Search for other valid chars
    '=', ':', '@', => true,
    else => false,
  };
}

