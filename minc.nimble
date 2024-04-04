#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# Package
packageName   = "minc"
version       = "0.4.9"
author        = "sOkam"
description   = "ᛟ minc | Minimalistic C Language"
license       = "MIT"
srcDir        = "src"
skipFiles     = @["build.nim", "nim.cfg"]
skipDirs      = @["build", "lib"]
installExt    = @["nim"]
bin           = @[packageName]
# Dependencies
requires "nim >= 2.0.0"
requires "https://github.com/heysokam/slate#head"
requires "https://github.com/heysokam/confy#head"
requires "https://github.com/heysokam/nstd#head"
