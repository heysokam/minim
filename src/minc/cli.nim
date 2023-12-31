#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps std
import std/strformat
# @deps submodules
import nstd/opts
import nstd/paths
# @deps minc
from ./cfg import nil

type Cfg * = object
  input   *:Path
  output  *:Path
  verbose *:bool

const Help = """
{cfg.Prefix}  Usage
  minc -(opt) [input] [output]

 Usage  Options (single letter)
  -h   : Print this notice and quit
  -v   : Activate verbose mode

 Usage  Options (word)
  --version  : Print the version and quit

 Usage  Compilation
  [argument] | Description
  ___________|__________________________________________
  input      | Path of the root file that will be processed/compiled
             | - Can be a relative or absolute
             | - Must be a single and valid MinC file
             | - Its folder will be used as the root folder for path resolution of import/include calls
  ___________|____________________________________________
  output     | Path of the output file where the minc process will be sent
             | - Can be a relative or absolute
             | - Will be a single C file with .c extension  (#TODO: Multifile)
             |   Will contain all of the relevant code amalgamated into a single file
  ___________|____________________________________________
"""
proc stopAndHelp= quit fmt Help
proc stopAndVersion= quit fmt """
{cfg.Prefix}  Version  {cfg.Version}"""
proc check=
  if "h" in cli.opts.short      : stopAndHelp()
  if "version" in cli.opts.long : stopAndVersion()
  if cli.args.len != 2          : stopAndHelp()

proc init *() :Cfg=
  let cli = opts.getCli()
  check()
  result.verbose = "v" in cli.opts.short
  result.input   = cli.args[0].Path
  result.output  = cli.args[1].Path

when isMainModule:
  let cli = cli.init()
