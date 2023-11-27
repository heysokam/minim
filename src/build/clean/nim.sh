#!/usr/bin/env bash
thisDir=$(dirname "$(realpath "$BASH_SOURCE")")
source "$thisDir/../cfg.sh"   # Load config options
thisDir=$(dirname "$(realpath "$BASH_SOURCE")")

# Process
clean_nimDir () {
  prevDir=$PWD
  cd $rootDir
  git rm -f $nimDir
  git submodule add --force --depth=1 https://github.com/nim-lang/Nim.git $nimRel
  cd $nimDir
  git remote set-branches origin $nimBranch
  git fetch -v --depth=1
  git checkout $nimBranch
  git reset --hard
  git clean -fdx
  git pull
  cd $prevDir
}
dir=$(realpath $nimDir)
wrn="$Prefix Warning-> This will delete everything at $dir . Continue?"$'\n'$"  [Recommended (yes)]  (y/n)? "
read -rep "$wrn" -n 1 answer
case "$answer" in
  "y" | "Y" | "" ) echo "$Prefix Cleaning $dir ..." ; clean_nimDir ;;
  "n" | "N" | *  ) echo "$Prefix Continuing without removing $dir" ;;
esac
