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
# No command-line arg for http port for this version.  Quarkus allows port
# configuration by specifying it in src/main/resources/application.properties
# file as follows:
#quarkus.http.port=8001

exec_cmd 'mvn exec:java -Dexec.args="-cgminerHost:$CGMINERHOST -cgminerPort:$CGMINERPORT -debugLog:$DEBUGLOG -logMemUsage:$LOGMEMUSAGE"'
