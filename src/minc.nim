#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @dependencies std
import std/cmdline
import std/os
import std/paths
# @dependencies submodules
import nstd/opts
# @dependencies MinC
import ./minc/logger
import ./minc/convert
import ./minc/prep

when isMainModule:
  # Init the logger
  logger.init()
  # Get the arguments
  let cli  = opts.getCli()
  let src  = cli.args[0]
  let trg  = cli.args[1]
  # Preprocess
  let root = src.splitFile.dir.Path
  let code = src.readFile()
    .processIncludes(root)  # Preprocess includes
  # Compile the code
  trg.writeFile(convert.toMinC(code))
