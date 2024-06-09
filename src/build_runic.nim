#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
import confy

confy.cfg.nim.systemBin = off

let runic = Program.new(
  src  = cfg.srcDir/"runic.nim",
  deps = Dependencies.new(
    submodule( "nstd", "https://github.com/heysokam/nstd" ),
    ), # << Dependencies.new( ... )
  ) # << Program.new( ... )
runic.build(run=true)

