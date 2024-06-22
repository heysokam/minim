#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps *Slate
import slate/nimc as nim
import slate/elements
import slate/errors as slateErr
import slate/types as slate
# @deps minc
import ../types as minc
# @deps minc.convert
import ./renames


#_______________________________________
# @section MinC+Slate Node Access Ergonomics
#_____________________________
template `.:` *(code :PNode; prop :untyped) :string=
  ## @descr (for ergonomics) Returns the string value of the given {@arg prop} from the given {@code arg} node.
  let field = astToStr(prop)
  case code.kind
  of nkStmtList:
    var id = int.high
    try : id = field.parseInt
    except NodeAccessError: code.err "MinC: Tried to access a Statement List, but the keyword passed was not a number:  "&field
    strValue( statement.get(code, id) )
  of nkProcDef, nkFuncDef:
    var id       = int.high
    var property = field
    if "arg_" in field:
      property = field.split("_")[0]
      try : id = field.split("_")[1].parseInt
      except NodeAccessError: code.err "MinC: Tried to access an Argument ID for a nkProcDef, but the keyword passed has an incorrect format:  "&field
    let prop = procs.get(code, property, id)
    case prop.kind
    of nkPtrTy : strValue( prop[0] ) & "*"
    else       : strValue( prop )
  of nkConstDef, nkIdentDefs:
    let typ = vars.get(code, field)
    case typ.kind
    of nkCommand,nkPtrTy:
      var tmp :string
      for field in typ: tmp.add strValue( field ) & " "
      if typ.isPtr: tmp = tmp.strip & "*"
      tmp
    else: strValue( typ )
  of nkPragma:
    strValue( pragmas.get(code, field) )
  of nkCommand, nkCall:
    var id       = int.high
    var property = field
    if "arg_" in field:
      property = field.split("_")[0]
      try : id = field.split("_")[1].parseInt
      except NodeAccessError: code.err "MinC: Tried to access an Argument ID for a Call, but the keyword passed has an incorrect format:  "&field
    strValue( calls.get(code, property, id) ).renamed(code.kind)
  of nkTypeDef:
    strValue( types.get(code, field) )
  of nkPrefix:
    strValue( affixes.getPrefix(code, field) )
  of nkInfix:
    strValue( affixes.getInfix(code, field) )
  else: code.err "MinC: Tried to access a field for an unmapped Node kind: " & $code.kind & "." & field; ""

