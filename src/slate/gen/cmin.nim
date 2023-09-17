#:______________________________________________________
#  *slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/paths
# *slate dependencies
import ./proto

# Write the generator prototype code
import ../cmin
const cminFile = Path"cmin.nim"
cminFile.writeGenProto(cmin)
