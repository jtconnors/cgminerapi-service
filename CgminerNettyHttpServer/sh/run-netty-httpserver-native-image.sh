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
HTTPPORT="8001"
LOGMEMUSAGE="true"

exec_cmd "target/$PROJECT -cgminerHost:$CGMINERHOST -cgminerPort:$CGMINERPORT -httpPort:$HTTPPORT -logMemUsage:$LOGMEMUSAGE"
