#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps ndk
import nstd/paths
from nstd/sets import with, without

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
type Context *{.pure.}= enum
  ## @descr The same syntax can be interpreted differently depending on its Context usage
  None,
  Array, Object, Union, Body, Typename,
  Assign, Variable, Argument, Return, Condition, When, ForLoop,
  Typedef, ObjectField,
  Readonly, Immutable, Unsafe, Pure, Varargs,
type SpecialContext * = set[Context]
  ## @descr Set of flags that define the context for how to interpret the syntax
converter toSpecialContext *(flag :Context) :SpecialContext= {flag}
func without *(A :SpecialContext; B :Context) :SpecialContext= sets.without(sets.without(A,None), B)
func with    *(A :SpecialContext; B :Context) :SpecialContext= sets.with(A.without(None), B)

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

