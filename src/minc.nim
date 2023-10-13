#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/cmdline
import std/os
import std/paths
# *Slate dependencies
import slate/types
# MinC dependencies
import ./minc/convert
import ./minc/prep

when isMainModule:
  # Get the arguments
  let cli  = commandLineParams()
  let src  = cli[0]
  let trg  = cli[1]
  # Preprocess
  let root = src.splitFile.dir.Path
  let code = src.readFile()
    .processIncludes(root)  # Preprocess includes
  # Compile the code
  trg.writeFile(convert.toMinC(code))
