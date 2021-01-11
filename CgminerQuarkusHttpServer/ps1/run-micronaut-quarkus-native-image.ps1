
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
# Run the native-image command
#
# No command-line arg for http port for this version.  Micronaut allows port
# configuration either by specifying it in src/main/resources/application.yml
# or defining the following environment variable:
#Set-Variable -Name MICRONAUT_SERVER_PORT -Value 8001

Set-Variable -Name NI_ARGS -Value @(
    '-cgminerHost:jtconnors.com',
    '-cgminerPort:4028',
    '-debugLog:false',
    '-logMemUsage:true'
)

Exec-Cmd(".\target\$PROJECT-$VERSION-runner", $NI_ARGS)

#
# Return to the original directory
#
cd $STARTDIR
