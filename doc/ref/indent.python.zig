const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const TokenType = enum { indent, dedent };
const Token = struct { kind: TokenType };

fn tokenize (
    input     : []const u8,
    allocator : Allocator,
  ) !ArrayList(Token) {
  var result = ArrayList(Token).init(allocator);
  errdefer result.deinit();

  var stack = ArrayList(usize).init(allocator);
  defer stack.deinit();
  try stack.append(0);

  var lines = std.mem.tokenizeAny(u8, input, "\n");
  while (lines.next()) |line| {
    var indent: usize = 0;
    while (indent < line.len and line[indent] == ' ') : (indent += 1) {}

    if (indent > stack.items[stack.items.len - 1]) {
      try stack.append(indent);
      try result.append(.{ .kind = .indent });
    } else {
      while (indent < stack.items[stack.items.len - 1]) {
        _ = stack.pop();
        try result.append(.{ .kind = .dedent });
      }
    }
  }

  while (stack.items.len > 1) {
    _ = stack.pop();
    try result.append(.{ .kind = .dedent });
  }

  return result;
}

pub fn main() !void {
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const A = arena.allocator();
  const src =
    \\
    \\  astarstra
    \\    asrt astarstrs
    \\      arstarst
    \\    asrt astarstrs
    \\     astart asrtarstrastrs ast
    \\      astart asrtarstrastrs ast
    \\
    ;
  const tokens = try tokenize(src, A);
  for (tokens.items) |tk| std.debug.print("{any}\n", .{tk});
}
