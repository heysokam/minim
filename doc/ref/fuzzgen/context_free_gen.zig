const std = @import("std");

const NonTerm = enum {
  /// the start symbol
  expr,

  term,
  atom,
  variable,
  number,
  digit,
};

const Symbol = union(enum) {
  term     : u8,
  non_term : NonTerm,
};

const production_rules: std.EnumArray(NonTerm, []const []const Symbol) = .init(.{
  .expr = &.{
    &.{.{ .non_term = .term }},
    &.{.{ .non_term = .expr }, .{ .term = '+' }, .{ .non_term = .term } },
    &.{.{ .non_term = .expr }, .{ .term = '-' }, .{ .non_term = .term } },
  },
  .term = &.{
    &.{.{ .non_term = .atom }},
    &.{.{ .non_term = .term }, .{ .term = '*' }, .{ .non_term = .atom } },
    &.{.{ .non_term = .term }, .{ .term = '/' }, .{ .non_term = .atom } },
  },
  .atom = &.{
    &.{.{ .non_term = .variable }},
    &.{.{ .non_term = .number }},
    &.{ .{ .term = '(' }, .{ .non_term = .expr }, .{ .term = ')' } },
  },
  .variable = &.{
    &.{.{ .term = 'x' }},
    &.{.{ .term = 'y' }},
    &.{.{ .term = 'z' }},
  },
  .number = &.{
    &.{.{ .non_term = .digit }},
    &.{.{ .non_term = .digit }, .{ .non_term = .number } },
  },
  .digit = &.{
    &.{.{ .term = '0' }},
    &.{.{ .term = '1' }},
    &.{.{ .term = '2' }},
    &.{.{ .term = '3' }},
    &.{.{ .term = '4' }},
    &.{.{ .term = '5' }},
    &.{.{ .term = '6' }},
    &.{.{ .term = '7' }},
    &.{.{ .term = '8' }},
    &.{.{ .term = '9' }},
  },
});

fn rewrite(
    list: *std.ArrayListUnmanaged(Symbol),
    random: std.Random,
    allocator: std.mem.Allocator,
  ) error{OutOfMemory}!enum { done, ongoing } {
    // search for a non-terminal in the sequence
    for (list.items, 0..) |elem, i| switch (elem) {
      .term => {},
      // found one!
      .non_term => |non_term| {
        // get all rules associated with the non-terminal
        const rules = production_rules.get(non_term);
        // and choose of them at random
        const rule = rules[random.intRangeLessThan(usize, 0, rules.len)];

        // substitute the non-terminal with the chosen rule
        _ = list.orderedRemove(i);
        try list.insertSlice(allocator, i, rule);
        return .ongoing;
      },
  };
  // did not manange to find a non-terminal
  return .done;
}

fn dump(list: []const Symbol) void {
  for (list) |elem| switch (elem) {
    .term     => |t| std.debug.print("'{c}' ", .{t}),
    .non_term => |t| std.debug.print(".{s} ", .{@tagName(t)}),
  };
  std.debug.print("\n", .{});
}

pub fn main() !void {
  // get an allocator
  var gpa: std.heap.GeneralPurposeAllocator(.{}) = .init;
  defer _ = gpa.deinit();
  const allocator = gpa.allocator();

  // get a source of randomness
  var rng: std.Random.DefaultPrng = .init(0);
  const random = rng.random();

  // create our sequence, initialise it to consist of the start symbol
  var list: std.ArrayListUnmanaged(Symbol) = .empty;
  defer list.deinit(allocator);
  try list.append(allocator, .{ .non_term = .expr });

    // apply the production rules until we can no more
  while (true) {
    dump(list.items);
    const result = try rewrite(&list, random, allocator);
    if (result == .done) break;
  }
  dump(list.items);
}
