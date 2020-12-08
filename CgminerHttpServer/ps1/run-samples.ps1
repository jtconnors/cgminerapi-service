
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
# Varaible arguments to be used for executing Java program below
#
Set-Variable -Name CGMINERHOST -Value "49er"
Set-Variable -Name CGMINERPORT -Value 4028

#
# Run the Java command
#
Set-Variable -Name JAVA_ARGS -Value @(
    '-classpath',
    """$CLASSPATH""",
    """$MAINCLASS""",
    """-cgminerHost:$CGMINERHOST""",
    """-cgminerPort:$CGMINERPORT"""
)
Exec-Cmd("$env:JAVA_HOME\bin\java.exe", $JAVA_ARGS)

#
# Return to the original directory
#
cd $STARTDIR
