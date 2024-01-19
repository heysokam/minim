#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
import nstd/paths

#_______________________________________
# @section Package Information
const Version *{.strdefine.}= "dev." & gorge "git --no-pager log -n 1 --pretty=format:%H"

#_______________________________________
# @section Format
const Tab     *{.strdefine.}= "  "
const Prefix  *{.strdefine.}= "ᛟ minc"

#_______________________________________
# @section ZigCC
var zigBin :Path= getCurrentDir()/"bin"/".zig"/"zig"
  ## @descr
  ##  Default zig binary will be searched in "./bin/.zig/zig"
  ##  Can be changed with --zigBin:path from cli
