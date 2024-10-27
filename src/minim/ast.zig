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
const slate = @import("../lib/slate.zig");
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
/// @descr Contains the list of Top-Level nodes of the AST
list  :Node.List,

//______________________________________
// @section Ast Management
//____________________________
/// @descr Returns true if the AST has no nodes in its {@link Ast.list} field
pub fn empty (ast :*const Ast) bool { return ast.list.empty(); }
/// @descr Adds the {@arg val} Node to the Node.List of the {@arg ast}.
pub fn add (ast :*Ast, val :Node) !void { try ast.list.add(val); }
/// @descr Duplicates the data of the {@arg ast} so that it is safe to call {@link Ast.destroy} without deallocating the duplicate.
pub fn clone (ast :*Ast) !Ast { return Ast{.A= ast.A, .lang= ast.lang, .list= try ast.list.clone()}; }
/// @descr Frees all resources owned by the Parser object.
pub fn destroy (ast :*Ast) void { ast.list.destroy(); }


//______________________________________
// @section Ast Creation
//____________________________
pub const create = struct {
  pub const Options = struct {
    verbose  :bool=  false,
  }; //:: M.Ast.create.Options

  //____________________________
  /// @descr Creates a new AST object by parsing the {@arg code} source.
  pub fn fromStr2 (
      code : cstr,
      in   : Ast.create.Options,
      A    : std.mem.Allocator
    ) !Ast {
    // Lexer
    var L = try slate.Lex.create_with(A, code);
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

