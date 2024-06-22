#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
## @fileoverview
## Defines the minc compiler preprocessor functionality
#_______________________________________________________|
# @deps std
import std/symlinks
# @deps ndk
import nstd/strings
import nstd/paths
import nstd/sets
# @deps minc
import ./types
import ./logger
import ./tools


func isInclude (line :string) :bool=  line.startsWith("include") and '\"' notin line and '<' notin line and '>' notin line
  ## @descr Checks if the line contains a file include that should be processed
  ## @note Lines that match start with `include` and contain a path without any " < > characters

#_____________________________
var includedFiles :HashSet[Path]
  ## @descr List of already processed include files
#_____________________________
proc getInclude (module :Module; root :Path) :tuple[code:string, root:Path, src:Path]=
  ## @descr Gets the contents of the file referenced by the include line
  let path     :Path= module.path
  let cm       :Path= absolutePath root/path.addFileExt("cm")
  let file     :Path= if symlinkExists(cm): expandSymlink(cm).absolutePath(cm.splitFile.dir) else: cm
  let included :bool= includedFiles.containsOrIncl(file)
  if included: dbg "Skipped recursive include for file:  ", file.string; return
  result.src  = file
  result.root = file.splitFile.dir
  try    : result.code = file.readFile
  except : fail "Tried to include a file, but failed reading it.\n  ", file.string
#_____________________________
proc processIncludes *(code :string; root, src :Path) :string=
  ## @descr Recursively add all of the includes that should be preprocessed
  if src != Path(""): dbg "Processing includes from file:  $1" % [src.string]
  for line in code.splitLines:
    let module = tools.getModule(line)
    if module.kind == Include and module.lang == MinC: # and module.local:
      var tmp = module.getInclude(root)
      result.add processIncludes(tmp.code, tmp.root, tmp.src)
    else: result.add line & "\n"

