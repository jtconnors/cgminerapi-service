
####################
#
# All Scripts should have this preamble     
#
Set-variable -Name CMDLINE_ARGS -Value $args

#
# Move to the directory containing this script so we can source the env.ps1
# properties that follow
#
$STARTDIR = pwd | Select-Object | %{$_.ProviderPath}
cd $PSScriptRoot

#
# Common properties shared by scripts
#
. .\env.ps1
if ($Global:JUST_EXIT -eq "true") {
    cd $STARTDIR
    Exit 1
}
#
# End preamble
#
####################

#
# Run the Java command
#
Set-Variable -Name TRACING_AGENT -Value "-agentlib:native-image-agent=config-merge-dir=src\main\resources\META-INF\native-image\"
$TRACING_AGENT += $MAINCLASS
Set-Variable -Name JAVA_ARGS -Value @(
    """$TRACING_AGENT""",
    '-classpath',
    """$CLASSPATH""",
    """$MAINCLASS""",
    '-cgminerHost:jtconnors.com',
    '-cgminerPort:4028',
    '-httpPort:8001',
    '-logMemUsage:true'
)
Exec-Cmd("$env:JAVA_HOME\bin\java.exe", $JAVA_ARGS)

#
# Return to the original directory
#
cd $STARTDIR
