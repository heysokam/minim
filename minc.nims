#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/os
import std/strformat
import std/strutils
#_________________________________________________
# Project Config
const thisDir      = currentSourcePath().parentDir()
const binDir       = thisDir/"bin"
const testsDir     = thisDir/"tests"
const examplesdir  = thisDir/"examples"
const cacheDir     = binDir/"cmcache"
#_________________________________________________


#_________________________________________________
# Target to Build
#_____________________________
const trg   = "breakcontinue"
const src   = "e012"/trg&".cm"
const flags = ""
const verb  = on
const run   = on


#_________________________________________________
# Compiler Manager
const ss           = binDir/"minc"   # StoS compiler command
const cc           = "zig cc"        # C Compiler command
const NoErr        = [
  "-Wno-declaration-after-statement", # Explicitly allow asignment on definition. Useless warning for >= C99
  ].join(" ") # Flags to remove from -Weverything
const MinCFlags    = &"--std=c2x -Weverything -Werror -pedantic -pedantic-errors {NoErr}"  # C Compiler flags
const MinCValidExt = [".cm", ".nim"] # Valid extensions for the MinC language
#_______________________________________
type MinCCompileError = object of CatchableError
proc buildMinC () :void=  exec "nim confy.nims minc"
#_______________________________________
proc sh (cmd :string; verbose=false) :void=
  if verbose: echo cmd
  exec cmd
proc compile (src,trg,flags :string; verbose=false; cache=cacheDir) :void=
  if src.splitFile.ext notin MinCValidExt: raise newException(MinCCompileError, &"Tried to compile a MinC source file that has an unknown extension.\n  {src}")
  if not cacheDir.dirExists(): mkDir cacheDir
  let ir = cacheDir/src.changeFileExt("c").lastPathPart
  sh &"{ss} {src} {ir}"
  sh &"{cc} {MinCFlags} {flags} -o {trg} {ir}"
#_________________________________________________


#_________________________________________________
# Current Test buildsystem
let srcTest = examplesdir/src
let trgTest = binDir/trg
buildMinC()
compile srcTest, trgTest, flags, verb
when run: sh trgTest
#_________________________________________________
