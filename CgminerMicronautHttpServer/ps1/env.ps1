
#
# JAVA_HOME environment variable must be set either externally in the Poweshell
# environment or internally here by uncommenting out the Set-Variable line
# below and assiging it the location of a valid JDK 15 runtime.
#
#$env:JAVA_HOME = 'D:\openjdk\jdk-15'

#
# Unless these script files have been deliberately moved, the parent
# directory of the directory containining these script files houses
# the maven project and source code.
#
Set-Variable -Name PROJECTDIR -Value ".."

#
# native platform
#
Set-Variable -Name PLATFORM -Value win

#
# Application specific variables
#
Set-Variable -Name PROJECT -Value CgminerMicronautHttpServer
Set-Variable -Name VERSION -Value "1.0-JDK8"
Set-Variable -Name MAINCLASS -Value com.jtconnors.cgminerapi.micronaut.Application
Set-Variable -Name MAINJAR -Value $PROJECT-$VERSION.jar

#
# Local maven repository for jars
#
Set-Variable -Name REPO -Value $HOME\.m2\repository

#
# Directory under which maven places compiled classes and built jars
#
Set-Variable -Name TARGET -Value target

#
# Required external modules for this application
#

Set-Variable -Name FASTER_XML_VERSION -Value 2.11.2
Set-Variable -Name MICRONAUT_VERSION -Value 2.2.1
Set-Variable -Name NETTY_VERSION -Value 4.1.54
Set-Variable -Name SLF4J_VERSION -Value 1.7.30

Set-Variable -Name EXTERNAL_CLASSPATH -Value @(
    "$REPO\com\fasterxml\jackson\core\jackson-annotations\$FASTER_XML_VERSION\jackson-annotations-$FASTER_XML_VERSION.jar"
	"$REPO\com\fasterxml\jackson\core\jackson-core\$FASTER_XML_VERSION\jackson-core-$FASTER_XML_VERSION.jar"
	"$REPO\com\fasterxml\jackson\core\jackson-databind\$FASTER_XML_VERSION\jackson-databind-$FASTER_XML_VERSION.jar"
	"$REPO\com\fasterxml\jackson\core\jackson-datatype-jdk8\$FASTER_XML_VERSION\jackson-datatype-jdk8-$FASTER_XML_VERSION.jar"
	"$REPO\com\fasterxml\jackson\core\jackson-datatype-jsr310\$FASTER_XML_VERSION\jackson-datatype-jsr310-$FASTER_XML_VERSION.jar"
	"$REPO\com\github\spotbugs\spotbugs-annotations\4.0.3\spotbugs-annotations-4.0.3.jar"
	"$REPO\com\google\code\findbugs\jsr305\3.0.2\jsr305-3.0.2.jar"
    "$REPO\com\jtconnors\com.jtconnors.cgminerapi\4.10.0.1-JDK8\com.jtconnors.cgminerapi-4.10.0.1-JDK8.jar"
	"$REPO\commons-io\commons-io\2.5\commons-io-2.5.jar"
	"$REPO\io\micronaut\micronaut-aop\$MICRONAUT_VERSION\micronaut-aop-$MICRONAUT_VERSION.jar"
	"$REPO\io\micronaut\micronaut-buffer-netty\$MICRONAUT_VERSION\micronaut-buffer-netty-$MICRONAUT_VERSION.jar"
	"$REPO\io\micronaut\micronaut-core\$MICRONAUT_VERSION\micronaut-core-$MICRONAUT_VERSION.jar"
	"$REPO\io\micronaut\micronaut-http\$MICRONAUT_VERSION\micronaut-http-$MICRONAUT_VERSION.jar"
	"$REPO\io\micronaut\micronaut-http-netty\$MICRONAUT_VERSION\micronaut-http-netty-$MICRONAUT_VERSION.jar"
	"$REPO\io\micronaut\micronaut-http-server\$MICRONAUT_VERSION\micronaut-http-server-$MICRONAUT_VERSION.jar"
	"$REPO\io\micronaut\micronaut-http-server-netty\$MICRONAUT_VERSION\micronaut-http-server-netty-$MICRONAUT_VERSION.jar"
	"$REPO\io\micronaut\micronaut-inject\$MICRONAUT_VERSION\micronaut-inject-$MICRONAUT_VERSION.jar"
	"$REPO\io\micronaut\micronaut-router\$MICRONAUT_VERSION\micronaut-router-$MICRONAUT_VERSION.jar"
	"$REPO\io\micronaut\micronaut-runtime\$MICRONAUT_VERSION\micronaut-runtime-$MICRONAUT_VERSION.jar"
	"$REPO\io\micronaut\micronaut-validation\$MICRONAUT_VERSION\micronaut-validation-$MICRONAUT_VERSION.jar"
	"$REPO\io\micronaut\micronaut-websocket\$MICRONAUT_VERSION\micronaut-websocket-$MICRONAUT_VERSION.jar"
	"$REPO\io\netty\netty-buffer\$NETTY_VERSION.Final\netty-buffer-$NETTY_VERSION.Final.jar"
	"$REPO\io\netty\netty-codec-http\$NETTY_VERSION.Final\netty-codec-http-$NETTY_VERSION.Final.jar"
	"$REPO\io\netty\netty-codec-http2\$NETTY_VERSION.Final\netty-codec-http2-$NETTY_VERSION.Final.jar"
	"$REPO\io\netty\netty-codec\$NETTY_VERSION.Final\netty-codec-$NETTY_VERSION.Final.jar"
	"$REPO\io\netty\netty-common\$NETTY_VERSION.Final\netty-common-$NETTY_VERSION.Final.jar"
	"$REPO\io\netty\netty-handler\$NETTY_VERSION.Final\netty-handler-$NETTY_VERSION.Final.jar"
	"$REPO\io\netty\netty-resolver\$NETTY_VERSION.Final\netty-resolver-$NETTY_VERSION.Final.jar"
	"$REPO\io\netty\netty-transport\$NETTY_VERSION.Final\netty-transport-$NETTY_VERSION.Final.jar"
	"$REPO\io\reactivex\rxjava2\rxjava\2.2.10\rxjava-2.2.10.jar"
	"$REPO\io\swagger\core\v3\swagger-annotations\2.1.5\swagger-annotations-2.1.5.jar"
	"$REPO\javax\annotation\javax.annotation-api\1.3.2\javax.annotation-api-1.3.2.jar"
	"$REPO\javax\inject\javax.inject\1\javax.inject-1.jar"
	"$REPO\javax\json\javax.json.api\1.1.4\json-api-1.1.4.jar"
	"$REPO\javax\validation\validation-api\2.0.1.Final\validation-api-2.0.1.Final.jar"
	"$REPO\org\apache\commons\commons-compress\1.11\commons-compress-1.11.jar"
	"$REPO\org\glassfish\javax.json\1.1\javax.json-1.1.jar"
	"$REPO\org\iq80\snappy\snappy\0.4\snappy-0.4.jar"
	"$REPO\org\reactivestreams\reactive-streams\1.0.3\reactive-streams-1.0.3.jar"
	"$REPO\org\slf4j\slf4j-api\$SLF4J_VERSION\slf4j-api-$SLF4J_VERSION.jar"
	"$REPO\org\slf4j\slf4j-simple\$SLF4J_VERSION\slf4j-simple-$SLF4J_VERSION.jar"
	"$REPO\org\tukaani\xz\1.5\xz-1.5.jar"
	"$REPO\org\yaml\snakeyaml\1.26\snakeyaml-1.26.jar"
)

#
# Create a CLASSPATH for the java command.  It either includes the classes
# in the $TARGET directory or the $TARGET/$MAINJAR (if it exists) and the
# $EXTERNAL_CLASSPATH defined in env.ps1.
#
if (Test-Path $PROJECTDIR\$TARGET\$MAINJAR) {
    Set-Variable -Name CLASSPATH -Value $TARGET\$MAINJAR
} else {
     Set-Variable -Name CLASSPATH -Value $TARGET\classes
}
ForEach ($i in $EXTERNAL_CLASSPATH) {
   $CLASSPATH += ";"
   $CLASSPATH += $i
}

Set-Variable -Name SCRIPT_NAME -Value $MyInvocation.MyCommand.Name

#
# Function to print command-line options to standard output
#
function Print-Options {
    Write-Output "usage: ${SCRIPT_NAME} [-?,--help,-e,-n,-v]"
    Write-Output "  -? or --help - print options to standard output and exit"
    Write-Output "  -e - echo the jdk command invocations to standard output"
    Write-Output "  -n - don't run the java commands, just print out invocations"
    Write-Output "  -v - --verbose flag for jdk commands that will accept it"
}

#
# Process command-line arguments:  Not all flags are valid for all invocations,
# but we'll parse them anyway.
#
#   -? or --help  print options to standard output and exit
#   -e	echo the jdk command invocations to standard output
#   -n  don't run the java commands, just print out invocations
#   -v 	--verbose flag for jdk commands that will accept it
#
Set-Variable -Name VERBOSE_OPTION -Value $null
Set-Variable -Name ECHO_CMD -Value false
Set-Variable -Name EXECUTE_OPTION -Value true
Set-Variable -Name JUST_EXIT -Value false -Scope Global


Foreach ($arg in $CMDLINE_ARGS) {
    switch ($arg) {
        '-?' {
            Print-Options
            Set-Variable -Name JUST_EXIT -Value true -Scope Global 
        }
        '--help' {
            Print-Options
            Set-Variable -Name JUST_EXIT -Value true -Scope Global
        }
        '-e' { 
            Set-Variable -Name ECHO_CMD -Value true   
        }
        '-n' { 
            Set-Variable -Name ECHO_CMD -Value true
            Set-Variable -Name EXECUTE_OPTION -Value false   
        }
        '-v' {
            Set-Variable -Name VERBOSE_OPTION -Value "--verbose"
        }
        default {
            Write-Output "${SCRIPT_NAME}: bad option '$arg'"
            Print-Options
            Set-Variable -Name JUST_EXIT -Value true -Scope Global
        }
    }
}

#
# Print a command with all its args on one line. 
#
function Print-Cmd {
    Write-Output ""
    Foreach ($item in $args[0]) {
       $CMD += $item
       $CMD += " "
    }
    Write-Output $CMD
}

#
# Function to print out an error message and exit with exitcode
#
function GoodBye($MSG, $EXITCODE) {
   Write-Output $MSG
   Set-Variable -Name JUST_EXIT -Value true -Scope Global
   Exit $EXITCODE    
}

#
# Function to execute command specified by arguments.
# If $ECHO_CMD is true then print the command out to standard output first.
# If $EXECUTE_OPTION is set to anything other than "true", then don't execute
# command, just print it out.
#
function Exec-Cmd {
    Set-Variable -Name OPTIONS -Value @()
    $COMMAND = $($args[0][0])
    Foreach ($item in $args[0][1]) {
       $OPTIONS += $item
    }
    if ($ECHO_CMD -eq "true") {
        Print-Cmd ($COMMAND, $OPTIONS)
    }
    if ($EXECUTE_OPTION -eq "true") {
        & $COMMAND $OPTIONS
    }
}

#
# Check if $PROJECTDIR exists
#
if (-not (Test-Path $PROJECTDIR)) {
	GoodBye " Project Directory '$PROJECTDIR' does not exist. Edit PROJECTDIR variable in ps1\env.ps1." $LASTEXITCODE
}

#
# Check if $env:JAVA_HOME is both set and assigned to a valid Path
#
if ($env:JAVA_HOME -eq $null) {
    GoodBye "env:JAVA_HOME Environment Variable is not set. Set the env:JAVA_HOME variable to a vaild JDK runtime location in your Powershell environment or uncomment and edit the 'set-Variable' statement at the beginning of the ps1\env.ps1 file." $LASTEXITCODE 
} elseif (-not (Test-Path $env:JAVA_HOME)) {
	GoodBye "Path for Java Home 'env:JAVA_HOME' does not exist. Set the env:JAVA_HOME variable to a vaild JDK runtime location in your Powershell environment or uncomment and edit the 'set-Variable' statement at the beginning of the ps1\env.ps1 file." $LASTEXITCODE 
}

cd $PROJECTDIR
