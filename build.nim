#:_______________________________________________________________________
#  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
#:_______________________________________________________________________
import confy
import ./info
from std/os import `/`

const cfg_verbose = true

#______________________________________
# @section Package Information
#____________________________
const P = package.Info(
  version     : Version.parse(info.version),
  name        : info.name,
  author      : Name(short:info.author),
  license     : info.license,
  description : info.description,
  url         : "https://github.com"/info.author/info.name,
  ) #:: package.Info

#______________________________________
# @section Dependencies
#____________________________
const deps_zstd  = Dependency(name: "zstd",     url:"https://github.com/heysokam/zstd" )
const deps_slate = Dependency(name: "slate",    url:"https://github.com/heysokam/slate")
const deps_mtest = Dependency(name: "minitest", url:"https://github.com/heysokam/minitest")
const deps_minim = @[deps_zstd, deps_slate]
const deps_tests = deps_minim & deps_mtest

#______________________________________
# @section Build Targets
#____________________________
var lib   = StaticLib.new(entry= "minim.zig", version= P.version, deps= deps_minim)
var minim =   Program.new(entry=     "M.zig", version= P.version, deps= deps_minim)
var tests =  UnitTest.new(entry= "tests.zig", version= P.version, deps= deps_tests) # flags = .{.ld= &.{"-lclang"}},

#______________________________________
# @section Config
#____________________________
lib.cfg.verbose   = cfg_verbose
minim.cfg.verbose = cfg_verbose
tests.cfg.verbose = cfg_verbose

#______________________________________
# @section Entry Point
#____________________________
P.report()
minim.build()
tests.build()
# lib.build()

