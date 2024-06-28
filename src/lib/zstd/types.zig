//:____________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
//! @fileoverview Core Type Aliases
//__________________________________|
// @deps std
const std = @import("std");

//______________________________________
// @section Array Aliases
//____________________________
/// @descr CharLiteral String. Compatible with C
pub const cstr      = [:0]const u8;
/// @descr List of CharLiteral Strings
pub const cstr_List = []const cstr;

//______________________________________
// @section GArray Aliases
//____________________________
pub const ByteBuffer = std.ArrayList(u8);

