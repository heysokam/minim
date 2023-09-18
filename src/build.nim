#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/os except `/`
# confy dependencies
when not defined(nimble):
  import ../../../ndk/confy/src/confy
else:
  import confy

var cminGen = Program.new(cfg.srcDir/"slate"/"gen"/"cmin.nim", "cminGen")
os.removeFile( cfg.binDir/cminGen.trg )
cminGen.build( @[cminGen.trg.string], run=true, force=true )

var cmin = Program.new(cfg.srcDir/"slate"/"cmin.nim", "cmin")
os.removeFile( cfg.binDir/cmin.trg )
cmin.build( @["all", cmin.trg.string], run=true, force=true )
os.removeFile( cfg.binDir/cmin.trg )
