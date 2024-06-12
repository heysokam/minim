#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps nstd
import nstd/strings
# @deps *Slate
import slate/nimc as nim
# @deps minc
import ../errors


#_______________________________________
# @section Multiword Types Management
#_____________________________
const ValidMultiwordKinds    = {nkCommand}
const ValidMultiwordPrefixes = @["unsigned", "signed", "long", "short"]
const ValidMultiwordTypes    = @["char", "int"] & ValidMultiwordPrefixes
#___________________
proc getTypename *(code :PNode) :string=
  ## @descr Returns the string for the multiword type defined by {@arg code}
  if code.kind notin ValidMultiwordKinds: code.trigger TypeError, "Tried to get the multiword type of an invalid node kind."
  result = code.renderTree
#___________________
proc checkTypename *(code :PNode; crash :bool= false) :bool {.discardable.}=
  ## @descr
  ##  Checks if {@arg code} defines a valid multiword type.
  ##  Will trigger an exception when there is an error and {@arg crash} is specified as true  (default: false)
  ##  Returns a bool value that can be discarded automatically without using it.
  let render = code.getTypename().split()
  # Error check: Every word in the type must be part of the Types list 
  for word in render:  # Check every word against the known types
    if word notin ValidMultiwordTypes and crash:
      code.trigger TypeError, &"Found a foreign type in a multiword typename:  {render}"
  # The type must contain at least one of the prefixes
  for typ in ValidMultiwordPrefixes:  # Check every prefix against the render
    if typ in render: return true
#___________________
proc isMultiwordType *(code :PNode) :bool=
  ## @descr Returns true if the {@arg code} describes a multiword type
  if code.kind notin ValidMultiwordKinds: return false
  result = code.checkTypename(crash=false)

