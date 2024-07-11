//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
// @deps minim.ast
const Proc = @import("./proc.zig");


/// @descr Describes a Top-Level Node of the language.
pub const Node = union(enum) {
  Proc :Proc,
  pub const List = struct {
    const Data = zstd.seq(Node);
    data :?Data= null,

    /// @descr Creates a new empty Node.List object.
    pub fn create(A :std.mem.Allocator) Node.List { return Node.List{.data= Data.init(A)}; }
    /// @descr Releases all memory used by the Node.List
    pub fn destroy(L:*Node.List) void { L.data.?.deinit(); }
    /// @descr Returns true if the Node list has no nodes.
    pub fn empty(L:*const Node.List) bool { return L.data == null; }
    /// @descr Adds the given {@arg val} Node to the {@arg N} Node.List
    pub fn append(N :*Node.List, val :Node) !void { try N.data.?.append(val); }
  };
};

