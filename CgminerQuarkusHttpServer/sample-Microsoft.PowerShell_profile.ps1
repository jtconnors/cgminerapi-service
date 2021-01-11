#
# Sample Microsoft.PowerShell_profile.ps1 file. This will
# set the PowerShell environment at PowerShell start up.
#
# This file can be:
# o renamed to Microsoft.PowerShell_profile.ps1 and placed in the
#   User's Documents\WindowsPowerShell directory
# o edited to reflect your JDK environment
#

$env:PATH = 'd:\Oracle\graalvm-ee-java11-20.3.0\bin;' + $env:PATH
$env:JAVA_HOME = 'd:\Oracle\graalvm-ee-java11-20.3.0'