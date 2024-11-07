//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const Ast = @This();
// @deps std
const std   = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const cstr = zstd.cstr;
const str  = zstd.str;
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
pub const Ident  = slate.Ident;
pub const Type   = slate.Type;
pub const Data   = slate.Data;
pub const Pragma = slate.Pragma;
pub const Stmt   = slate.Stmt;
pub const Expr   = slate.Expr;
pub const Node   = slate.Node;
pub const Proc   = slate.Proc;


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
/// @descr Contains the list of Top-Level nodes of the AST
list  :Node.List,
/// @descr Extra data that doesn't fit in the main node list of the AST
/// @eg Array Types will be an index into the ext.types list
ext   :Ast.Extras,

pub const Extras = struct {
  types  :Ast.Extras.List.Types,

  pub fn create (A :std.mem.Allocator) Ast.Extras { return Ast.Extras{
    .types = List.Types.create(A),
    };
  } //:: Ast.Extras.create

  pub fn clone (E :*Ast.Extras) !Ast.Extras { return Ast.Extras{
    .types = try E.types.clone()
    };
  } //:: Ast.Extras.clone

  pub const List = struct {
    pub const Pos = zstd.DataList(u1).Pos;  // (@note ignore u1. it is only used to access the Pos type)
    const Types   = Type.List;
    const add = struct {
      pub fn @"type" (ast :*Ast, T :Ast.Type) !Ast.Extras.List.Pos { try ast.ext.types.add(T); return ast.ext.types.last(); }
    };
  };
}; //:: Ast.Extras
//____________________________
/// @descr Adds a Type to the respective Ast.Extras list
pub const add_type = Ast.Extras.List.add.type;



//______________________________________
// @section Ast Management
//____________________________
/// @descr Returns true if the AST has no nodes in its {@link Ast.list} field
pub fn empty (ast :*const Ast) bool { return ast.list.empty(); }
/// @descr Adds the {@arg val} Node to the Node.List of the {@arg ast}.
pub fn add (ast :*Ast, val :Node) !void { try ast.list.add(val); }
/// @descr Duplicates the data of the {@arg ast} so that it is safe to call {@link Ast.destroy} without deallocating the duplicate.
pub fn clone (ast :*Ast) !Ast { return Ast{
  .A       = ast.A,
  .lang    = ast.lang,
  .src     = ast.src,
  .list    = try Node.list.clone(&ast.list),
  .ext     = try ast.ext.clone(),
  };
} //:: Ast.clone
/// @descr Frees all resources owned by the AST object.
pub fn destroy (ast :*Ast) void {
  for (0..ast.list.items().len) |id| ast.list.items()[id].destroy(ast.ext.types);
  ast.list.destroy();
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
  pub fn empty (lang :rules.Lang, src :source.Code, A :std.mem.Allocator) Ast {
    return Ast{
      .A    = A,
      .lang = lang,
      .src  = src,
      .list = Node.List.create(A),
      .ext  = Ast.Extras.create(A),
      };
  } //:: M.Ast.empty

  //____________________________
  /// @descr Creates a new AST object by parsing the {@arg code} source.
  pub fn fromStr2 (
      code : cstr,
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


  //____________________________
  /// @descr Creates a new AST object by parsing the source code contained in the {@arg file}
  pub fn fromFile2 (
      file : cstr,
      in   : Ast.create.Options,
      A    : std.mem.Allocator
    ) !Ast {
    const code = try zstd.files.read(file, A, .{});
    defer A.free(code);
    return Ast.create.fromStr(code, in, A);
  } //:: M.Ast.create.fromFile
  //____________________________
  /// @descr Creates a new AST object by parsing the source code contained in the {@arg file}
  pub fn fromFile (file :cstr, A :std.mem.Allocator) !Ast { return Ast.create.fromFile2(file, .{}, A); }
}; //:: M.Ast.create

//______________________________________
// @section Create Aliases
//____________________________
pub const get   = Ast.create.fromStr;
pub const get2  = Ast.create.fromStr2;
pub const read  = Ast.create.fromFile;
pub const read2 = Ast.create.fromFile2;


//______________________________________
// @section Code Generation
//____________________________
const codegen = @import("./gen.zig");
pub const gen = codegen.gen;

