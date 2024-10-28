//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const zig = @This();
// @deps std
const std = @import("std");
const Z   = std.zig;
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const cstr = zstd.cstr;
// @deps *Slate
const slate = @import("../lib/slate.zig");
// @deps minim
const Lang = @import("../minim/rules.zig").Lang;
const Ast  = @import("../minim/ast.zig").Ast;

const cfg = struct {
  const Prefix = "Runic: ";
  const Sep = "________________________________________";
};

const zast = struct {
  const proc = struct {
    pub fn getName (ast :Z.Ast, id :u32) cstr {
      // const protoID = ast.nodes.items(.data)[id].lhs;
      // const nameID  = ast.nodes.items(.main_token)[protoID]+1; // The name is always at:  fn+1
      // const name    = ast.tokenSlice(nameID);
      return ast.tokenSlice(ast.nodes.items(.main_token)[ast.nodes.items(.data)[id].lhs]+1);
    }
  };
};
const proc = struct {
  pub fn getNode (
      ast : Z.Ast,
      id  : u32,
    ) !Ast.Node {
    var result = slate.Proc.newEmpty();
    result.pure = false;  // Pure functions do not exist in Zig

    const protoID = ast.nodes.items(.data)[id].lhs;
    const bodyID  = ast.nodes.items(.data)[id].rhs;
    // Get the Proc.Name
    result.name   = slate.Proc.Name{.name = zast.proc.getName(ast, id)};// :Proc.Name,


    zstd.echo("............................");
    zstd.echo(zast.proc.getName(ast, id));
    zstd.echo("............................");
    // Get the Proc.ReturnT
    const retTID = ast.nodes.items(.data)[protoID].rhs;
    const retT   = ast.tokenSlice(retTID);
    zstd.echo(retT);




    // const decl    = ast.extraData(0, Z.Ast.Node.FnProto);
    const proto   = ast.nodes.items(.tag)[protoID];
    const body    = ast.nodes.items(.tag)[bodyID];
    zstd.echo("............................");
    zstd.echo(@tagName(proto));
    zstd.echo(@tagName(body));
    // zstd.prnt("{}\n", .{decl.params_end});
    zstd.echo("............................");
    // result.public  = // :bool= false,
    // result.args    = // :?Proc.Arg.List= null,
    // result.retT    = // :?Proc.ReturnT= null,
    // result.pragmas = // :?Proc.Pragma.List,
    // result.body    = // :?Proc.Body= null,
    zstd.fail("TODO: UNIMPLEMENTED | Runic | Zig AST Proc Gen\n", .{});
    return Ast.Node{.Proc = result};
  }

  // fn reference (
  //     r         : *Render,
  //     container : Container,
  //     decl      : Ast.Node.Index,
  //     space     : Space,
  //   ) void {
  //   const tree        = r.tree;
  //   const ais         = r.ais;
  //   const node_tags   = tree.nodes.items(.tag);
  //   const token_tags  = tree.tokens.items(.tag);
  //   const main_tokens = tree.nodes.items(.main_token);
  //   const datas       = tree.nodes.items(.data);
  //   if (r.fixups.omit_nodes.contains(decl)) return;
  //   try renderDocComments(r, tree.firstToken(decl));

  //   switch (node_tags[decl]) {
  //       .fn_decl => {
  //           // Some examples:
  //           // pub extern "foo" fn ...
  //           // export fn ...
  //           const fn_proto = datas[decl].lhs;
  //           const fn_token = main_tokens[fn_proto];
  //           // Go back to the first token we should render here.
  //           var i = fn_token;
  //           while (i > 0) {
  //               i -= 1;
  //               switch (token_tags[i]) {
  //                   .keyword_extern,
  //                   .keyword_export,
  //                   .keyword_pub,
  //                   .string_literal,
  //                   .keyword_inline,
  //                   .keyword_noinline,
  //                   => continue,
  //
  //                   else => {
  //                       i += 1;
  //                       break;
  //                   },
  //               }
  //           }
  //           while (i < fn_token) : (i += 1) {
  //               try renderToken(r, i, .space);
  //           }
  //           switch (tree.nodes.items(.tag)[fn_proto]) {
  //               .fn_proto_one, .fn_proto => {
  //                   const callconv_expr = if (tree.nodes.items(.tag)[fn_proto] == .fn_proto_one)
  //                       tree.extraData(datas[fn_proto].lhs, Ast.Node.FnProtoOne).callconv_expr
  //                   else
  //                       tree.extraData(datas[fn_proto].lhs, Ast.Node.FnProto).callconv_expr;
  //                   if (callconv_expr != 0 and tree.nodes.items(.tag)[callconv_expr] == .enum_literal) {
  //                       if (mem.eql(u8, "Inline", tree.tokenSlice(main_tokens[callconv_expr]))) {
  //                           try ais.writer().writeAll("inline ");
  //                       }
  //                   }
  //               },
  //               .fn_proto_simple, .fn_proto_multi => {},
  //               else => unreachable,
  //           }
  //           assert(datas[decl].rhs != 0);
  //           try renderExpression(r, fn_proto, .space);
  //           const body_node = datas[decl].rhs;
  //           if (r.fixups.gut_functions.contains(decl)) {
  //               ais.pushIndent();
  //               const lbrace = tree.nodes.items(.main_token)[body_node];
  //               try renderToken(r, lbrace, .newline);
  //               try discardAllParams(r, fn_proto);
  //               try ais.writer().writeAll("@trap();");
  //               ais.popIndent();
  //               try ais.insertNewline();
  //               try renderToken(r, tree.lastToken(body_node), space); // rbrace
  //           } else if (r.fixups.unused_var_decls.count() != 0) {
  //               ais.pushIndentNextLine();
  //               const lbrace = tree.nodes.items(.main_token)[body_node];
  //               try renderToken(r, lbrace, .newline);
  //
  //               var fn_proto_buf: [1]Ast.Node.Index = undefined;
  //               const full_fn_proto = tree.fullFnProto(&fn_proto_buf, fn_proto).?;
  //               var it = full_fn_proto.iterate(&tree);
  //               while (it.next()) |param| {
  //                   const name_ident = param.name_token.?;
  //                   assert(token_tags[name_ident] == .identifier);
  //                   if (r.fixups.unused_var_decls.contains(name_ident)) {
  //                       const w = ais.writer();
  //                       try w.writeAll("_ = ");
  //                       try w.writeAll(tokenSliceForRender(r.tree, name_ident));
  //                       try w.writeAll(";\n");
  //                   }
  //               }
  //               var statements_buf: [2]Ast.Node.Index = undefined;
  //               const statements = switch (node_tags[body_node]) {
  //                   .block_two,
  //                   .block_two_semicolon,
  //                   => b: {
  //                       statements_buf = .{ datas[body_node].lhs, datas[body_node].rhs };
  //                       if (datas[body_node].lhs == 0) {
  //                           break :b statements_buf[0..0];
  //                       } else if (datas[body_node].rhs == 0) {
  //                           break :b statements_buf[0..1];
  //                       } else {
  //                           break :b statements_buf[0..2];
  //                       }
  //                   },
  //                   .block,
  //                   .block_semicolon,
  //                   => tree.extra_data[datas[body_node].lhs..datas[body_node].rhs],
  //
  //                   else => unreachable,
  //               };
  //               return finishRenderBlock(r, body_node, statements, space);
  //           } else {
  //               return renderExpression(r, body_node, space);
  //           }
  //       },
  //       .fn_proto_simple,
  //       .fn_proto_multi,
  //       .fn_proto_one,
  //       .fn_proto,
  //       => {
  //           // Extern function prototypes are parsed as these tags.
  //           // Go back to the first token we should render here.
  //           const fn_token = main_tokens[decl];
  //           var i = fn_token;
  //           while (i > 0) {
  //               i -= 1;
  //               switch (token_tags[i]) {
  //                   .keyword_extern,
  //                   .keyword_export,
  //                   .keyword_pub,
  //                   .string_literal,
  //                   .keyword_inline,
  //                   .keyword_noinline,
  //                   => continue,
  //
  //                   else => {
  //                       i += 1;
  //                       break;
  //                   },
  //               }
  //           }
  //           while (i < fn_token) : (i += 1) {
  //               try renderToken(r, i, .space);
  //           }
  //           try renderExpression(r, decl, .none);
  //           return renderToken(r, tree.lastToken(decl) + 1, space); // semicolon
  //       },
  //   } //:: switch
  // }
};

pub fn get2 (
    src  : cstr,
    in   : Ast.create.Options,
    A    : std.mem.Allocator,
  ) !Ast {
  var result = Ast.create.empty(Lang.Zig, A);
  // Get the Zig AST
  const code = try A.dupeZ(u8, src);
  defer A.free(code);
  var ast = try Z.Ast.parse(A, code, Z.Ast.Mode.zig);
  defer ast.deinit(A);
  if (ast.errors.len != 0) zstd.fail("Zig Ast | Cannot process an invalid tree.\n", .{}); // 
  if (in.verbose) zstd.echo(cfg.Prefix++"Processing Zig SourceCode ...\n"++cfg.Sep);
  if (in.verbose) zstd.echo(src);
  if (in.verbose) zstd.echo(cfg.Sep);


  for (ast.rootDecls()) |id| switch (ast.nodes.items(.tag)[id]) {
    .fn_decl => try result.add(try proc.getNode(ast, id)),
    else     => zstd.fail("Zig Ast | Node kind not implemented : {s}\n", .{@tagName(ast.nodes.items(.tag)[id])}),
  };
  for (ast.rootDecls()) |id| zstd.echo(@tagName(ast.nodes.items(.tag)[id]));
  zstd.echo(cfg.Sep);

  zstd.fail("TODO: UNIMPLEMENTED | Runic | Zig AST Gen\n", .{});
  return result;
}

