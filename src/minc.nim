#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps ndk
import nstd/paths
import nstd/strings
import nstd/shell
# @deps MinC
import ./minc/logger
import ./minc/prep
import ./minc/cli as opts
from   ./minc/cfg import nil
from   ./minc/convert import nil
from   ./minc/format import nil

when isMainModule:
  # Get the arguments
  let cli = opts.init()
  # Init the logger
  logger.init()
  # Run the compiler
  if cli.cmd in {Compile, Codegen}:
    block SectionBin:
      #_____________________________
      # File Configuration
      let relFile   = cli.output.changeFileExt("c").lastPathPart
      let cacheFile = cli.cacheDir/relFile
      let rawFile   = cacheFile.changeFileExt(".raw.c")
      let refFile   = cacheFile.changeFileExt(".ref.cm")
      let binFile   = cli.binDir/cli.output
      #_____________________________
      # Preprocess
      let root = cli.input.splitFile.dir
      let code = cli.input.readFile()
        .processIncludes(root, cli.input)  # Preprocess includes
      #_____________________________
      # Codegen
      md cli.cacheDir                                   # Create the .cache dir if it doesn't exist
      refFile.writeFile code                            # Write the preprocessor generated code into a reference file
      rawFile.writeFile convert.toMinC_singleFile(code) # Codegen the C code
      cacheFile.writeFile format.clang(
        cli  = cli,
        code = rawFile.readFile, # TODO: Support for Multi-file
        ) # << format.clang( ... )
      # Copy the C code into the user-defined --codeDir folder
      if cli.codeDir != Path"": cp cacheFile, cli.codeDir/relFile
      #_____________________________
      # Compile the C code into binaries
      if cli.cmd != Compile: break SectionBin # Exit the block when not compiling in to binaries
      let flags = if cli.mode in {Release}: cfg.flags.release else: cfg.flags.debug
      var paths :string
      for path in cli.paths: paths.add &"-I{path.string} "
      var linkFl :string
      for pass in cli.passL: linkFl.add pass&" "
      let target =
        if   cli.os == "" and cli.cpu == "" : ""
        elif cli.os == "linux"              : &"-target {cli.cpu}-{cli.os}-gnu"
        else                                : &"-target {cli.cpu}-{cli.os}"
      let verb   = if cli.verbose: "-v" else: ""
      let cc     = &"{cli.zigBin.string} cc {verb} {target} {flags} {linkFl} {paths} {cacheFile.string} {cli.cfiles} -o {binFile.string}"
      dbg "Compiling into binary with command:  ",cc
      sh cc
      #_____________________________
      # Run the final binary when requested
      if cli.run:
        dbg "Running the resulting binary:  ",binFile.string
        sh binFile.string

