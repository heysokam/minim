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
