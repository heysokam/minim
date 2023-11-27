#!/usr/bin/env sh
set -u # error on undefined variables
set -e # exit on first error
thisDir=$(dirname "$(realpath "$BASH_SOURCE")")
# Project setup
Prefix="ᛟ minc:"          # Prefix to append to all console info messages
rootDir="$thisDir/../.."  # Find the root folder of the repository
srcDir="$rootDir/src"     # Source Code foder
binDir="$rootDir/bin"     # Binaries output folder
libDir="$srcDir/lib"      # External Libs folder
nimRel="src/lib/nim"      # nim submodule folder (relative)
nimDir="$libDir/nim"      # nim submodule folder (absolute)
nimMaj=2                  # Major nim version that MinC tracks
nimMin=0                  # Minor nim version that MinC tracks
nimBranch="version-$nimMaj-$nimMin"  # Name of the Nim branch that MinC tracks
nim="$nimDir/bin/nim"     # Nim binary result after it has been bootstrapped
