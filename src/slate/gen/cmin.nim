#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/paths
# *Slate dependencies
import ./proto

# Write the generator prototype code
import ../cmin
const cminFile = Path"cmin.nim"
cminFile.writeGenProto(cmin)
