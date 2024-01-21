#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps std
import std/strformat
import std/sets
from std/sequtils import toSeq
from std/strutils import join
# @deps ndk
import nstd/opts
import nstd/paths
# @deps minc
from ./cfg import nil
# @section Forward/export functionality from std/*
export sets.contains
export sets.items
# @section Extra support for std types
func `$` *(list :HashSet[Path]) :string=  list.toSeq.join(" ")

# @section CLI related types
type BuildMode * = enum Debug, Release
type Cmd * = enum Unknown, Compile, Codegen
type Cfg * = object
  cmd      *:Cmd
  input    *:Path
  output   *:Path
  verbose  *:bool
  run      *:bool
  zigBin   *:Path
  cacheDir *:Path
  codedir  *:Path
  outDir   *:Path
  mode     *:BuildMode
  os       *:string
  cpu      *:string
  cfiles   *:HashSet[Path]
  paths    *:HashSet[Path]
  passL    *:HashSet[string]
const KnownCmds  :HashSet[string]=  ["c","cc"].toHashSet
const KnownShort :HashSet[string]=  ["v","h","r"].toHashSet
const KnownLong  :HashSet[string]=  [
  "help","version","verbose",
  "zigBin",
  "outDir","cacheDir","codeDir",
  "cfile","path","passL",
  "os","cpu",
  ].toHashSet

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
  --cacheDir:path : Defined the path where the temporary/intermediate files will be output (default: mincCache)
  --codeDir:path  : Define the path where the C code will be output  (default: mincCache)

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
  for opt in cli.opts.long       :
    if opt notin KnownLong       : err "Found an unknown long option: "&opt
  for opt in cli.opts.short      :
    if opt notin KnownShort      : err "Found an unknown short option: "&opt
  if cli.args.len < 1            : err "MinC was called without arguments."
  if cli.args.len != 3           : err "MinC was called with an incorrect number of arguments: " & $cli.args.len
  if cli.args[0] notin KnownCmds : err "Found an unknown command: "&cli.args[0]
proc getCmd (cli :opts.CLI) :Cmd=
  case cli.args[0]
  of "c"  : Cmd.Compile
  of "cc" : Cmd.Codegen
  else    : Cmd.Unknown

proc init *() :Cfg=
  let cli = opts.getCli()
  cli.check()
  result.cmd      = cli.getCmd()
  result.input    = cli.args[1].Path
  result.output   = cli.args[2].Path
  result.verbose  = "v" in cli.opts.short or "verbose" in cli.opts.long
  result.run      = "r" in cli.opts.short
  result.cacheDir = cli.getLong("cacheDir").Path
  result.outDir   = cli.getLong("outDir").Path
  result.codeDir  = cli.getLong("codeDir").Path
  let zig         = cli.getLong("zigBin").Path
  result.zigBin   = if zig != Path"": zig else: cfg.zigBin
  result.mode     = if "release" in cli.opts.long: Release else: Debug
  result.os       = cli.getLong("os")
  result.cpu      = cli.getLong("cpu")
  for path in cli.getLongIter("path")  : result.paths.incl path.Path
  for path in cli.getLongIter("cfile") : result.cfiles.incl path.Path
  for pass in cli.getLongIter("passL") : result.passL.incl pass

# TODO: Options
# --os:
# --cpu:


