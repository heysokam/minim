const confy = @import("./src/lib/confy.zig").buildzig;
pub fn build(B :*@import("std").Build) void {
  confy.run(B);
}
