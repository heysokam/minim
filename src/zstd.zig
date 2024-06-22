//:____________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
//! @fileoverview Cable connector to all zstd.Core modules
//__________________________________________________________|
const zstd_log = @import("./zstd/log.zig");


//______________________________________
// @section Logger.Core Exports
//____________________________
pub const log = zstd_log;
pub const echo = zstd_log.echo;

