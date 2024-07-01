//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
const Ast = @This();
// @deps minim
const Lang = @import("./rules.zig").Lang;
const Node = @import("./ast/node.zig").Node;

/// @descr Describes which output language the AST is targeting
lang  :Lang,
/// @descr Contains the list of Top-Level nodes of the AST
list  :Node.List,

