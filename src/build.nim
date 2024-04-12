#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps confy
import confy

cfg.verbose       = off
cfg.quiet         = on
cfg.libdir        = cfg.srcDir/"lib"
cfg.nim.systemBin = off

var minc = Program.new(
  src  = cfg.srcDir/"minc.nim",
  deps = Dependencies.new(
    submodule( "nstd",  "https://github.com/heysokam/nstd"  ),
    submodule( "slate", "https://github.com/heysokam/slate" ),
    ) # << Dependencies.new( ... )
  ) # << Program.new( ... )
rm cfg.binDir/minc.trg
minc.build( run=false, force=false )

