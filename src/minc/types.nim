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

#_______________________________________
type SpecialContext *{.pure.}= enum None, Array, Object, Variable
  ## @descr The same syntax can be interpreted differently depending on its SpecialContext usage

#_______________________________________
type ModuleKind *{.pure.}= enum Unknown, Include, Import, NotModule
type ModuleLang *{.pure.}= enum Unknown, C, MinC
type Module * = object
  ## @descr Describes a module file that will be included or imported
  kind   *:ModuleKind
  lang   *:ModuleLang
  path   *:Path
  local  *:bool= true
