#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/os except `/`
# confy dependencies
when not defined(nimble):
  import ../../../ndk/confy/src/confy
else:
  import confy

var mincGen = Program.new(cfg.srcDir/"slate"/"gen"/"minc.nim", "mincGen")
os.removeFile( cfg.binDir/mincGen.trg )
mincGen.build( @[mincGen.trg.string], run=true, force=true )

var minc = Program.new(cfg.srcDir/"slate"/"minc.nim", "minc")
os.removeFile( cfg.binDir/minc.trg )
minc.build( @["all", minc.trg.string], run=false, force=false )
