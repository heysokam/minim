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
type SpecialContext *{.pure.}= enum None, Array, Object, Variable, Argument, Condition
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

#_______________________________________
type ReservedName * = tuple[og:string, to:string]
  ## @descr Describes a rename from a reserved keyword `og` to the target keyword `to`
  ## @eg (og: addr to: &)
type RenameList * = seq[ReservedName]

