#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________

# Package Information
packageName   = "minc"
version       = "0.7.8"
author        = "sOkam"
description   = "ᛟ minc | Minimalistic C Language"
license       = "MIT"

# Installation Options
srcDir        = "src"
skipFiles     = @["build.nim", "nim.cfg"]
skipDirs      = @["build", "lib"]
installExt    = @["nim"]
bin           = @[packageName]

# Dependencies
requires "nim >= 1.9.1" # Technically 2.0, but boostrapped nimble gets confused
requires "https://github.com/heysokam/slate#head"
requires "https://github.com/heysokam/confy#head"
requires "https://github.com/heysokam/nstd#head"

