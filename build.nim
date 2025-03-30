#:_______________________________________________________________________
#  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
#:_______________________________________________________________________
import confy
import ./info

const cfg_verbose = true

#______________________________________
# @section Package Information
#____________________________
const P = package.Info(
  version     : Version.parse(info.version),
  name        : info.name,
  author      : info.author,
  license     : info.license,
  description : info.description
  ) #:: package.Info

#______________________________________
# @section Dependencies
#____________________________
const deps_zstd  = Dependency(name: "zstd",  url: "https://github.com/heysokam/zstd" )
const deps_slate = Dependency(name: "slate", url: "https://github.com/heysokam/slate")
const deps_ztest = Dependency(name: "ztest", url: "https://github.com/heysokam/ztest")
const deps_minim = @[deps_zstd, deps_slate]
const deps_tests = deps_minim & deps_ztest

#______________________________________
# @section Build Targets
#____________________________
var minim = StaticLib.new(entry= "minim.zig", version= P.version, deps= deps_minim)
var M     =   Program.new(entry=     "M.zig", version= P.version, deps= deps_minim)
var tests =  UnitTest.new(entry= "tests.zig", version= P.version, deps= deps_tests) # flags = .{.ld= &.{"-lclang"}},

#______________________________________
# @section Config
#____________________________
minim.cfg.verbose = cfg_verbose
M.cfg.verbose     = cfg_verbose
tests.cfg.verbose = cfg_verbose

#______________________________________
# @section Entry Point
#____________________________
P.report()
M.build()
tests.build()
# minim.build()
# M.run()

