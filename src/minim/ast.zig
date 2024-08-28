//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const Ast = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const cstr = zstd.cstr;
// @deps slate
const slate = @import("../lib/slate.zig");
// @deps minim
const Tok = @import("./tok.zig");
const Par = @import("./par.zig");

//______________________________________
// @section Forward exports
//____________________________
pub const Lang  = @import("./rules.zig").Lang;
pub const Node  = @import("./ast/node.zig").Node;
pub const Proc  = @import("./ast/proc.zig");
pub const Ident = @import("./ast/ident.zig").Ident;
pub const Stmt  = @import("./ast/statement.zig").Stmt;
pub const Expr  = @import("./ast/expression.zig").Expr;


//______________________________________
// @section Object Fields
//____________________________
/// @descr The Allocator used by the AST object
A     :std.mem.Allocator,
/// @descr Describes which output language the AST is targeting
lang  :Lang,
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
/// @descr Creates a new AST object from the given input.
pub const create = struct {
  //____________________________
  /// @descr Creates a new AST object by parsing the contents of the {@arg code} string
  pub fn fromStr (code :cstr, A :std.mem.Allocator) !Ast {
    // Lexer
    var L = try slate.Lex.create_with(A, code);
    defer L.destroy();
    try L.process();
    // L.report();  // TODO: Report for verbose mode

    // Tokenizer
    var T = Tok.create(&L);
    defer T.destroy();
    try T.process();
    // T.report();  // TODO: Report for verbose mode

    // Parser
    var P = Par.create(&T);
    defer P.destroy();
    try P.process();
    // P.report();  // TODO: Report for verbose mode

    // Return the result
    return try P.res.clone();
  }
  //____________________________
  /// @descr Creates a new AST object by parsing the contents of the {@arg file}
  pub fn fromFile (file :cstr, A :std.mem.Allocator) !Ast {
    const code = try std.fs.cwd().readFileAlloc(A, file, 50*1024);
    defer A.free(code);
    const result = try Ast.create.fromStr(code, A);
    return result;
  }
};

//______________________________________
// @section Create Aliases
//____________________________
pub const get  = Ast.create.fromStr;
pub const read = Ast.create.fromFile;

