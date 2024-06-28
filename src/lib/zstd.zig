//:____________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
//! @fileoverview Cable connector to all zstd.Core modules
//__________________________________________________________|
// @section Forward Exports for other modules
pub const log   = @import("./zstd/log.zig");
pub const shell = @import("./zstd/shell.zig");
pub const T     = @import("./zstd/types.zig");


//______________________________________
// @section Logger.Core Exports
//____________________________
pub const echo = log.echo;
pub const prnt = log.prnt;
pub const fail = log.fail;


//______________________________________
// @section Shell.Core Exports
//____________________________
pub const sh = shell.zsh;

