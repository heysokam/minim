#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/paths
import std/strformat
import std/strutils
# Module dependencies
import ../nimc as nim
import ../types
import ../format


#___________________________________________________________
# Generator Codegen Templates
#_____________________________
const GenDepends = """
import std/strformat
import "$nim"/compiler/ast

"""
const GenTodoTempl = """
template todo (code :PNode) :void=  raise newException(IOError, &"Interpreting {{code.kind}} is currently not supported for {lang.name}. Its Nim code is:\n{{code.toStrLit}}\n")

"""
const GenCaseFuncTempl = """
proc {kind.toFuncName(lang)} (code :PNode) :string=  assert code.kind == {$kind}; todo(code.kind)  ## TODO : Converts a {$kind} into the {lang.name} Language
"""
const GenFuncTempl = """
proc {lang.pfx.firstUpper()} (code :PNode) :string=
  ## Node selector function. Sends the node into the relevant codegen function.
"""
const GenMacroTempl = """
macro to{lang.pfx.firstUpper()} *(code :typed) :string=  newLit {lang.pfx.firstUpper()}( code )
  ## Converts a block of Nim code into the {lang.name} Language
"""
const GenTempl  = "{GenDepends}{genTodo}{cases}{genFunc}{genMacro}"


#___________________________________________________________
# Generator Helpers
#_____________________________
func toFuncName (kind :nim.TNodeKind; lang :Lang) :string=  replace($kind, "nk", lang.pfx)
  ## Generates a function name for the given kind+lang


#___________________________________________________________
# Generator API
#_____________________________
proc writeGenProto *(file :Path; lang :Lang) :void=
  ## Writes a generator prototype for the given language into the given file.
  # Todo helper for non-implemented cases
  var genTodo = fmt GenTodoTempl

  # Generator cases
  var cases :string= &"## Generator Cases for {lang.name}\n"
  for kind in nim.TNodeKind:
    cases.add fmt(GenCaseFuncTempl)
  cases.add "\n"

  # Final generator function
  var genFunc :string= fmt GenFuncTempl
  genFunc.add "  case code.kind\n"
  for kind in nim.TNodeKind:
    genFunc.add &"  of {$kind}: result = {kind.toFuncName(lang)}(code)\n"
  genFunc.add "\n"

  # Final Macro exposed to the user
  var genMacro :string= fmt GenMacroTempl
  genMacro.add "\n"

  # Write the output into the file
  file.string.writeFile( fmt GenTempl )

