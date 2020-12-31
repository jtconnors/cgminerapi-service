#!/bin/bash

#
# Move to the directory containing this script so we can source the env.sh
# properties that follow
#
cd `dirname $0`

#
# Common properties shared by scripts
#
. env.sh

CGMINERHOST="jtconnors.com"
CGMINERPORT="4028"
DEBUGLOG=false
LOGMEMUSAGE=true
# No command-line arg for http port for this version.  Micronaut allows port
# configuration either by specifying it in src/main/resources/application.yml
# or defining the following environment variable:
#export MICRONAUT_SERVER_PORT=8001

exec_cmd "java -agentlib:native-image-agent=config-merge-dir=src/main/resources/META-INF/native-image/$MAINCLASS -classpath $CLASSPATH $MAINCLASS -cgminerHost:$CGMINERHOST -cgminerPort:$CGMINERPORT  -debugLog:$DEBUGLOG -logMemUsage:$LOGMEMUSAGE"

