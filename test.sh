#!/usr/bin/env bash

logNameFile="log-ci"

logMsg() {
  printf "%s\n" "`date`: ${1}" >> "${logNameFile}"
}

logMsg "***** ci test *****"

if [ -e "./dist.tar.gz" ]
then
    logMsg "test file dist.tar.gz: success"
    exit 0
else
    logMsg "test file dist.tar.gz: fail"
    exit 1
fi
