//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps zstd
const zstd = @import("./lib/zstd.zig");
const echo = zstd.echo;
// @deps confy
const confy   = @import("./lib/confy.zig");
const Name    = confy.Name;
const Package = confy.Package;
const Git     = confy.Git;


//______________________________________
// @section Package Information
//____________________________
const version     = "0.0.0";
const name        = "minim";
const description = "ᛟ minim | Programming Language";
const license     = "LGPLv3-or-later";
const author      = Name{ .short= "heysokam", .human= ".sOkam!" };
//________________________
const P = confy.Package.Info{
  .version = version,
  .name    = Name{ .short= name, .human= description },
  .author  = author,
  .license = license,
  .git     = Git.Info{ .owner= author.short, .repo= name },
};




pub fn main () !u8 {
  // Initialize the confy builder
  var builder = try confy.init(); defer builder.term();
  //______________________________________
  // @section Build Targets
  //____________________________
  // var minim = confy.StaticLib(.{
  //   .kind    = .static,
  //   .trg     = P.name.short,
  //   .entry   = "src/minim.zig",
  //   .version = P.version,
  // }, builder);
  var M = try confy.Program(.{
    .trg     = "M",
    .entry   = "src/M.zig",
    .version = P.version,
  }, &builder);
  var tests = try confy.UnitTest(.{
    .trg     = "tests",
    .entry   = "src/tests.zig",
    .version = P.version,
  }, &builder);

  P.report();
  try tests.build();
  try M.build();
  try M.run();
  return 0;
}

