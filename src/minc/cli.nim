#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps std
import std/sets
from std/sequtils import toSeq
# @deps ndk
import nstd/opts
import nstd/paths
import nstd/strings
# @deps minc
import ./types
from ./cfg import nil
# @section Forward/export functionality from std/*
export sets.contains
export sets.items
# @section Extra support for std types
func `$` *(list :HashSet[Path]) :string=  list.toSeq.join(" ")


#_______________________________________
# @section CLI related types
#_____________________________
type BuildMode * = enum Debug, Release
type Cmd * = enum Unknown, Compile, Codegen
type Cfg * = object
  cmd      *:Cmd
  input    *:Path
  output   *:Path
  quiet    *:bool
  verbose  *:bool
  run      *:bool
  clangFmt *:ClangFormat
  zigBin   *:Path
  cacheDir *:Path
  codedir  *:Path
  binDir   *:Path
  mode     *:BuildMode
  os       *:string
  cpu      *:string
  cfiles   *:HashSet[Path]
  paths    *:HashSet[Path]
  passC    *:HashSet[string]
  passL    *:HashSet[string]
const KnownCmds  :HashSet[string]=  ["c","cc"].toHashSet
const KnownShort :HashSet[string]=  ["v","q","h","r"].toHashSet
const KnownLong  :HashSet[string]=  [
  "help","version","verbose","quiet",
  "zigBin", "clangFmtBin",
  "binDir","cacheDir","codeDir",
  "cfile","path","passL","passC",
  "os","cpu",
  ].toHashSet


#_______________________________________
# @section CLI Help
#_____________________________
const Help = """
{cfg.Prefix}  Usage
  minc [cmd] -(opt) [input] [output]

 Usage  Options (single letter)
  -h   : Print this notice and quit
  -v   : Activate verbose mode
  -r   : Run the final binary after compilation finishes

 Usage  Options (word)
  --help              : Print this notice and quit
  --version           : Print the version and quit
  --verbose           : Activate verbose mode
  --quiet             : Activate quiet mode (ignored when verbose). Silences debug messages from the logger, even when the compiler is built in debug mode.

  --binDir:path       : Changes the default bin path where other paths will be searched for when relevant (default:  {cfg.binDir})
  --binDir:path       : Define the path where the compiled content will be output  (default:  {cfg.binDir})
  --cacheDir:path     : Defined the path where the temporary/intermediate files will be output  (default:  {cfg.mincCache})
  --codeDir:path      : Define the folder where the C code will be output  (default:  {getCurrentDir()})

  --zigBin:path       : Changes the default path of the ZigCC binary  (default:  {cfg.zigBin})
  --clangFmtBin:path  : Changes the default path of the clang-format binary  (default:  {cfg.clangFmtBin})
  --clangFmtFile:path : Sets the path of the clang-format options file. Will not be passed to clang-format when omitted.

  --cfile:path        : Extra C source code file that should be added to the compilation command for building the final binary.
  --path:path         : Defines a path that will be `-Ipath` included in the compilation command for building the final binary.
  --passC:"arg"       : Defines an extra argument that will be passed to the compiler command when building the final binary.
  --passL:"arg"       : Defines an extra argument that will be passed to the linking command when building the final binary.
  --os:value          : Defines the target OS that the final binary will be built for.
  --cpu:value         : Defines the target CPU architecture that the final binary will be built for.

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


#_______________________________________
# @section CLI Error check
#_____________________________
proc err (msg :string) :void=
  echo &"{cfg.Prefix}  Error  {msg}"
  stopAndHelp()
#_____________________________
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


#_______________________________________
# @section CLI Management Tools
#_____________________________
proc getCmd (cli :opts.CLI) :Cmd=
  case cli.args[0]
  of "c"  : Cmd.Compile
  of "cc" : Cmd.Codegen
  else    : Cmd.Unknown


#_______________________________________
# @section External API
#_____________________________
proc init *() :Cfg=
  let cli = opts.getCli()
  cli.check()
  # Arguments
  result.cmd      = cli.getCmd()
  result.input    = cli.args[1].Path
  result.output   = cli.args[2].Path
  # Single Flags
  let cliQuiet =
    if not ("q" in cli.opts.short or "quiet" in cli.opts.long): cfg.Quiet
    else : ("q" in cli.opts.short or "quiet" in cli.opts.long)
  result.verbose  = "v" in cli.opts.short or "verbose" in cli.opts.long
  result.quiet    = cliQuiet and not result.verbose
  cfg.quiet       = result.quiet  # TODO: CLI should be separate files. TEMP Fix: Store --quiet in cfg.quiet so that the logger can use it
  result.run      = "r" in cli.opts.short
  # Folders
  result.cacheDir = if "cacheDir" in cli.opts.long : cli.getLong("cacheDir").Path else: cfg.mincCache
  result.binDir   = if "binDir"   in cli.opts.long : cli.getLong("binDir").Path   else: cfg.binDir
  result.codeDir  = if "codeDir"  in cli.opts.long : cli.getLong("codeDir").Path  else: getCurrentDir()
  # Binaries
  result.zigBin   = if "zigBin"   in cli.opts.long : cli.getLong("zigBin").Path else: cfg.zigBin
  result.clangFmt = ClangFormat(
    bin  : if "clangFmtBin"  in cli.opts.long : cli.getLong("clangFmtBin").Path  else: cfg.clangFmtBin.Path,
    file : cli.getLong("clangFmtFile").Path,
    ) # << ClangFormat( ... )
  # Compile Options
  result.mode     = if "release" in cli.opts.long : Release else: Debug
  result.os       = cli.getLong("os")
  result.cpu      = cli.getLong("cpu")
  for path in cli.getLongIter("path")  : result.paths.incl path.Path
  for path in cli.getLongIter("cfile") : result.cfiles.incl path.Path
  for pass in cli.getLongIter("passC") : result.passC.incl pass
  for pass in cli.getLongIter("passL") : result.passL.incl pass

