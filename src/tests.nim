# @deps ndk
import confy
import nstd/logger
import ./minc/cfg as minc

#_______________________________________
# Configuration
cfg.libDir        = cfg.srcDir/"lib"
cfg.srcDir        = cfg.rootDir/"tests"
cfg.nim.systemBin = off
logger.init(minc.Prefix)

#_______________________________________
# Build: MinC
withDir rootDir: sh "spry build"

#_______________________________________
# Build: Test Runner
build Program.new(
  src  = cfg.srcDir/"tMinC.nim",
  deps = Dependencies.new(
    submodule( "nstd",  "https://github.com/heysokam/nstd"  ),
    ), # << Dependencies.new( ... )
  args = "--warning:UnusedImport:off"
  ), run=true # << Program.new( ... )
