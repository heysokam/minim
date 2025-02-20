//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const Data = @This();
// @deps std
const std = @import("std");
// @deps minim
const slate = @import("slate");


A       : std.mem.Allocator,
types   : Data.Store.Types,
args    : Data.Store.Args,
pragmas : Data.Store.Pragmas,
stmts   : Data.Store.Stmts,
/// @descr Contains the list of Top-Level nodes of the AST
nodes   : Data.Store.Nodes,


pub fn create (A :std.mem.Allocator) !Data { return Data{
  .A       = A,
  .types   = try Data.Store.Types.create(A),
  .args    = try Data.Store.Args.create(A),
  .pragmas = try Data.Store.Pragmas.create(A),
  .stmts   = try Data.Store.Stmts.create(A),
  .nodes   = try Data.Store.Nodes.create(A),
  };
} //:: Ast.Extras.create

pub fn clone (D :*Data) !Data {
  // Clone the list stores
  var args = try Data.Store.Args.create(D.A);
  for (D.args.items()) |arg| try args.add(try arg.clone());
  var pragmas = try Data.Store.Pragmas.create(D.A);
  for (D.pragmas.items()) |pragma| try pragmas.add(try pragma.clone());
  var stmts = try Data.Store.Stmts.create(D.A);
  for (D.stmts.items()) |stmt| try stmts.add(try stmt.clone());
  // Clone the lists
  return Data{
    .A       = D.A,
    .types   = try D.types.clone(),
    .args    = args,
    .pragmas = pragmas,
    .stmts   = stmts,
    .nodes   = try D.nodes.clone(),
    };
} //:: Ast.Extras.clone

pub fn destroy (D :*Data) void {
  // Cleanup the Type.List
  D.types.destroy();
  // Cleanup the Proc.Arg.Store
  for (0..D.args.len()) |id| {
    var args :slate.Proc.Arg.List= D.args.at(@enumFromInt(id)).?;
    args.destroy();
  }
  D.args.destroy();
  // Cleanup the Pragma.Store
  for (0..D.pragmas.len()) |id| {
    var pragmas :slate.Pragma.List= D.pragmas.at(@enumFromInt(id)).?;
    pragmas.destroy();
  }
  D.pragmas.destroy();
  // Cleanup the Stmt.Store
  for (0..D.stmts.len()) |id| {
    var stmt :slate.Stmt.List= D.stmts.at(@enumFromInt(id)).?;
    stmt.destroy();
  }
  D.stmts.destroy();
  // Cleanup the Node.List
  D.nodes.destroy();
} //:: Data.destroy

pub const Store = struct {
  pub const Pos = slate.DataList(u1).Pos;  // (@note ignore u1. it is only used to access the Pos type)
  const Types   = slate.Type.List;
  const Args    = slate.Proc.ArgStore;
  const Pragmas = slate.Pragma.Store;
  const Stmts   = slate.Stmt.Store;
  const Nodes   = slate.Node.List; // NOTE: Modules are Node.Stores
  pub const add = struct {
    pub fn @"type" (data :*Data, T :slate.Type)        !Data.Store.Pos { try data.types.add(T)   ; return data.types.last(); }
    pub fn args    (data :*Data, T :slate.Proc.Args)   !Data.Store.Pos { try data.args.add(T)    ; return data.args.last(); }
    pub fn pragmas (data :*Data, T :slate.Pragma.List) !Data.Store.Pos { try data.pragmas.add(T) ; return data.pragmas.last(); }
    pub fn stmts   (data :*Data, T :slate.Stmt.List)   !Data.Store.Pos { try data.stmts.add(T)   ; return data.stmts.last(); }
    pub fn node    (data :*Data, T :slate.Node)        !Data.Store.Pos { try data.nodes.add(T)   ; return data.nodes.last(); }
  }; //:: Data.List.add
}; //:: Data.List

const get = struct {
  const proc = struct {
    /// @descr Shorthand that returns the data for the proc argument at position ({@arg procID}, {@arg argID})
    fn arg (data :*const Data, procID :usize, argID :usize) slate.Proc.Arg {
      return data.args.at(
        data.nodes.items()[procID].Proc.args
      ).?.at(@enumFromInt(argID)).?;
    } //:: Data.get.proc.arg
  }; //:: Data.get.proc

  /// @descr Shorthand that returns the data for the type at position {@arg id}
  fn @"type" (data :*const Data, id :Data.Store.Types.Pos) slate.Type {
    return data.types.at(id).?;
  } //:: Data.get.type
}; //:: Data.get

pub const get_proc_arg = Data.get.proc.arg;
pub const get_type     = Data.get.type;

