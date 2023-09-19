#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/os
import std/strformat
#_________________________________________________
# Project Config
const thisDir      = currentSourcePath().parentDir()
const binDir       = thisDir/"bin"
const testsDir     = thisDir/"tests"
const cacheDir     = binDir/"cmcache"
const cminTestsDir = testsDir/"cmin"
#_________________________________________________


#_________________________________________________
# Target to Build
#_____________________________
const trg   = "hello42"
const src   = "t001"/trg&".cm"
const flags = ""
const verb  = on
const run   = off


#_________________________________________________
# Compiler Manager
const ss           = binDir/"cmin"   # StoS compiler command
const cc           = "zig cc"        # C Compiler command
const CminFlags    = "-Weverything"  # C Compiler flags
const CminValidExt = [".cm", ".nim"] # Valid extensions for the Cmin language
#_______________________________________
type CminCompileError = object of CatchableError
proc buildCmin () :void=  exec "nim confy.nims cmin"
#_______________________________________
proc sh (cmd :string; verbose=false) :void=
  if verbose: echo cmd
  exec cmd
proc compile (src,trg,flags :string; verbose=false; cache=cacheDir) :void=
  if src.splitFile.ext notin CminValidExt: raise newException(CminCompileError, &"Tried to compile a Cmin source file that has an unknown extension.\n  {src}")
  if not cacheDir.dirExists(): mkDir cacheDir
  let ir = cacheDir/src.changeFileExt("c").lastPathPart
  sh &"{ss} {src} {ir}"
  sh &"{cc} {CminFlags} {flags} -o {trg} {ir}"
#_________________________________________________


#_________________________________________________
# Current Test buildsystem
let srcTest = cminTestsDir/src
let trgTest = binDir/trg
buildCmin()
compile srcTest, trgTest, flags, verb
when run: sh trgTest
#_________________________________________________
