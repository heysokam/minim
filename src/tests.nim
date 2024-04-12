# @deps ndk
import confy

#_______________________________________
# Configuration
cfg.libDir        = cfg.srcDir/"lib"
cfg.srcDir        = cfg.rootDir/"tests"
cfg.nim.systemBin = off

#_______________________________________
# Build
build Program.new(
  src  = cfg.srcDir/"tMinC.nim",
  deps = Dependencies.new(
    submodule( "nstd",  "https://github.com/heysokam/nstd"  ),
    ), # << Dependencies.new( ... )
  args = "--warning:UnusedImport:off"
  ), run=true # << Program.new( ... )
