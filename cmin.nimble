#:____________________________________________________
#  cmin  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# Package
packageName   = "cmin"
version       = "0.0.0"
author        = "sOkam"
description   = "Min C"
license       = "MIT"
srcDir        = "src"
skipFiles     = @["build.nim", "nim.cfg"]
installExt    = @["nim"]
bin           = @[packageName]
# Dependencies
requires "nim >= 2.0.0"
