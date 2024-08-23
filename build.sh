#!/usr/bin/env bash

logNameFile="log-ci"

logMsg() {
  printf "%s\n" "`date`: ${1}" >> "${logNameFile}"
}

logMsg "***** ci build *****"

dist="dist"

if [ ! -d "$dist" ]; then
  logMsg "create directory ${dist}"
  mkdir "${dist}"
fi

logMsg "copi files code1.js"
cp "src/code1.js" "${dist}/code1.js"

logMsg "copi files code2.js"
cp "src/code2.js" "${dist}/code2.js"

logMsg "LICENSE files LICENSE"
cp "LICENSE" "${dist}/LICENSE"