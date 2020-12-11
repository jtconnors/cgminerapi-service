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
HTTPPORT="8000"

exec_cmd "java -classpath $CLASSPATH $MAINCLASS -cgminerHost:$CGMINERHOST -cgminerPort:$CGMINERPORT -httpPort:$HTTPPORT"