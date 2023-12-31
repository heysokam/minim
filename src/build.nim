#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/os except `/`
import std/[ strformat,strutils ]
# confy dependencies
import confy

let nimDir          = cfg.binDir/".nim"
let libdir          = cfg.srcDir/"lib"
let nstdPath        = libDir/"nstd"/"src"
let slatePath       = libDir/"slate"/"src"
cfg.zigcc.systemBin = off
cfg.nim.cc          = string( nimDir/"bin"/"nim" )

var mincGen = Program.new(cfg.srcDir/"minc"/"gen"/"proto.nim", "mincGen")
os.removeFile( string cfg.binDir/mincGen.trg )
mincGen.build( @[mincGen.trg.string], run=true, force=true )

var minc = Program.new(cfg.srcDir/"minc.nim", "minc", args="$1 $2 $3" % [
  "--noNimblePath", &"--path:{nstdPath}", &"--path:{slatePath}" ])
os.removeFile( string cfg.binDir/minc.trg )
minc.build( @["all", minc.trg.string], run=false, force=false )
