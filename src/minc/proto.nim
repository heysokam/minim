#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/paths
# *Slate dependencies
import slate/gen/proto

# Write the generator prototype code
import ../minc
const mincFile = Path"minc.nim"
mincFile.writeGenProto(minc)




##[ PROTO EARLY TESTS ]#_______________________________
# Describe the language
const cmin * = Lang(
  name : "MinC",
  pfx  : "minc",
  )

import ./nimc
const code = "proc main*(count:int; argc:int32):int= return 42"
echo "\nrepr______________________________________________________"
echo nimc.getAST(code).repr
echo "\nrenderTree________________________________________________"
echo nimc.getAST(code).renderTree
echo "\ntreeRepr__________________________________________________"
echo nimc.getAST(code).treeRepr
echo "\ntoMinC____________________________________________________"
var res = convert.toMinC(code)
echo res

]##
