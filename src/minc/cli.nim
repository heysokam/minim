#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps std
import std/strformat
# @deps ndk
import nstd/opts
import nstd/paths
# @deps minc
from ./cfg import nil

type Cmd * = enum Compile, Codegen
type Cfg * = object
  cmd     *:Cmd
  input   *:Path
  output  *:Path
  verbose *:bool
const KnownCmds  :HashSet[string]=  ["c","cc"]
const KnownShort :HashSet[string]=  ["v","h","r"]
const KnownLong  :HashSet[string]=  ["help","version","verbose","zigBin","codeDir","os","cpu"]

# TODO: Options
# --codeDir: (aka mincCache)
# --zigBin:
# c
# cc
# --os:
# --cpu:


const Help = """
{cfg.Prefix}  Usage
  minc [cmd] -(opt) [input] [output]

 Usage  Options (single letter)
  -h   : Print this notice and quit
  -v   : Activate verbose mode
  -r   : Run the final binary after compilation finishes

 Usage  Options (word)
  --version       : Print the version and quit
  --verbose       : Activate verbose mode
  --zigBin:path   : Changes the default path of the ZigCC binary
  --codeDir:path  : Defined the path where the C code will be output (default: mincCache)

 Usage  Compilation
          --=|=--
  [cmd]      | Description
  ___________|__________________________________________
  c          | Compile to Binary using ZigCC
  cc         | Compile to Code
  ___________|__________________________________________
          --=|=--
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
proc err (msg :string) :void=
  echo &"{cfg.Prefix}  Error  {msg}"
  stopAndHelp()
proc check (cli :opts.CLI) :void=
  if "version" in cli.opts.long  : stopAndVersion()
  if "h" in cli.opts.short       : stopAndHelp()
  for opt in cli.opts.long:
    if opt notin KnownLong       : err "Found an unknown long option: "&opt
  for opt in cli.opts.short:
    if opt notin KnownShort      : err "Found an unknown short option: "&opt
  if cli.args.len < 1            : err "MinC was called without arguments."
  if cli.args.len != 3           : err "MinC was called with an incorrect number of arguments: "&cli.args.len
  if cli.args[0] notin KnownCmds : err "Found an unknown command: "&cli.args[0]

proc init *() :Cfg=
  let cli = opts.getCli()
  cli.check()
  result.verbose = "v" in cli.opts.short or "verbose" in cli.opts.long
  result.input   = cli.args[0].Path
  result.output  = cli.args[1].Path

when isMainModule:
  let cli = cli.init()
