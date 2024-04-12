# @deps std
import std/unittest
from std/os import parentDir, lastPathPart
from std/strformat import `&`
# @section Forward Imports used by all tests
export unittest
export os.parentDir
export os.lastPathPart

#_______________________________________
# @section Tests Tools
#_____________________________
var ID = int.high
proc resetID *() :void= ID = int.high
#_____________________________
template name *(
    descr : string;
    testN : string = "test";
    title : string = "";
  ) :string=
  ## @descr Confusing syntax. Returns the correct prefix for the given test information
  let t = when declared(Title): Title else: title
  let n = when declared(tName): tName else: testN
  n&": " & (
    if t != "" : t&" | " else: ""
    ) & descr
