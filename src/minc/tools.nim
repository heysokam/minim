#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps std
from std/sequtils import allIt, anyIt
# @deps ndk
import nstd/logger
import nstd/paths
import nstd/strings
import nstd/errors as nstdErr
# @deps minc
import ./types

#_______________________________________
# @section Tools Error Management
#_____________________________
proc fail (msg :string) :void= raise newException(IOError, msg)

#_______________________________________
# @section Module management tools
#_____________________________
proc getPath (code :string) :Path=
  # 1. Between Quotes
  if code.startsWith("\"") and code.endsWith("\""):
    return code[1..^2].getPath()
  # 2. Between <>
  elif code.startsWith("<"):
    if code.endsWith(">") : return code[1..^2].getPath()
    else                  : return code[1..^1].getPath()
  # 3. Starts with @
  elif code.startsWith("@"):
    return code[1..^1].getPath()
  # 4. Normal path
  else:
    return code.strip().Path
#_____________________________
const PublicQualifiers = ["@", "<"]
proc getModule *(code :string) :Module=
  ## @descr Turns a {@link renderTree} formatted `include` or `import` {@arg code} line, and turns it into a {@link Module} object
  ## @ref Previous Implementation ->  line[8..^1].strip().strip( leading=false, chars={'\n'} ).Path
  const debug = off
  # Find kind  (include, import)
  let words = code.split(" ")
  if   words[0] == "include": result.kind = Include
  elif words[0] == "import" : result.kind = Import
  else:
    when debug: trc &"Tried to get a module from a code string with an unknown format. Returning NotModule:\n{code}\n{words[0]}"
    return Module(kind:NotModule)
  # Find local case
  if words[1] in PublicQualifiers or words[1].anyIt( $it in PublicQualifiers ):
    result.local = false
  elif words[1].startsWith(".") or words[1].startsWith("\"."):
    result.local = true
  # Find path
  if words[1] in PublicQualifiers:
    result.path = words[2..^1].join(" ").getPath()
  elif words.len >= 2:
    result.path = words[1..^1].join(" ").getPath()
  else:
    when debug: trc &"Tried to get a module from a code string with an unknown format. Returning NotModule:\n{code}\n{words[0]}"
    return Module(kind:NotModule)
  # Find language
  let ext = result.path.splitFile.ext
  case ext
  of ".h"  : result.lang = C
  of ".cm" : result.lang = MinC
  of ""    : result.lang = MinC
  else: fail &"Tried to get the language of a path string with an unknown extension:\n  `{result.path}`"
  if ext == "" and result.lang == MinC:
    result.path = result.path.addFileExt(".cm")

