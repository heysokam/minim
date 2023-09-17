#:____________________________________________________
#  cmin  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# std dependencies
import std/os except `/`
# confy dependencies
when not defined(nimble):
  import ../../../ndk/confy/src/confy
else:
  import confy

var tester = Program.new(cfg.srcDir/"cmin.nim", "cmin")
os.removeFile( cfg.binDir/tester.trg )
tester.build( @["all"], run=true, force=true )
