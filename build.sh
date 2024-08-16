#!/usr/bin/env bash

logMsg() {
  printf "%s\n" "`date`: ${1}" >> "${logNameFile}"
}

echo "***** dist ci test *****"

logNameFile="log-ci"

dist="dist"

if [ ! -d "$dist" ]; then
  logMsg "create directory ${dist}"
  mkdir "${dist}"
fi

logMsg "copi files code1.js"
cp "code1.js" "${dist}/code1.js"

logMsg "copi files code2.js"
cp "code2.js" "${dist}/code2.js"
