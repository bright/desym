#!/bin/sh

set -e
set -o pipefail

IPA_COUNT=`find . -name \*.ipa | wc -l`
DSYM_ZIP_COUNT=`find . -name \*.dsym.zip | wc -l`

red=`tput setaf 1`
gray=`tput setaf 8`
green=`tput setaf 2`
reset=`tput sgr0`

function exitWithError {
  echo "${red}${1}${reset}"
  exit
}

function logDebug {
  echo "${gray}${1}${reset}"
}

if [ $IPA_COUNT -eq 0 ];
then
  exitWithError "Can't locate any ipa file in current directory"
fi


if [ $IPA_COUNT -gt 1 ];
then
  exitWithError "More than one ipa file in current directory"
fi

if [ $DSYM_ZIP_COUNT -eq 0 ];
then
  exitWithError "Can't locate any dsym.zip file in current directory"
fi


if [ $DSYM_ZIP_COUNT -gt 1 ];
then
  exitWithError "More than one dsym.zip file in current directory"
fi

if [ -z "$1" ];
then
  exitWithError "Please pass memory address as an argument"
fi


IPA=`find . -name \*.ipa`
DSYM_ZIP=`find . -name \*.dsym.zip`

TEMP_DIR=`mktemp -d`

logDebug "Created temp directory $TEMP_DIR"

function cleanup {
    logDebug "Cleaning up"
    logDebug "Removing temp directory $TEMP_DIR"
    rm -rf $TEMP_DIR
    logDebug "Temp directory removed"
}

trap cleanup EXIT

unzip -qq "$IPA" -d $TEMP_DIR
unzip -qq "$DSYM_ZIP" -d $TEMP_DIR

APP_DIR=`find $TEMP_DIR -name \*.app`
APP_NAME=${APP_DIR%????}  # http://unix.stackexchange.com/a/144300
APP_NAME=${APP_NAME##*/}  # http://stackoverflow.com/a/3162500/59666

XCARCHIVE=`find $TEMP_DIR -name \*.xcarchive`

echo $green

cd $TEMP_DIR

mv $XCARCHIVE/dSYMs/$APP_NAME.app.dSYM Payload/

atos -arch armv7 -o $APP_DIR/$APP_NAME $@
cd - > /dev/null

echo $reset
