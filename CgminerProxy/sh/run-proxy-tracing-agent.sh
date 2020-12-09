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

LOCALPORT=4028
REMOTEHOST=49er
REMOTEPORT=4028

exec_cmd "java -agentlib:native-image-agent=config-merge-dir=src/main/resources/META-INF/native-image/$MAINCLASS -classpath $CLASSPATH $MAINCLASS -localPort:$LOCALPORT -remoteHost:$REMOTEHOST -remotePort:$REMOTEPORT"

