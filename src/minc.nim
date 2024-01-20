#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps std
from std/os import execShellCmd
from std/strformat import `&`
include ./minc/paths
# @deps MinC
import ./minc/logger
import ./minc/convert
import ./minc/prep
import ./minc/cli as opts
from   ./minc/cfg import nil

when isMainModule:
  # Init the logger
  logger.init()
  # Get the arguments
  let cli = opts.init()
  if cli.cmd in {Compile, Codegen}:
    block:
      let relFile   = cli.output.addFileExt("c")
      let cacheFile = cli.cacheDir/relFile
      let binFile   = cli.outDir/cli.output
      # Preprocess
      let root = cli.input.splitFile.dir
      let code = cli.input.readFile()
        .processIncludes(root)  # Preprocess includes
      # Codegen the C code
      cacheFile.writeFile(convert.toMinC(code))
      # Copy the C code into the user-defined --codeDir folder
      if cli.codeDir != Path"": copyFile cacheFile, cli.codeDir/relFile
      # Compile the C code into binaries
      if cli.cmd != Compile: break  # Exit the block when not compiling in to binaries
      let flags = if cli.mode in {Release}: cfg.flags.release else: cfg.flags.debug
      var paths :string
      for path in cli.paths: paths.add &"-I{path.string} "
      let verb   = if cli.verbose: "-v" else: ""
      let cc     = &"{cli.zigBin.string} cc {verb} {flags} {paths} {cacheFile.string} {cli.cfiles} -o {binFile.string}"
      dbg "Compiling into binary with command:  ",cc
      discard os.execShellCmd cc
