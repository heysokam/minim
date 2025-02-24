//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
// @deps std
const std = @import("std");
// @deps minim
const M = @import("../../../minim.zig");
const slate = @import("slate");
// @deps minim.tests
const t  = @import("../base.zig");
const it = t.it;


//______________________________________
// @section Compilation Target: Zig
//____________________________
var  Zig = t.title("minim.CC | Target: Zig");
test Zig { Zig.begin(); defer Zig.end();
// const lang = M.Lang.Zig;

} //:: minim.CC | Target: Zig
