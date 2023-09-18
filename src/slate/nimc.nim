#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/paths
import std/strformat
# nimc dependencies
import "$nim"/compiler/[ ast, parser, idents, options, lineinfos, msgs, pathutils, syntaxes ]
from   "$nim"/compiler/renderer import renderTree
# *Slate dependencies
import ./format


type ASTError = object of CatchableError
#______________________________________________________
# Forward what we need outside to manage the AST
export ast
export renderTree
#______________________________________________________
# broken. Needs the ConfigRef generated from the parsing process
# from   "$nim"/compiler/astalgo  import treeToYaml, debug
# proc treeToYaml *(node :PNode) :string= treeToYaml(options.newConfigRef(), node).string
# proc debugAST *(node :ast.PNode) :string=  debug(node)
#______________________________________________________
# AST formatting
func strValue *(node :PNode) :string=
  if node == nil: return
  case node.kind
  of nkSym                     : result = node.sym.name.s
  of nkIdent                   : result = node.ident.s
  of nkCharLit..nkUInt64Lit    : result = $node.intVal
  of nkFloatLit..nkFloat128Lit : result = $node.floatVal
  of nkStrLit..nkTripleStrLit  : result = node.strVal
  else:raise newException(ASTError, &"Tried to get the strValue of a node that doesn't have one.\n  {$node.kind}\n")
#_____________________________
func treeRepr *(node :PNode; ident :int= 0) :string=
  ## Returns the treeRepr of the given AST.
  ## Similar to NimNode.treeRepr, but for PNode.
  # Base Case
  if node == nil: return
   # Process this node
  result.add &"{ident*Sep}{$node.kind}"
  case node.kind
  of nkSym, nkIdent, nkCharLit..nkTripleStrLit: result.add &"{Spc}{node.strValue}"
  else:discard
  result.add "\n"
  # Recurse all subnodes
  for child in node: result.add child.treeRepr(ident+1)


#______________________________________________________
# AST Reading
#_____________________________
proc readASTall *(file :Path) :ast.PNode=
  # Alternative version of readAST using parser.parseAll()
  var conf    = options.newConfigRef()
  let fileIdx = msgs.fileInfoIdx(conf, pathutils.AbsoluteFile file.string)
  var pars :parser.Parser
  if syntaxes.setupParser(pars, fileIdx, idents.newIdentCache(), conf):
    result = parser.parseAll(pars)
    parser.closeParser(pars)
#_____________________________
var errorStr :string
proc errorAST (conf :options.ConfigRef; info :lineinfos.TLineInfo; msg :lineinfos.TMsgKind; arg :string)=
  if errorStr.len == 0 and msg <= errMax:
    errorStr = msgs.formatMsg(conf, info, msg, arg)
    debugEcho errorStr
#_____________________________
proc getAST *(code :string; file :string= "") :ast.PNode=
  ## Gets the AST of the given code. The given file path is used for error messages.
  var cache  = idents.newIdentCache()
  var config = options.newConfigRef()
  result = parser.parseString(
    s            = code,
    cache        = cache,
    config       = config,
    filename     = file,
    line         = 0,
    errorHandler = errorAST
    ) # << parser.parseString( ... )
#_____________________________
proc readAST *(file :Path) :ast.PNode= nimc.getAST(file.string.readFile(), file.string)
  ## Reads the AST of the given nim file.

