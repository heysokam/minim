#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps *Slate
import slate/nimc as nim
# @deps minc
import ../types


#_______________________________________
# @section Renaming Lists
#_____________________________
const Calls :RenameList= @[
  ("addr", "&")
  ] # << renames.Calls [ ... ]
#___________________
const ConditionPrefix :RenameList= @[
  ("not", "!"),
  ] # << renames.ConditionPrefix [ ... ]
#___________________
const ConditionAffix :RenameList= @[
  ("shl", "<<"),  ("shr", ">>"),
  ("and", "&&"),  ("or" , "||"),  ("xor", "^"),
  ("mod", "%" ),  ("div", "/" ),
  ] # << renames.ConditionAffix [ ... ]
const AssignmentAffix :RenameList= @[
  ("shl", "<<"),  ("shr", ">>"),
  ("and", "&" ),  ("or" , "|" ),  ("xor", "^" ),
  ("mod", "%" ),  ("div", "/" ),
  ] # << renames.AssignmentAffix [ ... ]


#_______________________________________
# @section Renaming External API
#_____________________________
func renamed *(
    name    : string;
    kind    : TNodeKind;
    special : SpecialContext = Context.None;
  ) :string=
  ## @descr Returns the {@arg name} renamed to a valid C symbol, based on the mapped lists of Renames
  let list =
    case kind
    of nkCommand, nkCall             : renames.Calls
    of nkPrefix                      : renames.ConditionPrefix
    of nkInfix                       :
      if   Condition in special      : renames.ConditionAffix
      elif Context.Return in special : renames.ConditionAffix
      elif Variable in special       : renames.AssignmentAffix
      elif Assign in special         : renames.AssignmentAffix
      else                           : @[]
    else                             : @[]
  for rename in list:
    if name == rename.og: return rename.to
  result = name

