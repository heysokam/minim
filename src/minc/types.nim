#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps ndk
import nstd/paths

#_______________________________________
type CFilePair * = object
  h  *:string
  c  *:string
func add *(A :var CFilePair; B :CFilePair) :void {.inline.}= A.h.add B.h; A.c.add B.c

#_______________________________________
type ClangFormat * = object
  bin   *:Path
  file  *:Path

