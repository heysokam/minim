# @deps std
from std/os import nil
# @deps ndk
import nstd/modules
# Import all tests recursively
const thisDir = os.parentDir(currentSourcePath())
modules.importAllRec( thisDir, ["test.nim"] )
