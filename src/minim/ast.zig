//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const Ast = @This();
// @deps std
const std   = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const cstr = zstd.cstr;
// @deps *Slate
const slate  = @import("../lib/slate.zig");
const source = slate.source;
// @deps minim
const rules = @import("./rules.zig");
const Tok   = @import("./tok.zig");
const Par   = @import("./par.zig");


//______________________________________
// @section AST Forward Exports
//____________________________
pub const Ident   = slate.Ident;
pub const Type    = slate.Type;
// pub const Data   = slate.Data;
pub const Pragma  = slate.Pragma;
pub const Pragmas = slate.Pragma.List;
pub const Stmt    = slate.Stmt;
pub const Expr    = slate.Expr;
pub const Node    = slate.Node;
pub const Proc    = slate.Proc;


//______________________________________
// @section Object Fields
//____________________________
/// @descr The Allocator used by the AST object
A     :std.mem.Allocator,
/// @descr Describes which output language the AST is targeting
lang  :rules.Lang,
/// @descr Contains the string that the AST's source code is references from every Node
/// @note Nodes are created such that the language (or correctness) of the source code contained in this string does not matter.
src   :source.Code,
/// @descr Extra data that doesn't fit in the main node list of the AST
/// @eg Array Types will be an index into the ext.types list
data  :Ast.Data,

pub const Data = struct {
  A       : std.mem.Allocator,
  types   : Ast.Data.List.Types,
  args    : Ast.Data.List.Args,
  pragmas : Ast.Data.List.Pragmas,
  stmts   : Ast.Data.List.Stmts,
  /// @descr Contains the list of Top-Level nodes of the AST
  nodes   : Ast.Data.List.Nodes,

  pub fn create (A :std.mem.Allocator) !Ast.Data { return Ast.Data{
    .A       = A,
    .types   = try Ast.Data.List.Types.create(A),
    .args    = try Ast.Data.List.Args.create(A),
    .pragmas = try Ast.Data.List.Pragmas.create(A),
    .stmts   = try Ast.Data.List.Stmts.create(A),
    .nodes   = try Ast.Data.List.Nodes.create(A),
    };
  } //:: Ast.Extras.create

  pub fn clone (D :*Ast.Data) !Ast.Data { return Ast.Data{
    .A       = D.A,
    .types   = try D.types.clone(),
    .args    = try D.args.clone(),
    .pragmas = try D.pragmas.clone(),
    .stmts   = try D.stmts.clone(),
    .nodes   = try D.nodes.clone(),
    };
  } //:: Ast.Extras.clone

  pub fn destroy (D :*Ast.Data) void {
    D.types.destroy();
    D.args.destroy();
    D.pragmas.destroy();
    D.stmts.destroy();
    D.nodes.destroy();
  } //:: Ast.Data.destroy

  pub const List = struct {
    pub const Pos = slate.DataList(u1).Pos;  // (@note ignore u1. it is only used to access the Pos type)
    const Types   = Type.Store;
    const Args    = Proc.ArgStore;
    const Pragmas = Ast.Pragma.Store;
    const Stmts   = Ast.Stmt.Store;
    const Nodes   = Ast.Node.List; // NOTE: Modules are Node.Stores
    const add = struct {
      pub fn @"type" (ast :*Ast, T :Ast.Type)        !Ast.Data.List.Pos { try ast.data.types.add(T)   ; return ast.data.types.last(); }
      pub fn args    (ast :*Ast, T :Ast.Proc.Args)   !Ast.Data.List.Pos { try ast.data.args.add(T)    ; return ast.data.args.last(); }
      pub fn pragmas (ast :*Ast, T :Ast.Pragma.List) !Ast.Data.List.Pos { try ast.data.pragmas.add(T) ; return ast.data.pragmas.last(); }
      pub fn stmts   (ast :*Ast, T :Ast.Stmt.List)   !Ast.Data.List.Pos { try ast.data.stmts.add(T)   ; return ast.data.stmts.last(); }
      pub fn node    (ast :*Ast, T :Ast.Node)        !Ast.Data.List.Pos { try ast.data.nodes.add(T)   ; return ast.data.nodes.last(); }
    }; //:: Ast.Data.List.add
  }; //:: Ast.Data.List

  pub const get = struct {
    pub const proc = struct {
      /// @descr Shorthand that returns the data for the proc argument at position ({@arg procID}, {@arg argID})
      pub fn arg (data :*const Ast.Data, procID :usize, argID :usize) Proc.Arg {
        return data.args.at(
          data.nodes.items()[procID].Proc.args
        ).?.at(@enumFromInt(argID)).?;
      } //:: Ast.Data.get.proc.arg
    }; //:: Ast.Data.get.proc

    /// @descr Shorthand that returns the data for the type at position {@arg id}
    pub fn @"type" (data :*const Ast.Data, id :Ast.Data.List.Types.Pos) Type {
      return data.types.at(id).?;
    } //:: Ast.Data.get.type
  }; //:: Ast.Data.get

  pub const get_proc_arg = Ast.Data.get.proc.arg;
  pub const get_type     = Ast.Data.get.type;
}; //:: Ast.Data
//____________________________
/// @descr Adds a Type to the respective Ast.Data list
pub const add_type    = Ast.Data.List.add.type;
pub const add_args    = Ast.Data.List.add.args;
pub const add_pragmas = Ast.Data.List.add.pragmas;
pub const add_stmts   = Ast.Data.List.add.stmts;
pub const add_node    = Ast.Data.List.add.node;



//______________________________________
// @section Ast Management
//____________________________
/// @descr Returns true if the AST has no nodes in its {@link Ast.data} field
pub fn empty (ast :*const Ast) bool { return ast.data.nodes.empty(); }
// /// @descr Adds the {@arg val} Node to the Node.List of the {@arg ast}.
// pub fn add (ast :*Ast, val :Node) !void { try ast.list.add(val); }
/// @descr Duplicates the data of the {@arg ast} so that it is safe to call {@link Ast.destroy} without deallocating the duplicate.
pub fn clone (ast :*Ast) !Ast { return Ast{
  .A       = ast.A,
  .lang    = ast.lang,
  .src     = ast.src,
  .data    = try ast.data.clone(),
};} //:: Ast.clone
/// @descr Frees all resources owned by the AST object.
pub fn destroy (ast :*Ast) void {
  ast.data.destroy();
} //:: Ast.destroy


//______________________________________
// @section Ast Creation
//____________________________
pub const create = struct {
  pub const Options = struct {
    verbose  :bool=  false,
  }; //:: M.Ast.create.Options

  //____________________________
  /// @descr Creates a new empty AST object for {@arg lang} language.
  pub fn empty (lang :rules.Lang, src :source.Code, A :std.mem.Allocator) !Ast {
    return Ast{
      .A     = A,
      .lang  = lang,
      .src   = src,
      .data  = try Ast.Data.create(A),
      };
  } //:: M.Ast.empty

  //____________________________
  /// @descr Creates a new AST object by parsing the {@arg code} source.
  pub fn fromStr2 (
      code : slate.source.Code,
      in   : Ast.create.Options,
      A    : std.mem.Allocator
    ) !Ast {
    // Lexer
    var L = try slate.Lex.create(A, code);
    defer L.destroy();
    try L.process();
    if (in.verbose) L.report();

    // Tokenizer
    var T = try Tok.create(&L);
    defer T.destroy();
    try T.process();
    if (in.verbose) T.report();

    // Parser
    var P = try Par.create(&T);
    defer P.destroy();
    try P.process();
    if (in.verbose) P.report();

    // Return the result
    return try P.res.clone();
  } //:: M.Ast.create.fromStr2
  //____________________________
  /// @descr Creates a new AST object by parsing the {@arg code} source.
  pub fn fromStr (code :cstr, A :std.mem.Allocator) !Ast { return Ast.create.fromStr2(code, .{}, A); }


//   //____________________________
//   /// @descr Creates a new AST object by parsing the source code contained in the {@arg file}
//   pub fn fromFile2 (
//       file : cstr,
//       in   : Ast.create.Options,
//       A    : std.mem.Allocator
//     ) !Ast {
//     const code = try zstd.files.read(file, A, .{});
//     defer A.free(code);
//     return Ast.create.fromStr(code, in, A);
//   } //:: M.Ast.create.fromFile
//   //____________________________
//   /// @descr Creates a new AST object by parsing the source code contained in the {@arg file}
//   pub fn fromFile (file :cstr, A :std.mem.Allocator) !Ast { return Ast.create.fromFile2(file, .{}, A); }
}; //:: M.Ast.create

//______________________________________
// @section Create Aliases
//____________________________
pub const get   = Ast.create.fromStr;
pub const get2  = Ast.create.fromStr2;
// pub const read  = Ast.create.fromFile;
// pub const read2 = Ast.create.fromFile2;


//______________________________________
// @section Code Generation
//____________________________
const codegen = @import("./gen.zig");
pub const gen = codegen.gen;

