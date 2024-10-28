//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const C = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const cstr = zstd.cstr;
// @deps minim
const Ast = @import("../minim/ast.zig").Ast;

// const arocc = @import("./C/arocc.zig");
// const clang = @import("./C/clang.zig");

pub fn get2 (
    src  : cstr,
    in   : Ast.create.Options,
    A    : std.mem.Allocator,
  ) !Ast { _=in; _=A;
  zstd.echo("::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::");
  // const ast = try arocc.ast.get(src, A);
  // zstd.echo(ast.generated);
  zstd.echo(src);
  zstd.echo("::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::");
  zstd.fail("TODO: UNIMPLEMENTED | Runic | C AST Gen\n", .{});
  return undefined;
}




//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// const clang = @import("../../../../runic/C/clang.zig");
// const std = @import("std");
// fn visitor (
//     curr   : clang.visit.Cursor,
//     parent : clang.visit.Cursor,
//     data   : clang.visit.Data
//   ) callconv(.C) clang.visit.Result {
//   _=curr; _=parent; _=data; 
//   std.debug.print("..................\n", .{});
//   return .Continue;
// }
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// test "clang.tmp" {
//   // @deps clang
//
//   try t.ok(true);
//
//   const index = clang.Index.create();
//   defer index.destroy();
//   const tu = try clang.TranslationUnit.parse(index, "test.c", .{.detailedProcessingRecord= true});
//   defer tu.destroy();
//   const root = clang.Cursor.create(tu);
//   _ = root.visitChildren(null, visitor);
// }
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// var index  = clang.createIndex(0, 0)
// var unit = clang.parseTranslationUnit(index, fname.cstring,
// for i in 0..<unit.getNumDiagnostics:  # TODO:
//   let diagnostic = unit.getDiagnostic(i)  # TODO:
//   var location = diagnostic.getDiagnosticLocation()  # TODO:
//   location.getExpansionLocation(file.addr, line.addr, column.addr, offset.addr)  # TODO:
//   let position = $file.getFileName & ":" & $line & ":" & $column & " " & $offset  # TODO:
//   case diagnostic.getDiagnosticSeverity():  # TODO:
//     of CXDiagnostic_Ignored : discard
//     of CXDiagnostic_Note    : stderr.writeLine "\t", diagnostic.getDiagnosticSpelling(), " ", position  # TODO:
//     of CXDiagnostic_Warning : stderr.writeLine yellow "Warning: ", diagnostic.getDiagnosticSpelling(), " ", position  # TODO:
//     of CXDiagnostic_Error   : stderr.writeLine red "Error: ", diagnostic.getDiagnosticSpelling(), " ", position  # TODO:
//     of CXDiagnostic_Fatal   : stderr.writeLine red "Fatal: ", diagnostic.getDiagnosticSpelling(), " ", position; fatal = true  # TODO:
// var cursor = getTranslationUnitCursor(unit)
// discard visitChildren(cursor, proc (c, parent: CXCursor, clientData: CXClientData): enumCXChildVisitResult {.cdecl.} =
// disposeTranslationUnit(unit)
// disposeIndex(index)

