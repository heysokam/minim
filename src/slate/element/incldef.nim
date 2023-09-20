#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/strformat
import std/strutils
# nimc dependencies
import ../nimc
# Element dependencies
# import ./base

type Elem *{.pure.}= enum Module
converter toInt *(d :Elem) :int= d.ord

func getModule *(code :PNode) :string=
  assert code.kind == nkIncludeStmt
  let module = code[Elem.Module]
  assert module.kind == nkStrLit
  let name = module.strValue
  if "<" in name and ">" in name : result = name
  else                           : result = &"\"{name}\""
