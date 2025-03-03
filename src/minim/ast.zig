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


//______________________________________
// @section Data Management
//____________________________
pub const Data = @import("./ast/data.zig");
/// @descr Adds a Type to the respective Ast.Data list
pub inline fn add_type    (ast :*Ast, T :slate.Type)        !Data.Store.Pos { return Ast.Data.Store.add.type(    &ast.data, T); }
pub inline fn add_args    (ast :*Ast, T :slate.Proc.Args)   !Data.Store.Pos { return Ast.Data.Store.add.args(    &ast.data, T); }
pub inline fn add_pragmas (ast :*Ast, T :slate.Pragma.List) !Data.Store.Pos { return Ast.Data.Store.add.pragmas( &ast.data, T); }
pub inline fn add_stmts   (ast :*Ast, T :slate.Stmt.List)   !Data.Store.Pos { return Ast.Data.Store.add.stmts(   &ast.data, T); }
pub inline fn add_node    (ast :*Ast, T :slate.Node)        !Data.Store.Pos { return Ast.Data.Store.add.node(    &ast.data, T); }


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
    verbose : bool       = false,
    lang    : rules.Lang = .none,
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
    var P = try Par.create(&T, in.lang);
    defer P.destroy();
    try P.process();
    if (in.verbose) P.report();

    // Return the result
    return try P.res.clone();
  } //:: M.Ast.create.fromStr2
  //____________________________
  /// @descr Creates a new AST object by parsing the {@arg code} source.
  pub fn fromStr (
      code : slate.source.Code,
      lang : rules.Lang,
      A    : std.mem.Allocator
    ) !Ast { return Ast.create.fromStr2(code, .{.lang= lang}, A); }


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

