fn thing(one: *i32) u32 { return 0; }
fn other(one: i32, two: i32, thr: *i32) u32 { return 0; }
fn stuff(one: *u64, two: *const i32) i8 { return 0; }

fn withArrays(
    arg00: [1]i32,
    arg01: [1]*i32,
    arg02: []i32,
    arg03: []*i32,
    arg04: [4]*const i32,
    arg05: []*const i32,
) i32 {
    return 0;
}
