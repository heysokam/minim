#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps std
import std/[ os,strutils,strformat ]
# @deps minc
import ../minc/cfg

#_______________________________________
# @section Configuration
#___________________
const rootDir = os.parentDir( currentSourcePath() )/".."/".."
const binDir  = rootDir/"bin"
const srcDir  = rootDir/"src"
const libDir  = srcDir/"lib"
const nimDir  = binDir/".nim"
const nimBin  = nimDir/"bin"/"nim"
const gitBin  = "git"
const verbose = on

#_______________________________________
# @section Logger
#___________________
proc info *(args :varargs[string, `$`]) :void {.inline.}=  echo cfg.Prefix & args.join(" ")
proc fail *(args :varargs[string, `$`]) :void {.inline.}=  quit cfg.Prefix & args.join(" ")
proc fail *(code :int; args :varargs[string, `$`]) :void {.inline.}=  info args.join(" "); quit code
proc dbg  *(args :varargs[string, `$`]) :void {.inline.}=
  if not verbose: return
  info args


proc sh (args :varargs[string, `$`]) :void=
  let cmd  = args.join(" ")
  let code = os.execShellCmd( cmd )
  if code != 0: fail code, "Failed to run command:\n  ", cmd
proc nim (args :varargs[string, `$`]) :void= sh nimBin, args.join(" ")
proc git (args :varargs[string, `$`]) :void= sh gitBin, args.join(" ")
proc submodule (name,url :string; branch :string= ""; shallow :bool= false; force :bool= false) :void=
  let dir = libDir/name
  if dir.dirExists:
    if force : dir.removeDir()   # Remove the folder if we are force-installing the submodule
    else     : return            # Exit early if folder exists but we are not force-reinstalling
  let bopt = if branch == "": branch else: "-b "&branch # Branch command option for git
  let sopt = if shallow: "" else: "--depth=1" # Shallow command option for git
  git "clone", bopt, sopt, url, libDir/name

when isMainModule:
  info """
  Optional: Add minc and nim binaries to your PATH variable
     if [[ -d "$HOME/.minc/bin" ]] ; then export PATH="$PATH:$HOME/.minc/bin" ; fi
     if [[ -d "$HOME/.minc/bin/.nim/bin" ]] ; then export PATH="$PATH:$HOME/.minc/bin/.nim/bin" ; fi
  """
  # @deps std
  submodule "nim", "https://github.com/nim-lang/Nim"
  # @deps treeform
  submodule "zippy", "https://github.com/treeform/zippy"
  submodule "jsony", "https://github.com/treeform/jsony"
  # @deps ndk
  submodule "nstd", "https://github.com/heysokam/nstd"
  submodule "confy", "https://github.com/heysokam/confy"
  submodule "slate", "https://github.com/heysokam/slate"
  # @section Initialization Process
  nim "c -r -d:release -d:ssl",
    "--path:$1 --path:$2 --path:$3 --path:$3" % [
      libDir/"confy"/"src",
      libDir/"zippy"/"src",
      libDir/"jsony"/"src",
      ],
    "--outDir:$1 $2" % [binDir, srcDir/"build"]

