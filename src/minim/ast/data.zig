//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const Data = @This();
// @deps std
const std = @import("std");
// @deps minim
const slate = @import("slate");


A       : std.mem.Allocator,
types   : Data.List.Types,
args    : Data.List.Args,
pragmas : Data.List.Pragmas,
stmts   : Data.List.Stmts,
/// @descr Contains the list of Top-Level nodes of the AST
nodes   : Data.List.Nodes,


pub fn create (A :std.mem.Allocator) !Data { return Data{
  .A       = A,
  .types   = try Data.List.Types.create(A),
  .args    = try Data.List.Args.create(A),
  .pragmas = try Data.List.Pragmas.create(A),
  .stmts   = try Data.List.Stmts.create(A),
  .nodes   = try Data.List.Nodes.create(A),
  };
} //:: Ast.Extras.create

pub fn clone (D :*Data) !Data { return Data{
  .A       = D.A,
  .types   = try D.types.clone(),
  .args    = try D.args.clone(),
  .pragmas = try D.pragmas.clone(),
  .stmts   = try D.stmts.clone(),
  .nodes   = try D.nodes.clone(),
  };
} //:: Ast.Extras.clone

pub fn destroy (D :*Data) void {
  D.types.destroy();
  D.args.destroy();
  D.pragmas.destroy();
  D.stmts.destroy();
  D.nodes.destroy();
} //:: Data.destroy

pub const List = struct {
  pub const Pos = slate.DataList(u1).Pos;  // (@note ignore u1. it is only used to access the Pos type)
  const Types   = slate.Type.Store;
  const Args    = slate.Proc.ArgStore;
  const Pragmas = slate.Pragma.Store;
  const Stmts   = slate.Stmt.Store;
  const Nodes   = slate.Node.List; // NOTE: Modules are Node.Stores
  pub const add = struct {
    pub fn @"type" (data :*Data, T :slate.Type)        !Data.List.Pos { try data.types.add(T)   ; return data.types.last(); }
    pub fn args    (data :*Data, T :slate.Proc.Args)   !Data.List.Pos { try data.args.add(T)    ; return data.args.last(); }
    pub fn pragmas (data :*Data, T :slate.Pragma.List) !Data.List.Pos { try data.pragmas.add(T) ; return data.pragmas.last(); }
    pub fn stmts   (data :*Data, T :slate.Stmt.List)   !Data.List.Pos { try data.stmts.add(T)   ; return data.stmts.last(); }
    pub fn node    (data :*Data, T :slate.Node)        !Data.List.Pos { try data.nodes.add(T)   ; return data.nodes.last(); }
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
  fn @"type" (data :*const Data, id :Data.List.Types.Pos) slate.Type {
    return data.types.at(id).?;
  } //:: Data.get.type
}; //:: Data.get

pub const get_proc_arg = Data.get.proc.arg;
pub const get_type     = Data.get.type;

