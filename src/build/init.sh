#!/usr/bin/env sh
thisDir=$(dirname "$(realpath "$BASH_SOURCE")")
source $thisDir/cfg.sh           # Load config options
thisDir=$(dirname "$(realpath "$BASH_SOURCE")")
prevDir="$PWD"                   # Store current folder from where this script is called

# Clean Folders
sh $thisDir/clean/bin.sh         # Clean the rootDir/bin folder
sh $thisDir/clean/nim.sh         # Clean the nimDir folder

# Build Nim
build_nim () {
  cd $nimDir                     # Go to nim's folder
  sh ./build_all.sh              # Initialize Nim
  cd $rootDir                    # Go back to root
  cp -r $nimDir/bin $binDir/nim  # Copy the bootstrapping output into rootDir/bin/nim
}
wrn="$Prefix Do you want to bootstrap Nim?"$'\n'$"  [Recommended (yes)]  (y/n)? "
read -rep "$wrn" -n 1 answer
case "$answer" in
  "y" | "Y" | "" ) echo "$Prefix Building Nim into $binDir ..." ; build_nim ;;
  "n" | "N" | *  ) echo "$Prefix Continuing without building Nim."          ;;
esac
# Link Nim's folder to HOME
cnimHome=$HOME/.cnim
wrn="$Prefix Do you want to create a symbolic link to Nim's repository at $cnimHome ?"$'\n'$"  [Recommended (yes)]  (y/n)? "
read -rep "$wrn" -n 1 answer
case "$answer" in
  "y" | "Y" | "" ) echo "$Prefix Linking Nim's repository into $cnimHome ..." ; ln -s $nimDir $cnimHome ;;
  "n" | "N" | *  ) echo "$Prefix Continuing without Linking Nim's repository. Make sure the folder exists, or rerun this script and pick (yes)." ;;
esac

# Build MinC
build_minc () {
  cd $rootDir
  $nim confy.nims minc           # Compile the MinC compiler
}
wrn="$Prefix Do you want to build MinC?"$'\n'$"  [Recommended (yes)]  (y/n)? "
read -rep "$wrn" -n 1 answer
case "$answer" in
  "y" | "Y" | "" ) echo "$Prefix Building MinC into $binDir ..." ; build_minc ;;
  "n" | "N" | *  ) echo "$Prefix Continuing without building MinC."           ;;
esac
# Link MinC's folder to HOME
mincHome=$HOME/.minc
wrn="$Prefix Do you want to create a symbolic link from MinC's root folder $rootDir to $mincHome ?"$'\n'$"  [Recommended (yes)]  (y/n)? "
read -rep "$wrn" -n 1 answer
case "$answer" in
  "y" | "Y" | "" ) echo "$Prefix Linking MinC's root folder to $mincHome ..." ; ln -s $rootDir $mincHome ;;
  "n" | "N" | *  ) echo "$Prefix Continuing without linking MinC's root folder. Make sure the folder exists, or rerun this script and pick (yes)." ;;
esac

# Go back to the folder from where this script was called
cd $prevDir
