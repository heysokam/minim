
//...................................................................................
// Simple Composition
//............................
const Expression = struct {
  e  :u8,
};
const Declaration = struct {
  d  :u8,
};

// a block will only contain statements,
// so the block type contains a list of statements.
const Blck = struct {
  statements  :[]Statement,
};

// A statement is either a declaration or a loop,
// We need a tagged union to differentiate that
const Statement = union(enum) {
  decl  :Declaration,
  loop  :Loop,
};

// a loop will always require an expression as a condition
// and always has a block as a body
const Loop = struct {
  condition  :Expression,
  body       :*Blck,
};
//...................................................................................







//...................................................................................
// If you ever need some sort of shared functionality, you can write a comptime trait
// or an interface, but interfaces in Zig are more advanced level and I don't recommend unless you actually need them
// https://zig.news/yglcode/code-study-interface-idiomspatterns-in-zig-standard-libraries-4lkj
// AND they perform worse than a comptime trait, so you should always go comptime if it's possible
//...................................................................................
const std = @import("std");
pub fn Eq(comptime T :type) void {
  if (@typeInfo(T) != .Struct) { @compileError("type is not a struct"); }

  for (@typeInfo(T).Struct.decls) |decl| {
    if (std.mem.eql(u8, decl.name, "eq")) {
      if (decl.is_pub == false) { @compileError("type has method 'eq' but not public"); }
      return;
    }
  }
  @compileError("type has no method 'eq'");
}

const One = struct {
  val  :u8,
  pub fn eq(A :@This(), B :@This()) bool {
    return (A.val == B.val);
  }
};

const Two = struct {
  val: u8,
};

comptime { Eq(One); }  // will pass
comptime { Eq(Two); }  // will fail at compile time

//...................................................................................
//  Eq will check at runtime whether the passed in type obeys a number of rules
//  and then you can guarantee that something has a function of a certain type that you can call
//  you can often also use anytype
//  Zig has generics and this uses that. but it's more like duck-typing
//  Generics are broader. Example:
//...................................................................................
fn List(comptime T :type) type {
  return []T;
}


















// if you store them in a slice, you and store and index instead
//.......................................................................
const Node = struct {
  child_index: ?u32,
};

const nodes = try allocator.alloc(Node, 100);
@memset(nodes, .{ .child_index = null });

const root = &nodes[0];
const child = &nodes[15];
root.child_index = 15;




// with depth-first subtrees:
//.......................................................................
// root
//   node[1]
//     node[2]
//     node[3]
//   node[4]
//.......................................................................
const Node = struct {
    sub_tree_size: u32,
};

const nodes = try allocator.alloc(Node, 100);

const root = &nodes[0];
root.sub_tree_size = 5;
nodes[1].sub_tree_size = 3;
nodes[2].sub_tree_size = 1;
nodes[3].sub_tree_size = 1;
nodes[4].sub_tree_size = 1;

