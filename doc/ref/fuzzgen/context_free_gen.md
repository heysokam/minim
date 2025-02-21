## Background and theory
To create a program that generates arbitrary strings conforming to a given
grammar, specified by BNF / EBNF / ABNF we must first understand some theory.

All of the grammar specification schemes above are just different syntaxes to
specify *context-free-grammars* (with shorthands added to some, for
convenience's sake) - what are context-free-grammars (CFGs) then? A CFG is a
type of *generative grammar*, with some restrictions for their production
rules. Okay... What's a generative grammar then? Generative grammars are a
certain formalisation, invented by the linguist Noam Chomsky in the 1950s,
originally to study natural languages (e.g.English), and quickly adopted by
computer scientists to describe programming languages.

A generative grammar consists of:
- a (finite) set of *non-terminal symbols* denoted `N`,
- a (finite) set of *terminal symbols* denoted `Σ` (the sets are disjoint),
- a *start symbol* - which is a non-terminal denoted `S`, and finally
- a set of *production rules* denoted `P` - which are mappings from sequences
of terminals and non-terminals into other sequences of terminals and
non-terminals.

A generative grammar describes a *language*: a (possibly empty, possibly
infinite) set of sequences of terminal symbols (a.k.a. strings). The language
consists of all such sequences which can be achieved by the following method:
1. Begin with a sequence of length one, consisting only of the start symbol.
2. Scan the sequence for a sub-sequence that appears in a production rule.
3. Substitute the sub-sequence with its mapping.
4. Repeat steps 2 and 3 as much as you want.

The restriction CFGs have over general generative grammars is that each of the
production rules must map from *a single non-terminal* into a sequence of
terminals and non-terminals.

## A simple example
Below is a simple generative grammar, that specifies a language of laughs -
each laugh consists of one or more segments, each beginning with a `h` followed
by one or more `a`s. The segments are separated with spaces.

- our set of non-terminals will be defined `N = { laugh, segment, tail }`,
- our set of terminals will be defined `Σ = { 'h', 'a', ' ' }`,
- our start symbol will be `S = laugh`, lastly
- our production rules `P` will be defined as written in the following table:
```
1. laugh   -> segment
2. laugh   -> segment ' ' laugh
3. segment -> 'h' tail
4. tail    -> 'a'
5. tail    -> 'a' tail
```
The language is indeed context-free since the left-hand-side of all rules
consist of a single non-terminal.

Let's apply the steps and see what kind of string we can generate:
```
laugh
(via rule 2) segment ' ' laugh
(via rule 2) segment ' ' segment ' ' laugh
(via rule 3) segment ' ' 'h' tail ' ' laugh
(via rule 4) segment ' ' 'h' 'a' ' ' laugh
(via rule 3) 'h' tail ' ' 'h' 'a' ' ' laugh
(via rule 1) 'h' tail ' ' 'h' 'a' ' ' segment
(via rule 5) 'h' 'a' tail ' ' 'h' 'a' ' ' segment
(via rule 5) 'h' 'a' 'a' tail ' ' 'h' 'a' ' ' segment
(via rule 4) 'h' 'a' 'a' 'a' ' ' 'h' 'a' ' ' segment
(via rule 3) 'h' 'a' 'a' 'a' ' ' 'h' 'a' ' ' 'h' tail
(via rule 5) 'h' 'a' 'a' 'a' ' ' 'h' 'a' ' ' 'h' 'a' tail
(via rule 4) 'h' 'a' 'a' 'a' ' ' 'h' 'a' ' ' 'h' 'a' 'a'
```
After the final application we have no more rules we can apply - let's see what
we ended up with... removing all the quotes and spacings we get `haaa ha haa` -
quite the laugh!

## The program
The program we'll create will generate an arbitrary string of some language
defined below, it is quite a bare-bones, but should be enough to understand all
the core ideas.

The language that will be used describes a arithmetic expressions, consisting
of numbers (e.g. `1`, `42`, `31415`, `007`), variables (the single letters `x`,
`y`, `z`), the four fundamental operations (`+`, `-`, `*`, `/`), and also
parentheses. Here it is in BNF:
```
<expr> ::= <term> | <expr> "+" <term> | <expr> "-" <term>
<term> ::= <atom> | <term> "*" <atom> | <term> "/" <atom>
<atom> ::= <var> | <num> | "(" <expr> ")"
<var> ::= "x" | "y" | "z"
<num> ::= <digit> | <digit> <num>
<digit> ::= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
```
Written as production rules:
```
expr -> term
expr -> expr '+' term
expr -> expr '-' term

term -> atom
term -> term '*' atom
term -> term '/' atom

atom -> var
atom -> num
atom -> '(' expr ')'

var -> 'x'
var -> 'y'
var -> 'z'

num -> digit
num -> digit num

digit -> '0'
digit -> '1'
digit -> '2'
digit -> '3'
digit -> '4'
digit -> '5'
digit -> '6'
digit -> '7'
digit -> '8'
digit -> '9'
```
The set of terminals will be represented as a simple `u8`, the set of
non-terminals will be represented as the following Zig `enum`:
```zig
const NonTerm = enum {
    /// the start symbol
    expr,

    term,
    atom,
    variable,
    number,
    digit,
};
```
To represent a value that may either be a terminal symbol, or a non-terminal
symbol, we'll use a tagged `union`:
```zig
const Symbol = union(enum) {
    term: u8,
    non_term: NonTerm,
};
```
The production rules will be represented as a `std.EnumArray` from `NonTerm`s
to `[]const []const Symbol` - that is, each non-terminal has zero or more rules
associated with it (`[]const ...`), each of them being a sequence of symbols
(`[]const Symbol`):
```zig
const production_rules: std.EnumArray(NonTerm, []const []const Symbol) = .init(.{
    .expr = &.{
        &.{.{ .non_term = .term }},
        &.{ .{ .non_term = .expr }, .{ .term = '+' }, .{ .non_term = .term } },
        &.{ .{ .non_term = .expr }, .{ .term = '-' }, .{ .non_term = .term } },
    },
    .term = &.{
        &.{.{ .non_term = .atom }},
        &.{ .{ .non_term = .term }, .{ .term = '*' }, .{ .non_term = .atom } },
        &.{ .{ .non_term = .term }, .{ .term = '/' }, .{ .non_term = .atom } },
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
        &.{ .{ .non_term = .digit }, .{ .non_term = .number } },
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
```
Our workhorse function will be dubbed `rewrite`, it'll take in
- a sequence of symbols `list: *std.ArrayListUnmanaged(Symbol)`, and
- a source of randomness: `random: std.Random`, as well as
- an allocator `allocator: std.mem.Allocator`.

The function will search the sequence for a non-terminal symbol, when it finds
one, it'll remove it from the sequence, replacing it with one of its associated
production rules.

The function will also return a value:
- `.ongoing` if the sequence was modified successfully, or
- `.done` if the sequence consists entirely of terminal symbols.
```zig
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
    // did not manage to find a non-terminal
    return .done;
}
```
Our `main` function will initialise a sequence to be the start symbol, and run
`rewrite` on it in a loop, until we have exhausted all non-terminals - we'll
print the sequence's state along each rewrite step:
```zig
fn dump(list: []const Symbol) void {
    for (list) |elem| switch (elem) {
        .term => |c| std.debug.print("'{c}' ", .{c}),
        .non_term => |non_term| std.debug.print(".{s} ", .{@tagName(non_term)}),
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
```
Running the program, we get as output:
```
.expr 
.term 
.term '*' .atom 
.term '*' .atom '*' .atom 
.atom '*' .atom '*' .atom 
.number '*' .atom '*' .atom 
.digit '*' .atom '*' .atom 
'8' '*' .atom '*' .atom 
'8' '*' '(' .expr ')' '*' .atom 
'8' '*' '(' .term ')' '*' .atom 
'8' '*' '(' .atom ')' '*' .atom 
'8' '*' '(' .variable ')' '*' .atom 
'8' '*' '(' 'x' ')' '*' .atom 
'8' '*' '(' 'x' ')' '*' .variable 
'8' '*' '(' 'x' ')' '*' 'x' 
'8' '*' '(' 'x' ')' '*' 'x'
```
We have successfully generated the grammatically correct string `8*(x)*x`!

Here are some other generated strings, obtained by changing the random number
generator's seed:
- seed = 3 `y*5/y/4*z`
- seed = 10 `(1/37-z)/z`
- seed = 12 `590/34-z-(719)*2/z*0/x*39+x`

## Issues and future ideas
If you'll run the program with other seeds you'll quickly find that most of
them create extremely long strings; how can we ensure the strings we get will
be of a reasonable length, and that the program will even terminate in the
first place?

One solution is to have a length bound: if the sequence ever reaches a certain
length, we'll switch our set of production rules to a different one: a subset
of the former that only contains rules that don't make the string grow, or at
the very least, are known to get rid of all non-terminals eventually; here's
how the subset might look like for the language above:
```
<expr> ::= <term>
<term> ::= <atom>
<atom> ::= <var> | <num>
<var> ::= "x" | "y" | "z"
<num> ::= <digit>
<digit> ::= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
```
Another solution is to mark each rule as either "growing" or "shrinking", the
choice of the rule to apply can then be biased to prefer growing rules if the
sequence is shorter than some target, and conversely to prefer shrinking rules
if the sequence is longer than the target.

- This program generates random strings from the language - is there a way to
exhaustively go though *all* strings in a language, ensuring we'll eventually
reach any arbitrary one?

- This program is specific to the grammar we wrote - can you genericise it to
take a grammar as an input parameter?

- This program is quite inefficient, having to move around many items on each
modification of the sequence - can it be made better?
