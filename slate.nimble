#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# Package
packageName   = "slate"
version       = "0.0.5"
author        = "sOkam"
description   = "*Slate | StoS Compiler for Nim"
license       = "MIT"
srcDir        = "src"
skipFiles     = @["build.nim", "nim.cfg"]
installExt    = @["nim"]
bin           = @[packageName]
# Dependencies
requires "nim >= 2.0.0"
