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

logMsg "copi files code1"
cp "code1" "${dist}/code1"

logMsg "copi files code2"
cp "code2" "${dist}/code2"
