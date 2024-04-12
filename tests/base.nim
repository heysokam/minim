# @warning MUST be `include`d, not `import`ed
#_______________________________________
# @section Dependencies used by all tests
# @deps std
import std/unittest
from std/os import parentDir, lastPathPart
from std/strformat import `&`

#_______________________________________
# @section Tests Tools
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

