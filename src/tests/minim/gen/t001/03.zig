fn args01 (one :i32, two :i32) u32 { return 0; }
fn args02 (one :*const i32, two :*const i32) u32 { return 0; }
fn args03 (one :*const i32, two :*const i32) u32 { return 0; }
fn args04 (one :[1]u32, two :[1]u32) u32 { return 0; }
fn args05 (one :[2]*u32, two :[2]*u32) u32 { return 0; }
fn args06 (one :[3]*const u32, two :[3]*const u32) u32 { return 0; }
fn args07 (one :[]const u32, two :[]const u32) u32 { return 0; }
fn args08 (one :[]const *u32, two :[]const *u32) u32 { return 0; }
fn args09 (one :[]const *const u32, two :[]const *const u32) u32 { return 0; }
fn args10 (one :[4]?u32, two :[4]?u32) u32 { return 0; }
fn args11 (one :[]const ?u32, two :[]const ?u32) u32 { return 0; }
fn args01_opt (one :?i32, two :?i32) u32 { return 0; }
fn args02_opt (one :?*const i32, two :?*const i32) u32 { return 0; }
fn args03_opt (one :?*const i32, two :?*const i32) u32 { return 0; }
fn args04_opt (one :?[1]u32, two :?[1]u32) u32 { return 0; }
fn args05_opt (one :?[2]*u32, two :?[2]*u32) u32 { return 0; }
fn args06_opt (one :?[3]*const u32, two :?[3]*const u32) u32 { return 0; }
fn args07_opt (one :?[]const u32, two :?[]const u32) u32 { return 0; }
fn args08_opt (one :?[]const *u32, two :?[]const *u32) u32 { return 0; }
fn args09_opt (one :?[]const *const u32, two :?[]const *const u32) u32 { return 0; }
fn args10_opt (one :?[4]?u32, two :?[4]?u32) u32 { return 0; }
fn args11_opt (one :?[]const ?u32, two :?[]const ?u32) u32 { return 0; }
fn args01_mut (one :i32, two :i32) u32 { return 0; }
fn args02_mut (one :*i32, two :*i32) u32 { return 0; }
fn args03_mut (one :*i32, two :*i32) u32 { return 0; }
fn args04_mut (one :[1]u32, two :[1]u32) u32 { return 0; }
fn args05_mut (one :[2]*u32, two :[2]*u32) u32 { return 0; }
fn args06_mut (one :[3]*const u32, two :[3]*const u32) u32 { return 0; }
fn args07_mut (one :[]u32, two :[]u32) u32 { return 0; }
fn args08_mut (one :[]*u32, two :[]*u32) u32 { return 0; }
fn args09_mut (one :[]*const u32, two :[]*const u32) u32 { return 0; }
fn args10_mut (one :[4]?u32, two :[4]?u32) u32 { return 0; }
fn args11_mut (one :[]?u32, two :[]?u32) u32 { return 0; }
fn args01_mopt (one :?i32, two :?i32) u32 { return 0; }
fn args02_mopt (one :?*i32, two :?*i32) u32 { return 0; }
fn args03_mopt (one :?*i32, two :?*i32) u32 { return 0; }
fn args04_mopt (one :?[1]u32, two :?[1]u32) u32 { return 0; }
fn args05_mopt (one :?[2]*u32, two :?[2]*u32) u32 { return 0; }
fn args06_mopt (one :?[3]*const u32, two :?[3]*const u32) u32 { return 0; }
fn args07_mopt (one :?[]u32, two :?[]u32) u32 { return 0; }
fn args08_mopt (one :?[]*u32, two :?[]*u32) u32 { return 0; }
fn args09_mopt (one :?[]*const u32, two :?[]*const u32) u32 { return 0; }
fn args10_mopt (one :?[4]?u32, two :?[4]?u32) u32 { return 0; }
fn args11_mopt (one :?[]?u32, two :?[]?u32) u32 { return 0; }
fn rett01 () u32 { return 0; }
fn rett02 () *const u32 { return 0; }
fn rett03 () *const u32 { return 0; }
fn rett04 () [1]u32 { return 0; }
fn rett05 () [2]*u32 { return 0; }
fn rett06 () [3]*const u32 { return 0; }
fn rett07 () []const u32 { return 0; }
fn rett08 () []const *u32 { return 0; }
fn rett09 () []const *const u32 { return 0; }
fn rett10 () [4]?u32 { return 0; }
fn rett11 () []const ?u32 { return 0; }
fn rett01_opt () ?u32 { return 0; }
fn rett02_opt () ?*const u32 { return 0; }
fn rett03_opt () ?*const u32 { return 0; }
fn rett04_opt () ?[1]u32 { return 0; }
fn rett05_opt () ?[2]*u32 { return 0; }
fn rett06_opt () ?[3]*const u32 { return 0; }
fn rett07_opt () ?[]const u32 { return 0; }
fn rett08_opt () ?[]const *u32 { return 0; }
fn rett09_opt () ?[]const *const u32 { return 0; }
fn rett10_opt () ?[4]?u32 { return 0; }
fn rett11_opt () ?[]const ?u32 { return 0; }
fn rett01_mut () u32 { return 0; }
fn rett02_mut () *u32 { return 0; }
fn rett03_mut () *u32 { return 0; }
fn rett04_mut () [1]u32 { return 0; }
fn rett05_mut () [2]*u32 { return 0; }
fn rett06_mut () [3]*const u32 { return 0; }
fn rett07_mut () []u32 { return 0; }
fn rett08_mut () []*u32 { return 0; }
fn rett09_mut () []*const u32 { return 0; }
fn rett10_mut () [4]?u32 { return 0; }
fn rett11_mut () []?u32 { return 0; }
fn rett01_mopt () ?u32 { return 0; }
fn rett02_mopt () ?*u32 { return 0; }
fn rett03_mopt () ?*u32 { return 0; }
fn rett04_mopt () ?[1]u32 { return 0; }
fn rett05_mopt () ?[2]*u32 { return 0; }
fn rett06_mopt () ?[3]*const u32 { return 0; }
fn rett07_mopt () ?[]u32 { return 0; }
fn rett08_mopt () ?[]*u32 { return 0; }
fn rett09_mopt () ?[]*const u32 { return 0; }
fn rett10_mopt () ?[4]?u32 { return 0; }
fn rett11_mopt () ?[]?u32 { return 0; }
fn args_multiline1 (one :i32, two :i32, thr :*i32) u32 { return 0; }
fn args_multiline2 (one :*const u64, two :*const i32) u32 { return 0; }
fn args_multiline3 (arg00 :[1]i32, arg01 :[1]*const i32, arg02 :[]const i32, arg03 :[]const *i32, arg04 :[]const *const i32, arg05 :[4]*const i32, arg06 :[]*const i32) u32 { return 0; }
pub extern fn protoFn (arg0 :i32) SomeError!i32;
inline fn inlineFn () SomeError!*const u32 { return 0; }
extern fn cursed (one :?[]?*const u32, two :?[]?*const u32) SomeError!?[]?*const u32;
