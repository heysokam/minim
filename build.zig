//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps confy
const confy   = @import("./src/lib/confy.zig");
const Package = confy.Package;
const Name    = confy.Name;
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
  .name    = confy.Name{ .short= name, .human= description },
  .author  = author,
  .license = license,
  .git     = Git.Info{ .owner= author.short, .repo= name },
};


//______________________________________
// @section Build Targets
//____________________________
var minim = confy.BuildTrg{
  .kind    = .static,
  .trg     = P.name.short,
  .src     = "src/minim.zig",
  .version = P.version,
};
var M = confy.BuildTrg{
  .kind    = .program,
  .trg     = "M",
  .src     = "src/M.zig",
  .version = P.version,
};
var tests = confy.BuildTrg{
  .kind    = .unittest,
  .trg     = "tests",
  .src     = "src/tests.zig",
  .version = P.version,
};



//______________________________________
// @section Declare Build Options
//____________________________
pub fn build(b :*@import("std").Build) void {
  minim.declare(b);
  minim.build();
  M.declare(b);
  M.build();
  tests.declare(b);
}

