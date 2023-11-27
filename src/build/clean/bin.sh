#!/usr/bin/env bash
thisDir=$(dirname "$(realpath "$BASH_SOURCE")")
source "$thisDir/../cfg.sh"   # Load config options
thisDir=$(dirname "$(realpath "$BASH_SOURCE")")

clean_binDir () {
  rm -rfv $binDir
  mkdir -v $binDir
  echo -e "*\n!.gitignore" > "$binDir"/.gitignore
}
dir=$(realpath $binDir)
wrn="$Prefix Warning-> This will delete everything at $dir. Continue?"$'\n'$"  [Recommended (yes)]  (y/n)? "
read -rep "$wrn" -n 1 answer
case "$answer" in
  "y" | "Y" | "" ) echo "$Prefix Cleaning $(realpath $dir) ..."; clean_binDir ;;
  "n" | "N" | *  ) echo "$Prefix Continuing without removing $dir"            ;;
esac
