#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @note
#  This file should be divided into separate modules.
#  But the `MinC` function is recursive and called from many of them
#  which creates a cyclic dependency :_(
#____________________________________________________________________|
# @deps std
# import std/strutils
# import std/tables
# @deps *Slate
# import slate/element/base as slateBase
# import slate/element/procdef
# import slate/element/error
# import slate/element/vars
# import slate/element/incldef
# import slate/element/calls
# import slate/element/loops
# import slate/element/types
# import slate/element/affixes
# @deps minc
# import ../cfg
# include ./fwdecl

# #______________________________________________________
# # @section Codegen: Errors
# #_____________________________
# type AffixCodegenError     = object of CatchableError
# type CallsCodegenError     = object of CatchableError
# type VariableCodegenError  = object of CatchableError
# type PragmaCodegenError    = object of CatchableError
# type ConditionCodegenError = object of CatchableError
# type ObjectCodegenError    = object of CatchableError
# type AssignCodegenError    = object of CatchableError

#______________________________________________________
# @section Codegen: Types
#_____________________________
# type  VarKind {.pure.}= enum Const, Let, Var
# type  Renames         = Table[string, string]
# const SomeLit         = {nkCharLit..nkTripleStrLit}
# const SomeStrLit      = {nkStrLit..nkTripleStrLit}
# const SomeCall        = {nkCall,nkCommand}
# const SomeValueNode   = {nkIdent, nkPtrTy, nkInfix}+SomeLit+{nkNilLit}
# Special cases
# const Reserved            = ["pointer"]
# const NoSpacingInfixes    = ["->"]
# const ValidEmpty          = ["_", "{0}"]
# const ValidRawStrPrefixes = ["raw"]
# const ValidInfixKind      = {nkIdent,nkInfix,nkPar,nkCast,nkBracketExpr,nkBracket,nkDotExpr,nkPtrTy} + SomeCall + SomeLit + {nkNilLit}
# const ValidCastOperators  = ["as", "@"]
# const ValidUnionOperators = [".:"]
# const ValueAffixRenames   = {
#   "shl": "<<",  "shr": ">>",
#   "and": "&" ,  "or" : "|" ,  "xor": "^" ,
#   "mod": "%" ,  "div": "/" ,
#   }.toTable
# const ConditionAffixRenames = {
#   "shl": "<<",  "shr": ">>",
#   "and": "&&",  "or" : "||",  "xor": "^" ,
#   "mod": "%" ,  "div": "/" ,
#   }.toTable()
# const KnownMainNames         = ["main", "WinMain"]
const KnownKeywords          = ["addr", "sizeof"]
# const KnownPragmas           = ["define", "error", "warning", "namespace", "emit"]
const KnownForInfix          = ["..", "..<"]
const KnownMultiwordPrefixes = ["unsigned", "signed", "long", "short"]

#______________________________________________________
# @section General tools
#_____________________________
# proc isCustomTripleStrLitRaw (code :PNode) :bool= (code.kind in {nkCallStrLit} and code[0].strValue in ValidRawStrPrefixes and code[1].kind == nkTripleStrLit)
# proc isTripleStrLit (code :PNode) :bool=  code.kind == nkTripleStrLit or code.isCustomTripleStrLitRaw
# proc mincGetTripleStrLit (code :PNode; indent :int= 0) :string=
#   let tab  = indent*Tab
#   let val  = if code.kind == nkTripleStrLit: code else: code[1]
#   var body = val.strValue
#   if code.isCustomTripleStrLitRaw : body = body.replace( "\n" , &"\"\n{tab}\""  ) # turn every \n character into  \n"\nTAB"  to use C's "" concatenation
#   else                            : body = body.replace( "\n" , &"\\n\"\n{tab}\"" ) # turn every \n character into \\n"\nTAB"  to use C's "" concatenation
#   result = &"\n{tab}\"{body}\""
#_____________________________
# proc isEmpty (code :PNode) :bool= code.kind == nkEmpty or (code.kind == nkIdent and code.strValue == "_")
# proc mincGetValueStr (code :PNode; indent :int= 0) :string=
#   assert code.kind in SomeValueNode+{nkEmpty,nkDotExpr,nkPar},
#     &"Tried to get the str value of a node that is not mapped for it. Its tree+code are:\n{code.treeRepr}\n{code.renderTree}\n"
#   let isPtr = code.kind == nkPtrTy
#   var name  =
#     case code.kind
#     of nkEmpty   : ""
#     of nkIdent   :
#       if code.strValue == "_": "{0}" else: code.strValue
#     of nkPtrTy   : code[0].strValue
#     of nkNilLit  : "NULL"
#     of nkCharLit : &"'{vars.getValue(code).parseInt().char}'"
#     of nkStrLit  : &"\"{code.strValue}\""
#     of nkRStrLit : &"\"{code.strValue}\""
#     of nkInfix   : mincGetValueRaw(code,indent)
#     of nkDotExpr : mincGetValueRaw(code,indent)
#     of nkPar     : &"({mincGetValueRaw(code[0])})"
#     else         : code.strValue
#   if code.isTripleStrLit: name = mincGetTripleStrLit(code,indent+1)
#   if name in Reserved : # Reserved identifier names that are always renamed
#     case name
#     of "pointer" : result = "void*"
#     else         : assert false, "Found a Reserved identifier name, but no behavior for it is defined. Its tree+code are:\n{code.treeRepr}\n{code.renderTree}\n"
#   elif isPtr : result = &"{name}*"
#   else       : result = name
#_____________________________
# proc mincGetObjectValue (code :PNode; indent :int= 0) :string=
#   # Special case: Redirection from other sections
#   if code.kind in {nkCall,nkCommand}:
#     if code[1].kind == nkIdent and code[1].strValue in ValidEmpty:
#      return &"({code[0].strValue}){{{0}}}"
#    elif code[1].kind == nkInfix and code[1][0].strValue in ValidUnionOperators:
#      # Union case
#      result.add &"({code[0].strValue}){{ .{code[1][1].strValue}= {{ "
#      let fields = code[1][2]
#      # .color= (VkClearColorValue) { .float32= {[0]= 1.0, [1]= 1.0, [2]= 1.0, [3]= 1.0} },
#      for id,field in fields.sons.pairs:
#        result.add &"[{id}]= {mincGetValueRaw(field)}" # Add the value of each field with designated initialization
#        if id < fields.sons.high: result.add ", "       # Add a separator for all fields except the last
#      result.add " } }"
#      return
#  # Get the body as normal
#  assert code.kind == nkObjConstr, code.renderTree
#  let tab1 = (indent+1)*Tab
#  result.add &"({code[0].strValue}){{\n"
#  for field in code.sons[1..^1]:
#    assert field.kind == nkExprColonExpr, field.renderTree
#    result.add &"{tab1}.{field[0].strValue}= {mincGetValueRaw(field[1], indent+1)},\n"
#  result.add &"{tab1}}}"
#_____________________________
# proc mincGetArrayValue (code :PNode; indent :int= 0) :string=
#   # Find the value list
#   let tab1   = (indent+1)*Tab
#   let values = vars.getValue(code,true).split(" ")
#   let value  = code[^1]
#   # Cases to exit early
#   if values.len  < 2 and values[0] in ["","_"] : return " {0}"
#   if values.len == 1 and value.kind == nkIdent : return &" {value.strValue}"
#   # Get the designated initialization arguments
#   result.add " {\n"
#   if value.kind == nkBracket:
#     for id,entry in value.pairs:
#       # report entry
#       result.add &"{tab1}[{id}]= {mincGetValueRaw(entry, indent+1)},\n"
#   else:
#     for id,it in values.pairs:
#       if it == "": break
#       result.add &"{tab1}[{id}]= {it},\n"
#   result.add &"{indent*Tab}}}"

#_____________________________
# proc mincDotExprList (code :PNode) :seq[string]=
#   for it in slateBase.dotExpr(code): result.add it.strValue
#_____________________________
# proc mincInfixList *(code :PNode; indent :int= 0; renames :Renames= Renames()) :string=
#   # TODO: Merge with mincInfix
#   if code.kind != nkInfix: report code
#   assert code.kind == nkInfix, &"Unknown kind {code.kind} in:\n{code.renderTree}"
#   let fix   = code[0]
#   let left  = code[1]
#   let right = code[2]
#   if not(fix.kind == nkIdent and left.kind in ValidInfixKind and right.kind in ValidInfixKind and (code.sons.len == 3 or (false))):
#     echo left.kind  in ValidInfixKind
#     echo right.kind in ValidInfixKind
#     echo code.sons.len == 3
#   assert fix.kind == nkIdent and left.kind in ValidInfixKind and right.kind in ValidInfixKind and code.sons.len == 3,
#     &"Failed to get the infix list of a node. Its tree+code are:\n{code.treeRepr}\n{code.renderTree}\n"

#   # Helpers to remove the cases mess/noise
#   proc isBase (node:PNode):bool= node.kind in {nkIdent}+SomeLit
#   proc getSideCode (node:PNode; indent :int= 0):string=
#     # Get the side code
#     if   node.isBase                 : result.add mincGetValueRaw(node, indent)          # Base Case
#     elif node.kind == nkPar          : # Parenthesis case
#       if   node[0].isBase            : result.add &"({node[0].strValue})"                # Base case inside parenthesis
#       elif node[0].kind == nkPar     : result.add &"({node[0].getSideCode})"
#       else                           : result.add &"({mincInfixList(node[0], indent, renames)})" # Recursive case between parenthesis
#     elif node.kind == nkCast         : # Normal cast
#       if   node[1].isBase            : result.add &"({node[0].strValue}){node[1].strValue}" # Base case inside cast
#      elif node[1].kind == nkDotExpr : result.add &"({node[0].strValue}){mincGetValueStr(node[1], indent)}" # Base case inside cast
#       else                           : result.add &"({node[0].strValue})({mincInfixList(node[1], indent, renames)})"  # Recursive case with cast
#     elif node.kind == nkInfix        : result.add mincInfixList(node, indent, renames)
#     elif node.kind == nkBracketExpr  : result.add mincGetValueRaw(node, indent)
#     elif node.kind == nkBracket      : result.add mincGetValueRaw(node, indent)
#    elif node.kind == nkDotExpr      : result.add mincGetValueRaw(node, indent)
#     elif node.kind in SomeCall       : result.add mincGetValueRaw(node, indent)
#     elif node.kind == nkPtrTy        : result.add mincGetValueRaw(node, indent)
#     elif node.kind == nkNilLit       : result.add mincGetValueRaw(node, indent)
#     else: raise newException(AffixCodegenError, &"Found an unmapped infix kind  {node.kind}  The code that contains it is:\n{code.renderTree}\n")
#
#   # Special Custom Cast case
#   if fix.strValue in ValidCastOperators:
#     assert right.kind in {nkIdent,nkPtrTy}, &"Casting targets are only allowed to be identifiers. The illegal tree+code is:\n{code.treeRepr}\n{code.renderTree}\n"
#     result.add &"({getSideCode(right)}){getSideCode(left)}"
#   # Special Union field case
#   elif fix.strValue in ValidUnionOperators:
#     result.add &".{getSideCode(left)}= {getSideCode(right)}"
#   # Normal infix case
#   else:
#     # Add the left value (including recursion)
#     result.add left.getSideCode()
#     # Add the affix
#     let fixn = fix.strValue
#     let sep  = if fixn in NoSpacingInfixes: "" else: " "
#     if fixn in renames : result.add &"{sep}{renames[fixn]}{sep}"
#     else               : result.add &"{sep}{fixn}{sep}"
#     # Add the right value (including recursion)
#     result.add right.getSideCode()

#_____________________________
# proc mincGetTernary (code :PNode; indent :int= 0) :string=
#   # TODO: Support for nkStmtList other than a single nkIdent
#   assert code.kind == nkIfExpr, "Getting ternary operator expresions is only allowed for nkIfExpr nodes. The illegal tree+code are:\n{code.treeRepr}\n{code.renderTree}\n"
#   assert code.sons.len == 2, "Getting nested ternary operator expresions (using if+elif+else) is not implemented. The erroring tree+code are:\n{code.treeRepr}\n{code.renderTree}\n"
#   result = &"({mincGetValueRaw(code[0][0], indent)}) ? {mincGetValueRaw(code[0][1][0], indent)} : {mincGetValueRaw(code[1][0][0], indent)}"
#_____________________________
# const ValidValue =
#   {nkEmpty, nkIdent, nkBracketExpr, nkBracket, nkDotExpr, nkIfExpr, nkPrefix, nkInfix, nkCast, nkPar, nkCall, nkCommand, nkCallStrLit, nkObjConstr, nkPtrTy} +
#   SomeLit + {nkNilLit}
# proc mincGetValueRaw (code :PNode; indent :int= 0) :string=
#   assert code.kind in ValidValue,
#     &"Tried to get the value of a node, but support for it is not implemented. Its tree+code are:\n{code.treeRepr}\n{code.renderTree}\n"
#   let strv =
#     if code.kind in nkStrLit..nkTripleStrLit: code.strValue.replace("\n", "\\n")
#     else:""
#   if code.kind == nkBracketExpr :
#     if code.sons.len == 1       : &"*{code[0].strValue}" # Dereference case
#     else                        : &"{mincGetValueRaw(code[0], indent)}[{mincGetValueRaw(code[1], indent)}]"
#   elif code.kind == nkBracket   : mincGetArrayValue(code, indent)
#   elif code.kind == nkDotExpr   : mincDotExprList(code).join(".")
#   elif code.kind == nkCharLit   : &"'{code.strValue.parseInt().char}'"
#   elif code.kind == nkPrefix    : &"{code[0].strValue}{mincGetValueRaw(code[1], indent)}"
#   elif code.kind == nkInfix     : mincInfixList(code, indent, ValueAffixRenames)
#   elif code.kind == nkCast      : &"({mincGetValueStr(code[0], indent)})({mincGetValueRaw(code[1], indent)})" # Recursive case for cast[]()
#   elif code.kind in SomeCall    : mincCallRaw(code, indent)
#   elif code.kind == nkPtrTy     : &"{code[0].strValue}*"
#   elif code.kind == nkObjConstr : mincGetObjectValue(code, indent)
#   elif code.kind == nkIfExpr    : mincGetTernary(code, indent)
#   elif code.kind == nkPar       : &"({mincGetValueRaw(code[0])})"
#   elif code.isTripleStrLit      : mincGetTripleStrLit(code,indent+1)
#   elif code.kind in SomeStrLit  : &"\"{strv}\""
#   else                          : mincGetValueStr(code, indent)


#______________________________________________________
# @section Affixes
#_____________________________
# proc mincPrefix (code :PNode; indent :int= 0; raw :bool= false) :string=
#   assert code.kind == nkPrefix, code.renderTree
#   let data = affixes.getPrefix(code)
#   if not raw: result.add indent*Tab
#   case data.fix
#   of "++","--":
#     discard # Known Prefixes. Do nothing, the line after this caseof will add their code
#   of "+", "-", "~":
#     assert raw, &"Found a prefix that cannot be used in a standalone line. The incorrect code is:\n{code.renderTree}"
#   of "&", "!", "*": raise newException(AffixCodegenError,
#     &"Found a C prefix that cannot be used in MinC. The incorrect code is:\n{code.renderTree}")
#   else: raise newException(AffixCodegenError, &"Found an unknown prefix  {data.fix}  The code that contains it is:\n{code.renderTree}\n")
#   result.add &"{data.fix}{data.right}"
#   if not raw: result.add ";\n"
#_____________________________
proc mincInfix (code :PNode; indent :int= 0; raw :bool= false) :string=
  # assert code.kind == nkInfix, code.renderTree
  # var data = affixes.getInfix(code)
  # if not raw: result.add indent*Tab
  case data.fix
  of "++","--":
    if data.right == "": raise newException(AffixCodegenError,
      &"Using ++ or -- as postfixes is currently not possible. The default Nim parser interprets them as infix, and breaks the code written afterwards. Please convert them to prefixes. The code that triggered this is:\n{code.renderTree}\n")
  # of "+=", "-=", "/=", "*=", "%=", "&=", "|=", "^=", "<<=", ">>=", "==", "<=", ">=", "!=", "->":
  #   # TODO: Check that `->` is in a complex assignment line. Doesn't break now, but will break something eventually.
  #   # Known Infixes. Do nothing, the line after this caseof will add their code
  #   discard
  of "+", "-", "*", "/", "%", "&", "|", "^", ">>", "<<",
     "and", "or", "xor", "shr", "shl", "div", "mod":
    # Known infixes that cannot be standalone
    if not raw: raise newException(AffixCodegenError, &"Found an infix that cannot be used in a standalone line. The incorrect code is:\n{code.renderTree}")
  # of "in", "notin", "is", "isnot", "of", "as", "from", "@":
  #   raise newException(AffixCodegenError, &"Found a nim infix keyword that cannot be used as an infix in MinC. The incorrect code is:\n{code.renderTree}")
  of "not" : raise newException(AffixCodegenError, &"Found a nim infix keyword that can only be used as prefix. The incorrect code is:\n{code.renderTree}")
  # else     : raise newException(AffixCodegenError, &"Found an unknown infix  {data.fix}  The code that contains it is:\n{code.renderTree}\n")
  # Remap nim keywords to C
  # case data.fix
  # of "and" : data.fix = "&&"
  # of "or"  : data.fix = "||"
  # of "xor" : data.fix = "^"
  # of "shl" : data.fix = "<<"
  # of "shr" : data.fix = ">>"
  # of "div" : data.fix = "/"  # TODO: Check that the types used are integers
  # of "mod" : data.fix = "%"
  # else:discard
  # Add the the code as left fix right
  # let sep = if data.fix in NoSpacingInfixes: "" else: " "
  # result.add &"{data.left}{sep}{data.fix}{sep}{data.right}"
  # if not raw: result.add ";\n"
#_____________________________
# proc mincPostfix (code :PNode; indent :int= 0; raw :bool= false) :string=
#   ## WARNING: Nim parser interprets no postfixes, other than `*` for visibility
#   ## https://nim-lang.org/docs/macros.html#callsslashexpressions-postfix-operator-call
#   assert code.kind == nkPostfix, code.renderTree
#   case affixes.getPostfix(code).fix
#   of "*": raise newException(AffixCodegenError,
#     &"Using * as a postfix is forbidden in MinC. The code that triggered this error is:\n{code.renderTree}")
#   else: raise newException(AffixCodegenError, "Unreachable case found in mincPostfix.\n{code.treeRepr}\n{code.renderTree}")


#______________________________________________________
# @section Procedures
#_____________________________
# proc mincProcDefGetArgs (code :PNode) :string=
#   ## Returns the code for all arguments of the given ProcDef node.
#   assert code.kind == nkProcDef, code.renderTree
#   let params = code[procdef.Elem.Args]
#   assert params.kind == nkFormalParams, params.renderTree
#   let argc = procdef.getArgCount(code)
#   if argc == 0: return "void"  # Explicit fill with void for no arguments
#   # Find all arguments
#   for arg in procdef.args(code): # For every individual argument -> args can be single or grouped arguments. this expands them
#     let tname =
#       if   arg.typ.name == "pointer" : "void*"
#       elif arg.typ.isArr             : arg.node[1][^1].strValue
#       else                           : arg.typ.name
#     let mut   = if not arg.typ.isMut : " const"     else: ""  # Add const by default, when arg is not marked as var
#     let typ   = if arg.typ.isPtr     : &"{tname}*"  else: tname
#     let sep   = if arg.last          : ""           else: ", "
#     let arr   = if arg.typ.isArr     : "[]"         else: ""
#     let ronly = if arg.node[0].kind == nkPragmaExpr and arg.node[0][1].kind == nkPragma and arg.node[0][1][0].strValue == "readonly": "const " else: ""
#     result.add( fmt "{ronly}{typ}{mut} {arg.name}{arr}{sep}" )
#_____________________________
# proc mincFuncDef  (code :PNode; indent :int= 0) :string=
#   assert false, "proc and func are identical in C"  # TODO : Sideffects checks
#   # __attribute__ ((pure))
#   # write-only memory idea from herose (like GPU write-only mem)
#_____________________________
# proc mincProcDefGetBody  (code :PNode; indent :int= 1) :string=
#   ## Returns the code for the body of the given ProcDef node.
#   # note: stored in core because it calls MinC
#   result.add "\n"
#   result.add MinC(code[procdef.Elem.Body], indent)
#_____________________________
#proc mincProcDef  (code :PNode; indent :int= 0) :string=
#  ## Converts a nkProcDef into the MinC Language
#  # note: stored in core because of MinC in getbody
#  assert code.kind == nkProcDef, code.renderTree
#  var pragma :string
#  if procdef.hasPragma(code):
#    let prag = procdef.getPragma(code)
#    if prag[0].kind == nkIdent:
#      pragma = case prag[0].strValue
#      of "noreturn_GNU": "__attribute__((noreturn)) "
#      of "noreturn_C11": "_Noreturn "
#      of "noreturn"    : "[[noreturn]] "
#      else:""
#  let isPriv = procdef.isPrivate(code, indent)
#  let priv   = if isPriv: "static " else: ""
#  let name   = procdef.getName(code)
#  var T      = procdef.getRetT(code)
#  let isPtr  = not code[3].isEmpty and code[3][0].kind == nkPtrTy
#  if   T == "pointer" : T = "void*"
#  elif isPtr          : T = T&"*"
#  let prototype = fmt"{priv}{T} {name} ({mincProcDefGetArgs(code)})"
#  if not isPriv and name notin KnownMainNames: result.add &"{prototype};\n" # TODO: Write decl to header
#  result.add &"{pragma}{prototype} {{{mincProcDefGetBody(code)}}}\n"


#______________________________________________________
# @section Function Calls
#_____________________________
# proc mincCallGetName (code :PNode) :string=
#   assert code.kind in {nkCall, nkCommand}, code.renderTree
#   result = code[0].strValue
#   case result
#   of "addr" : result = "&"
#_____________________________
# proc mincCallGetArgs (code :PNode; indent :int= 0) :string=
#   ## Returns the code for all arguments of the given ProcDef node.
#   assert code.kind in {nkCall, nkCommand}, code.renderTree
#   if calls.getArgCount(code) == 0: return
#   for arg in calls.args(code):
#     result.add mincGetValueRaw(arg.node, indent)
#     result.add( if arg.last: "" else: ", " )
#_____________________________
# proc mincCallRaw (code :PNode; indent :int= 0) :string=
#   assert code.kind in {nkCall, nkCommand}, code.renderTree
#   # Union special case
#   if code.sons.len == 2 and code[0].kind == nkIdent and code[1].kind == nkInfix and code[1][0].strValue in ValidUnionOperators:
#     return &"{mincGetObjectValue(code,indent)}"
#   # Other cases
#   let name = mincCallGetName(code)
#   let args = mincCallGetArgs(code,indent)
#   result   =
#     if   name == "&"        : &"{name}{args}"
#     elif args in ValidEmpty : &"{mincGetObjectValue(code,indent)}" # Reinterpret as an empty object constructor when "_"
#     else                    : &"{name}({args})"
# #_____________________________
# proc mincCall (code :PNode; indent :int= 0) :string=
#   assert code.kind in {nkCall, nkCommand}, code.renderTree
#   result.add &"{indent*Tab}{mincCallRaw(code,indent)};\n"
# #_____________________________
# proc mincCommand (code :PNode; indent :int= 0) :string=
#   assert code.kind in {nkCommand}, code.renderTree
#   mincCall(code,indent)  # Command and Call are identical in C


#______________________________________________________
# @section Variables
#_____________________________
#proc mincVariableGetValue (entry :PNode; value :PNode; typ :VariableType; indent :int= 0) :string=
#  ## Gets the value of a variable entry, based on its value node.
#  # note: Just a blocked alias to avoid mincVariable complexity/readability from becoming absurd.
#  let isObj = value.kind == nkObjConstr
#  result =
#    if   value.kind == nkIdent and value.strValue == "_": " {0}"
#    elif value.kind == nkEmpty             : ""
#    elif value.kind == nkNilLit            : " NULL"
#    elif value.kind in {nkCall,nkCommand}  : &" {mincCallRaw(value,indent)}"
#    elif value.kind in nkStrLit..nkRStrLit : &" \"{vars.getValue(entry)}\""
#    elif value.isTripleStrLit              : mincGetTripleStrLit(value,indent+1)
#    elif value.kind == nkCharLit           : &" '{vars.getValue(entry).parseInt().char}'"
#    elif value.kind in {nkBracketExpr,nkInfix,nkCast,nkDotExpr,nkIfExpr}:
#      &" {mincGetValueRaw(value,indent)}"
#    elif not (typ.isArr or isObj)          : &" {vars.getValue(entry)}"
#    else                                   : ""
#  if typ.isArr and value.kind != nkNilLit and value.kind != nkEmpty and value.kind notin SomeStrLit and not value.isTripleStrLit:
#    result.add mincGetArrayValue(entry, indent)
#  elif isObj:
#    result.add mincGetObjectValue(value, indent)
#  # if result == "": report entry; report value; assert false
#_____________________________
# proc mincVariable (entry :PNode; indent :int; kind :VarKind) :string=
#   assert entry.kind in [nkConstDef, nkIdentDefs], entry.treeRepr
#   let priv  =
#     if vars.isPrivate(entry,indent) or
#        vars.isPersist(entry,indent) : "static "
#     else                            : ""
#   let mut   = case kind
#     of VarKind.Const : "" # constants become constexpr, they don't need type mutability
#     of VarKind.Let   : "const "
#     of VarKind.Var   : ""
#   if entry[^2].kind == nkEmpty: raise newException(VariableCodegenError,
#     &"Declaring a variable without a type is forbidden. The illegal code is:\n{entry.renderTree}\n")
#   let typ = vars.getType(entry)
#   var T   = if typ.name == "pointer": "void*" else: typ.name
#   if typ.isArr and typ.arrSize == "_": raise newException(VariableCodegenError,  # TODO: When -Wunsafe-buffer-usage becomes stable
#     &"MinC uses the Safe Buffers programming model exclusively. Declaring arrays of an unknown size is disabled. The illegal code is:\n{entry.renderTree}\n")
#   var arr :string=
#     if   typ.isArr and typ.arrSize == "_": "[]"
#     elif typ.isArr and typ.arrSize != "_": &"[{typ.arrSize}]"
#     else:""
#   assert not (typ.isArr and arr == ""), "Found an array type, but its code has not been correctly generated.\n{entry.treeRepr}\n{entry.renderTree}\n"
#   if typ.isPtr: T &= "*"  # T = Type Name
#   let name  = vars.getName(entry)
#   # Value asignment
#   let value = entry[^1] # Value Node
#   if value.kind == nkEmpty and kind == VarKind.Const: raise newException(VariableCodegenError, # TODO : unbounded support
#     &"Declaring a variable without a value is forbidden for `const`. The illegal code is:\n{entry.renderTree}")
#   let val   = mincVariableGetValue(entry, value, typ, indent)
#   let asign = if val == "": "" else: &" ={val}"
#   Apply to the result
#   let qualif = case kind
#     of VarKind.Const : &"const/*comptime*/ {priv}"  # TODO:clang.18->   &"constexpr {priv}"
#     of VarKind.Let   : &"{priv}"
#     of VarKind.Var   : &"{priv}"
#   if not vars.isPrivate(entry,indent) and indent == 0:
#     result.add &"{indent*Tab}extern {qualif}{T} {mut}{name}{arr}; " # TODO: Write Extern decl to header
#   result.add &"{indent*Tab}{qualif}{T} {mut}{name}{arr}{asign};\n"
#_____________________________
# proc mincConstSection (code :PNode; indent :int= 0) :string=
#   assert code.kind == nkConstSection, code.renderTree # Let and Const are identical in C
#   for entry in code.sons: result.add mincVariable(entry,indent, VarKind.Const)
# #_____________________________
# proc mincLetSection (code :PNode; indent :int= 0) :string=
#   assert code.kind == nkLetSection, code.renderTree # Let and Const are identical in C
#   for entry in code.sons: result.add mincVariable(entry,indent, VarKind.Let)
# #_____________________________
# proc mincVarSection (code :PNode; indent :int= 0) :string=
#   assert code.kind == nkVarSection, code.renderTree
#   for entry in code.sons: result.add mincVariable(entry,indent, VarKind.Var)


#______________________________________________________
# @section Modules
#_____________________________
# proc mincIncludeStmt (code :PNode; indent :int= 0) :string=
#   assert code.kind == nkIncludeStmt, code.renderTree
#   if indent > 0: raise newException(IncludeError, &"Include statements are only allowed at the top level.\nThe incorrect code is:\n{code.renderTree}\n")
#   result.add &"#include {incldef.getModule(code)}\n"


#______________________________________________________
# @section Pragmas
#_____________________________
# proc mincPragmaDefine (code :PNode; indent :int= 0) :string=
#   assert code.kind == nkPragma, code.renderTree
#   assert code[0].len == 2, &"Only {{.define:symbol.}} pragmas are currently supported.\nThe incorrect code is:\n{code.renderTree}\n"
#   let val =
#     if code[0][1].kind == nkInfix and code[0][1][0].strValue == "->":
#       &"{code[0][1][1].strValue} {mincGetValueStr(code[0][1][^1])}"
#     elif code.sons.len > 1 and code[1].kind == nkPrefix and code[1][0].strValue == "->":
#       &"{code[0][1].strValue} {mincGetValueStr(code[1][1])}"
#     else: code[0][1].strValue
#   result.add &"{indent*Tab}#define {val}\n"
# #_____________________________
# proc mincPragmaError (code :PNode; indent :int= 0) :string=
#   assert code.kind == nkPragma, code.renderTree
#   let data = code[0] # The data is inside an nkExprColonExpr node
#   assert data.kind == nkExprColonExpr and data.len == 2 and data[1].kind == nkStrLit, &"Only {{.error:\"msg\".}} error pragmas are currently supported.\nThe incorrect code is:\n{code.renderTree}\n"
#   result.add &"{indent*Tab}#error {data[1].strValue}\n"
#_____________________________
# proc mincPragmaWarning (code :PNode; indent :int= 0) :string=
#   assert code.kind == nkPragma, code.renderTree
#   let data = code[0] # The data is inside an nkExprColonExpr node
#   assert data.kind == nkExprColonExpr and data.len == 2 and data[1].kind == nkStrLit, &"Only {{.warning:\"msg\".}} warning pragmas are currently supported.\nThe incorrect code is:\n{code.renderTree}\n"
#   result.add &"{indent*Tab}#warning {data[1].strValue}\n"
# #_____________________________
# proc mincPragmaNamespace (code :PNode; indent :int= 0) :string=
#   assert code.kind == nkPragma, code.renderTree
#   let data = code[0] # The data is inside an nkExprColonExpr node
#   let name = data[1] # Name node of the namespace
#   assert data.kind == nkExprColonExpr and data.len == 2 and name.kind in [nkIdent,nkDotExpr], &"Only {{.namespace:name.}} and {{.namespace:name.sub.}} namespace pragmas are currently supported.\nThe incorrect code is:\n{code.renderTree}\n"
#   let val  =
#     if   name.kind == nkIdent   : name.strValue
#     elif name.kind == nkDotExpr : mincDotExprList(name).join(".") # TODO: this is fine, but symbols should be using _
#     else:""
#   assert val != "", &"Failed to find the namespace name value for:\n{code.treeRepr}\n"
#   result.add &"{indent*Tab}// namespace {val}\n"
# # #_____________________________
# proc mincPragmaEmit (code :PNode; indent :int= 0) :string=
#   assert code.kind == nkPragma and code[0].kind == nkExprColonExpr and code[0][0].strValue == "emit" and code[0][1].kind in SomeStrLit,
#     &"Tried to get the code from an emit pragma, but the node does not match the required shape.\nThe incorrect tree+code is:\n{code.treeRepr}\n{code.renderTree}\n"
#   let text = code[0][1].strValue
#   let emit = if text.endsWith("\n"): text[0..^2] else: text
#   result = &"{indent*Tab}{text}\n"
# #_____________________________
# proc mincPragma (code :PNode; indent :int= 0) :string=
#   ## Codegen for standalone pragmas
#   ## Context-specific pragmas are handled inside each section
#   assert code.kind == nkPragma, code.renderTree
#   assert code[0].kind == nkExprColonExpr and code[0].len == 2,
#     &"Only pragmas with the shape {{.key:val.}} are currently supported.\nThe incorrect code is:\n{code.renderTree}\n"
#   let key = code[0][0].strValue
#   case key
#   of "define"    : result = mincPragmaDefine(code,indent)
#   of "error"     : result = mincPragmaError(code,indent)
#   of "warning"   : result = mincPragmaWarning(code,indent)
#   of "namespace" : result = mincPragmaNamespace(code,indent)
#   of "emit"      : result = mincPragmaEmit(code,indent)
#   else: raise newException(PragmaCodegenError, &"Only {KnownPragmas} pragmas are currently supported.\nThe incorrect code is:\n{code.renderTree}\n")


#______________________________________________________
# @section Conditions
#_____________________________
# proc mincGetCondition (code :PNode; indent :int= 0) :string=
#   # TODO: Unconfuse this total mess. Remove hardcoded numbers. Should be names and a loop.
#   if code.kind == nkPrefix:
#     result.add code[0].strValue.replace("not","!")
#     if   code[1].kind == nkCall    : result.add mincCallRaw( code[1],indent )
#     elif code[1].kind == nkDotExpr : result.add mincGetValueRaw( code[1],indent )
#     else                           : result.add mincGetValueRaw( code[1],indent )
#   elif code.kind == nkInfix:
#     result.add mincInfixList(code, indent, ConditionAffixRenames)  # TODO: Restrict to comparison only
#   elif code.kind in {nkIdent,nkDotExpr,nkCall}: result.add mincGetValueRaw(code,indent)
#   else: assert false, &"Only Ident/DotExpr/Call/!Prefix/Infix conditions are currently supported.\n{code.treeRepr}\n{code.renderTree}\n"

#______________________________________________________
# @section Loops
#_____________________________
# proc mincWhileStmt (code :PNode; indent :int= 0) :string=
#   assert code.kind == nkWhileStmt, code.renderTree
#   result.add &"{indent*Tab}while ({mincGetCondition(code[0])}) {{\n"
#   result.add MinC( code[^1], indent+1 )
#   result.add &"{indent*Tab}}}\n"
#_____________________________
#proc mincForStmt (code :PNode; indent :int= 0) :string=
#  assert code.kind == nkForStmt, code.renderTree
#  # Name the code entries
#  let sentry  = code[0]   # Sentry variable
#  let exprs   = code[1]   # For Expression
#  let content = code[2]   # Contents of the for body block
#  # Name the expresion entries
#  let infix   = exprs[0]  # Infix operator that does the finalizing condition check
#  let value   = exprs[1]  # Initial Value assigned to the sentry
#  let final   = exprs[2]  # Final value checked to terminates the for
  # Error check
#  assert sentry.kind == nkIdent and
#         exprs.kind == nkInfix and
#         infix.strValue in KnownForInfix
#         and content.kind == nkStmtList,
#    &"Tried to generate the code of a for loop, but its definition syntax is not supported. Its tree+code are:\n{code.treeRepr}\n{code.renderTree}\n"
#  # Name the outputs
#  let init = if sentry.isEmpty: ""
#    else: &"size_t {sentry.strValue} = {mincGetValueStr(value)}"  # TODO: Remove hardcoded size_t. Should be coming from exprs[1].T
#  let fix  = if infix.strValue[2..^1] == "": "<=" else: infix.strValue[2..^1]
#  let cond = if exprs.isEmpty : ""
#    else: &" {mincGetValueStr(sentry)} {fix} {mincGetValueStr(final)}"
#  let iter = if exprs.isEmpty : ""
#    else: &" ++{sentry.strValue}" # TODO : Remove hardcoded ++. Allow decrementing the value
#  let body = &" {{\n{MinC(content,indent+1)}{indent*Tab}}}\n"
#  result.add &"{indent*Tab}for({init};{cond};{iter}){body}"


#______________________________________________________
# @section Control Flow
#_____________________________
# proc mincReturnStmt (code :PNode; indent :int= 1) :string=
#   assert code.kind == nkReturnStmt, code.renderTree
#   assert indent != 0, "Return statements cannot exist at the top level in C.\n" & code.treeRepr & "\n" & code.renderTree
#   let val =
#     if code[0].kind == nkInfix : mincInfixList(code[0],  indent+1, ConditionAffixRenames)
#     else                       : mincGetValueRaw(code[0],indent+1)
#   result.add &"{indent*Tab}return {val};\n"
#_____________________________
# proc mincContinueStmt (code :PNode; indent :int= 0) :string=
#   assert code.kind == nkContinueStmt, code.renderTree
#   assert indent != 0, "Continue statements cannot exist at the top level in C.\n" & code.renderTree
#   result.add &"{indent*Tab}continue;\n"
# #_____________________________
# proc mincBreakStmt (code :PNode; indent :int= 0) :string=
#   assert code.kind == nkBreakStmt, code.renderTree
#   assert indent != 0, "Break statements cannot exist at the top level in C.\n" & code.renderTree
#   result.add &"{indent*Tab}break;\n"
#_____________________________
# proc mincIfStmt (code :PNode; indent :int= 0) :string=
#   assert code.kind == nkIfStmt, code.renderTree
#   let tab :string= indent*Tab
#   for id,branch in code.pairs:
#     let body = &"{MinC(branch[^1], indent+1)}"
#     let pfx :string=
#       if   branch.kind == nkElifBranch and id == 0 : &"{tab}if "
#       elif branch.kind == nkElifBranch             : " else if "
#       elif branch.kind == nkElse                   : " else "
#       else:""
#     assert pfx != "", "Unknown branch kind in minc.IfStmt"
#     let condition :string=
#       if   branch.kind == nkElifBranch : &"({mincGetCondition(branch[0])}) "
#       elif branch.kind == nkElse       : ""
#       else:""
#     result.add &"{pfx}{condition}{{\n{body}{tab}}}"
#   result.add "\n" # Finish with Newline on the last branch
#_____________________________
# proc mincWhenStmt (code :PNode; indent :int= 0) :string=
#   assert code.kind == nkWhenStmt, code.renderTree
#   let tab :string= indent*Tab
#   for id,branch in code.pairs:
#     # Get the macro prefix
#     let pfx :string=
#       if   branch.kind == nkElifBranch and id == 0 : &"{tab}#if "
#       elif branch.kind == nkElifBranch             : &"{tab}#elif "
#       elif branch.kind == nkElse                   : &"{tab}#else"
#       else:""
#     assert pfx != "", "Unknown branch kind in minc.WhenStmt"
#    # Get the body code from the Stmt section
#    let body = &"{MinC(branch[^1], indent)}"
#    # Exit early for Else statements
#    if branch.kind == nkElse:
#      assert branch[0].kind == nkStmtList, &"Found an Else statement with an unknown shape. Its tree+code are:\n{branch.treeRepr}\n{branch.renderTree}\n"
#      result.add &"{pfx}\n{body}"
#      continue # Don't get the condition. Else statements don't have any
#    # Get the condition
#    assert branch[^2].kind == nkIdent or branch[^2].len <= 2, "Multi-condition when/elif/else statements are currently not supported"
#    let cond  = branch[0]
#    let isDef = cond.kind == nkCall and cond[0].strValue == "defined"
#    assert cond.kind in {nkPrefix, nkIdent} or isDef, &"Only Prefix/Single/defined conditions are currently supported\n{code.renderTree}"
#    var condition :string
#    if cond.kind == nkIdent: # single condition case. Add its content to condition
#      condition.add cond.strValue
#    elif cond[0].kind == nkIdent and cond[0].strValue == "not":
#      condition.add "!"
#    # TODO: This is broken for most. Only works for `when defined(thing)`
#    if cond.kind == nkIdent: discard # single condition case. Skip searching for subnodes
#    elif isDef:
#      condition.add &"defined({cond[1].strValue})"
#    elif cond[1].kind == nkCall and cond[1][0].strValue == "defined":
#      condition.add &"defined({cond[1][1].strValue})"
#    elif cond[1].kind == nkIdent:
#      condition.add cond[1].strValue
#    else: assert false, &"Unknown when condition in:\n{code.renderTree}"
#    # Add to the result
#    result.add &"{pfx}{condition}\n{body}"
#   result.add &"{tab}#endif\n"
#_____________________________
proc mincCaseStmt (code :PNode; indent :int= 0) :string=
  assert code.kind == nkCaseStmt, code.renderTree
  let tab  :string= indent*Tab
  let tab1 :string= (indent+1)*Tab
  let tab2 :string= (indent+2)*Tab
  result.add &"{tab}switch ({mincGetValueRaw(code[0])}) {{\n"
  for entry in code.sons[1..^1]: # For every of/else entry. [0] is the condition itself
    var shouldBreak :bool= true
    if entry.kind == nkOfBranch:
      result.add &"{tab1}case {mincGetValueRaw(entry[0])}:\n{tab2}{MinC(entry[1], indent+1)}"
      if entry[1][0].kind == nkReturnStmt: shouldBreak = false
    elif entry.kind == nkElse:
      result.add &"{tab1}default:\n{tab2}{MinC(entry[0], indent+1)}"
    if shouldBreak: result.add &"{tab2}break;"
    result.add "\n"
  result.add &"{tab}}}\n"


#______________________________________________________
# @section Types
#_____________________________
# proc mincGetObjectFieldDef *(code :PNode; indent :int= 1) :string=
#   assert code.kind == nkIdentDefs, code.renderTree
#   if code[^1].kind != nkEmpty: raise newException(ObjectCodegenError,
#     &"Default values for types are not allowed in MinC. The illegal code is:\n{code.renderTree}\n")
#   var name =
#     if   code[0].kind == nkIdent   : code[0].strValue
#     elif code[0].kind == nkPostfix : code[0][1].strValue
#     else                           : &"{types.getName(code)}"
#   let typ =
#     if   code[^2].kind == nkIdent       : TypeInfo(name:mincGetValueStr(code[^2]))
#     elif code[^2].kind == nkPtrTy       : TypeInfo(name:code[^2][0].strValue&"*")
#     elif code[^2].kind == nkBracketExpr : TypeInfo(name:code[^2][2].strValue, isArr:true)
#     else                                : types.getType(code, KnownMultiwordPrefixes)
#   if typ.isArr:
#     let size = if code[^2][1].isEmpty: "" else: mincGetValueStr(code[^2][1])
#     name.add &"[{size}]"
#   result.add &"{indent*Tab}{typ.name} {name};\n"

#_____________________________
proc isStub (code :PNode) :bool=
  ## Returns true if the given nkTypeDef node meets all of the conditions to be a stub object
  code.kind == nkTypeDef and code[^1].kind == nkObjectTy and
  code[0].kind == nkPragmaExpr and code[0][^1].kind == nkPragma and
  code[0][^1][0].kind == nkIdent and code[0][^1][0].strValue == "stub" and
  code[^1][1].kind == nkOfInherit and code[^1][1][0].kind == nkIdent and
  code[^1][^1].kind == nkEmpty
#_____________________________
proc mincGetStubName (code :PNode) :string= code[^1][1][0].strValue
  ## Get the `of T` as the name for stub definitions
proc mincGetStubBody (code :PNode) :string=
  ## Get the name of the object as the body for stub definitions
  if   code[0][0].kind == nkIdent   : result = code[0][0].strValue
  elif code[0][0].kind == nkPostfix : result = code[0][0][1].strValue
  else: raise newException(ObjectCodegenError, &"Tried to get the stub body of a node that is not recognized.\n{code.treeRepr}\n{code.renderTree}\n")
#_____________________________
proc mincGetObjectBody (code :PNode; indent :int= 0) :string=
#   assert code[^1].kind == nkObjectTy, code.renderTree
  if code.isStub: return mincGetStubBody(code)
#   # Get the body normally
#   assert code[^1][^1].kind == nkRecList, &"Unknown kind {code[^1][^1].kind} in:\n{code.renderTree}"
#   let tab1 = (indent+1)*Tab
#   if code[1].kind != nkEmpty: result.add &"({code[1].strValue})"
#   result.add "{\n"
#   for field in code[^1][^1]:  # For every field in the object's value (aka the object body)
#     result.add mincGetObjectFieldDef(field, indent+1)
#   result.add &"{tab1}}}"
#_____________________________
proc mincGetProcTypeDefArgs (code :PNode; indent :int= 0) :string=
  assert types.isProc(code), &"Tried to get the proc typedef args of a node that is not an nkProcTy:\n{code.treeRepr}\n{code.renderTree}\n"
  const ArgType = 1
  let args = types.procArgs(code)
  for id,arg in args.pairs:
    result.add mincGetValueRaw( arg[ArgType], indent )
    if id != args.high: result.add ","
#_____________________________
proc mincGetProcTypedef (code :PNode; indent :int= 0) :string=
  assert types.isProc(code), &"Tried to get the proc typedef of a node that is not an nkProcTy:\n{code.treeRepr}\n{code.renderTree}\n"
  let name = types.getName(code)
  let ret  = mincGetValueRaw( types.procRetT(code), indent )
  let args = mincGetProcTypeDefArgs(code, indent)
  result = &"{indent*Tab}typedef {ret} (*{name})({args});\n"
#_____________________________
proc mincTypeDef (code :PNode; indent :int= 0) :string=
  assert code.kind == nkTypeDef, code.renderTree
  let info = types.getType(code, KnownMultiwordPrefixes)
  # Proc special case
  if info.isProc: return mincGetProcTypeDef(code, indent)
  # Other cases
  let stub = code.isStub
  var name = if stub: mincGetStubName(code) #else: &"{types.getName(code)}"
  # let mut  = if stub: "" elif info.isRead: " const" else: ""
  # var typ  =
  #   if info.isObj    : &"struct {name}{mut}"
  #   else             : info.name & mut
  # if info.isPtr: typ.add "*"
  # var body :string= ""
  # var other :string= ""
  # if info.isObj: body.add mincGetObjectBody(code, indent)
  if stub: return &"{indent*Tab}typedef {typ} {body};\n"  # {.stub.} objects have a special case
  result = &"{indent*Tab}typedef {typ} {name};\n"         # Normal decl for non-obj and fw.decl for objects
  if info.isObj and not stub: result.add &"{indent*Tab}{typ} {body};\n"
#_____________________________
# proc mincTypeSection (code :PNode; indent :int= 0) :string=
#   assert code.kind == nkTypeSection, code.renderTree
#   for entry in code: result.add mincTypeDef(entry, indent)


#______________________________________________________
# @section Assignment
#_____________________________
# proc mincAsgn (code :PNode; indent :int= 0) :string=
#   assert code.kind == nkAsgn, code.renderTree
#   let sym   = code[0]
#   let value = code[^1]
#   let val   = mincGetValueRaw(value,indent)
#   assert val != "", &"Tried to create an asignment, but its value is invalid. Its tree+code are:\n{code.treeRepr}\n{code.renderTree}\n"
#   if val == "" and value.kind == nkBracketExpr: raise newException(AssignCodegenError,
#     &"Tried to create dereferencing code for a node, but it has no value asignment. Its tree+code are:\n{code.treeRepr}\n{code.renderTree}\n")
#   let isDeref     = sym.kind == nkBracketExpr and sym.sons.len == 1
#   let isArrAccess = not isDeref and sym.kind == nkBracketExpr
#   let isDotObj    = sym.kind == nkDotExpr
#   var name =
#     if   isArrAccess              : &"{mincGetValueRaw(sym[0])}[{mincGetValueRaw(sym[^1],indent)}]"
#     elif isDeref                  : # Interpret val[] as dereferencing
#       if   sym[0].kind == nkIdent : "*"&mincGetValueStr(sym[0], indent)
#       elif sym[0].kind == nkInfix : "*"&mincInfixList(sym[0],indent)
#       elif sym[0].kind == nkCast  : "*"&mincGetValueRaw(sym[0],indent)
#       elif sym[0].kind == nkPar   : "*"&mincGetValueRaw(sym[0][0],indent)
#       else                        : "*"&sym[0].strValue
#     elif isDotObj                 : mincDotExprList(sym).join(".")
#     else                          : mincGetValueStr(sym, indent)
#   result.add &"{indent*Tab}{name} = {val};\n"


# #______________________________________________________
# # @section Comments
# #_____________________________
# proc mincCommentStmt (code :PNode; indent :int= 0) :string=
#   assert code.kind == nkCommentStmt, code.renderTree
#   let newl = &"\n{indent*Tab}/// "
#   let cmt  = code.strValue.replace("\n", newl)
#   result.add &"{indent*Tab}/// {cmt}\n"


# #______________________________________________________
# # @section Other tools
# #_____________________________
# proc mincDiscardStmt (code :PNode; indent :int= 0) :string=
#   assert code.kind == nkDiscardStmt, code.renderTree
#   case code[0].kind
#   of nkTupleConstr,nkPar:
#     for arg in code[0]: result.add &"{indent*Tab}(void){mincGetValueStr(arg,indent)};/*discard*/\n"
#   else: result.add &"{indent*Tab}(void){mincGetValueStr(code[0],indent)};/*discard*/\n"


#______________________________________________________
# @section Source-to-Source Generator
#_____________________________
proc MinC *(code :PNode; indent :int= 0) :string=
  ## Node selector function. Sends the node into the relevant codegen function.
  # Base Cases
  # if code == nil: return
  case code.kind

  # Process this node
  #   Modules
  # of nkIncludeStmt      : result = mincIncludeStmt(code, indent)
  #   Procedures
  # of nkProcDef          : result = mincProcDef(code, indent)
  # of nkFuncDef          : result = mincProcDef(code, indent)
  #   Other Tools
  # of nkDiscardStmt      : result = mincDiscardStmt(code, indent)
  #   Function calls
  # of nkCommand          : result = mincCommand(code, indent)
  # of nkCall             : result = mincCall(code, indent)
  # Types
  # of nkTypeSection      : result = mincTypeSection(code, indent)
  # of nkTypeDef          : result = mincTypeDef(code, indent) # Accessed by nkTypeSection
  # #   Variables
  # of nkConstSection     : result = mincConstSection(code, indent)
  # of nkLetSection       : result = mincLetSection(code, indent)
  # of nkVarSection       : result = mincVarSection(code, indent)
  #   Loops
  # of nkWhileStmt        : result = mincWhileStmt(code, indent)
  # of nkForStmt          : result = mincForStmt(code, indent)
  #   Conditionals
  # of nkIfStmt           : result = mincIfStmt(code, indent)
  # of nkWhenStmt         : result = mincWhenStmt(code, indent)
  # of nkElifBranch       : result = mincElifBranch(code)
  of nkCaseStmt         : result = mincCaseStmt(code)
  #   Control flow
  # of nkReturnStmt       : result = mincReturnStmt(code, indent)
  # of nkBreakStmt        : result = mincBreakStmt(code, indent)
  # of nkContinueStmt     : result = mincContinueStmt(code, indent)
  #   Comments
  # of nkCommentStmt      : result = mincCommentStmt(code, indent)
  #   Assignment
  # of nkAsgn             : result = mincAsgn(code, indent)
  #   Pragmas
  # of nkPragma           : result = mincPragma(code, indent)
  #   Pre-In-Post.fix
  # of nkInfix            : result = mincInfix(code, indent)
  # of nkPrefix           : result = mincPrefix(code, indent)
  # of nkPostfix          : result = mincPostfix(code, indent)



  #____________________________________________________
  # TODO cases
  of nkSym              : result = mincSym(code)
  # of nkType             : result = mincType(code)
  of nkComesFrom        : result = mincComesFrom(code)

  of nkDotCall          : result = mincDotCall(code)

  of nkHiddenCallConv   : result = mincHiddenCallConv(code)
  of nkExprEqExpr       : result = mincExprEqExpr(code)
  of nkVarTuple         : result = mincVarTuple(code)
  of nkCurly            : result = mincCurly(code)
  of nkCurlyExpr        : result = mincCurlyExpr(code)
  of nkBracket          : result = mincBracket(code)
  of nkRange            : result = mincRange(code)
  of nkCheckedFieldExpr : result = mincCheckedFieldExpr(code)
  of nkDerefExpr        : result = mincDerefExpr(code)
  of nkIfExpr           : result = mincIfExpr(code)
  of nkLambda           : result = mincLambda(code)
  of nkDo               : result = mincDo(code)
  of nkAccQuoted        : result = mincAccQuoted(code)
  of nkTableConstr      : result = mincTableConstr(code)
  of nkBind             : result = mincBind(code)
  of nkClosedSymChoice  : result = mincClosedSymChoice(code)
  of nkOpenSymChoice    : result = mincOpenSymChoice(code)
  of nkHiddenStdConv    : result = mincHiddenStdConv(code)
  of nkHiddenSubConv    : result = mincHiddenSubConv(code)
  of nkConv             : result = mincConv(code)
  of nkStaticExpr       : result = mincStaticExpr(code)
  of nkAddr             : result = mincAddr(code)
  of nkHiddenAddr       : result = mincHiddenAddr(code)
  of nkHiddenDeref      : result = mincHiddenDeref(code)
  of nkObjDownConv      : result = mincObjDownConv(code)
  of nkObjUpConv        : result = mincObjUpConv(code)
  of nkChckRangeF       : result = mincChckRangeF(code)
  of nkChckRange64      : result = mincChckRange64(code)
  of nkChckRange        : result = mincChckRange(code)
  of nkStringToCString  : result = mincStringToCString(code)
  of nkCStringToString  : result = mincCStringToString(code)

  of nkGenericParams    : result = mincGenericParams(code)
  of nkFormalParams     : result = mincFormalParams(code)
  of nkOfInherit        : result = mincOfInherit(code)
  of nkImportAs         : result = mincImportAs(code)
  of nkMethodDef        : result = mincMethodDef(code)
  of nkConverterDef     : result = mincConverterDef(code)
  of nkMacroDef         : result = mincMacroDef(code)
  of nkTemplateDef      : result = mincTemplateDef(code)
  of nkIteratorDef      : result = mincIteratorDef(code)
  of nkAsmStmt          : result = mincAsmStmt(code)
  of nkPragmaBlock      : result = mincPragmaBlock(code)

  of nkOfBranch         : result = mincOfBranch(code)
  of nkElse             : result = mincElse(code)

  of nkParForStmt       : result = mincParForStmt(code)

  of nkYieldStmt        : result = mincYieldStmt(code)
  of nkDefer            : result = mincDefer(code)
  of nkTryStmt          : result = mincTryStmt(code)
  of nkFinally          : result = mincFinally(code)
  of nkRaiseStmt        : result = mincRaiseStmt(code)
  of nkExceptBranch     : result = mincExceptBranch(code)

  of nkBlockStmt        : result = mincBlockStmt(code)
  of nkStaticStmt       : result = mincStaticStmt(code)

  of nkImportStmt       : result = mincImportStmt(code)
  of nkImportExceptStmt : result = mincImportExceptStmt(code)
  of nkExportStmt       : result = mincExportStmt(code)
  of nkExportExceptStmt : result = mincExportExceptStmt(code)
  of nkFromStmt         : result = mincFromStmt(code)

  of nkBindStmt         : result = mincBindStmt(code)
  of nkMixinStmt        : result = mincMixinStmt(code)
  of nkUsingStmt        : result = mincUsingStmt(code)
  of nkStmtListExpr     : result = mincStmtListExpr(code)
  of nkBlockExpr        : result = mincBlockExpr(code)
  of nkStmtListType     : result = mincStmtListType(code)
  of nkBlockType        : result = mincBlockType(code)
  of nkWith             : result = mincWith(code)
  of nkWithout          : result = mincWithout(code)
  of nkTypeOfExpr       : result = mincTypeOfExpr(code)
  of nkTupleTy          : result = mincTupleTy(code)
  of nkTupleClassTy     : result = mincTupleClassTy(code)
  of nkTypeClassTy      : result = mincTypeClassTy(code)
  of nkStaticTy         : result = mincStaticTy(code)
  of nkRecCase          : result = mincRecCase(code)
  of nkRecWhen          : result = mincRecWhen(code)
  of nkRefTy            : result = mincRefTy(code)
  of nkConstTy          : result = mincConstTy(code)
  of nkOutTy            : result = mincOutTy(code)
  of nkDistinctTy       : result = mincDistinctTy(code)
  of nkProcTy           : result = mincProcTy(code)
  of nkIteratorTy       : result = mincIteratorTy(code)
  of nkSinkAsgn         : result = mincSinkAsgn(code)
  of nkEnumTy           : result = mincEnumTy(code)
  of nkEnumFieldDef     : result = mincEnumFieldDef(code)
  of nkArgList          : result = mincArgList(code)
  of nkPattern          : result = mincPattern(code)
  of nkHiddenTryStmt    : result = mincHiddenTryStmt(code)
  of nkClosure          : result = mincClosure(code)
  of nkGotoState        : result = mincGotoState(code)
  of nkState            : result = mincState(code)
  of nkBreakState       : result = mincBreakState(code)
  of nkTupleConstr      : result = mincTupleConstr(code)
  of nkError            : result = mincError(code)
  of nkModuleRef        : result = mincModuleRef(code)      # for .rod file support: A (moduleId, itemId) pair
  of nkReplayAction     : result = mincReplayAction(code)   # for .rod file support: A replay action
  of nkNilRodNode       : result = mincNilRodNode(code)     # for .rod file support: a 'nil' PNode

  # Unreachable
  of nkNone             : result = mincNone(code)
  # of nkEmpty            : result = mincEmpty(code)
  # of nkIdent            : result = mincIdent(code)
  # of nkConstDef         : result = mincConstDef(code)   # Accessed by nkConstSection
  # of nkIdentDefs        : result = mincIdentDefs(code)  # Accessed by nkLetSection and nkVarSection
  # of nkCharLit          : result = mincCharLit(code)
  # of nkIntLit           : result = mincIntLit(code)
  # of nkInt8Lit          : result = mincInt8Lit(code)
  # of nkInt16Lit         : result = mincInt16Lit(code)
  # of nkInt32Lit         : result = mincInt32Lit(code)
  # of nkInt64Lit         : result = mincInt64Lit(code)
  # of nkUIntLit          : result = mincUIntLit(code)
  # of nkUInt8Lit         : result = mincUInt8Lit(code)
  # of nkUInt16Lit        : result = mincUInt16Lit(code)
  # of nkUInt32Lit        : result = mincUInt32Lit(code)
  # of nkUInt64Lit        : result = mincUInt64Lit(code)
  # of nkFloatLit         : result = mincFloatLit(code)
  # of nkFloat32Lit       : result = mincFloat32Lit(code)
  # of nkFloat64Lit       : result = mincFloat64Lit(code)
  # of nkFloat128Lit      : result = mincFloat128Lit(code)
  # of nkStrLit           : result = mincStrLit(code)
  # of nkRStrLit          : result = mincRStrLit(code)
  # of nkTripleStrLit     : result = mincTripleStrLit(code)
  # of nkNilLit           : result = mincNilLit(code)
  # of nkCallStrLit       : result = mincCallStrLit(code)
  of nkExprColonExpr    : result = mincExprColonExpr(code)
  of nkObjectTy         : result = mincObjectTy(code)  # Accessed by nkTypeDef
  # of nkPtrTy            : result = mincPtrTy(code)
  # of nkVarTy            : result = mincVarTy(code)
  of nkRecList          : result = mincRecList(code)   # Accessed by nkObjectTy
  # of nkCast             : result = mincCast(code)
  # of nkBracketExpr      : result = mincBracketExpr(code)
  of nkPragmaExpr       : result = mincPragmaExpr(code)
  # of nkPar              : result = mincPar(code)
  # of nkObjConstr        : result = mincObjConstr(code)
  # of nkDotExpr          : result = mincDotExpr(code)
  of nkElifExpr         : result = mincElifExpr(code)
  of nkElseExpr         : result = mincElseExpr(code)
  # Not needed
  of nkFastAsgn         : result = mincFastAsgn(code)

  # Recursive Cases
  # of nkStmtList:
  #   for child in code: result.add MinC( child, indent )


