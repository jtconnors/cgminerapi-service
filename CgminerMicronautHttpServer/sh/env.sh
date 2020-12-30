
# 
# JAVA_HOME environment variable must be set either externally in your
# environment or internally here by uncommenting out one of the lines
# below and assiging it the location of a valid JDK runtime.
#
# MacOS example
#export JAVA_HOME="~/IDE/jdk-14.jdk/Contents/Home"
# Linux Example
#export JAVA_HOME="~/jdk-14"

#
# Unless these script files have been deliberately moved, the parent
# directory of the directory containining these script files houses
# the maven project and source code.
#
PROJECTDIR=..

#
# Determine Operating System platform. Currently only MacOS (PLATFORM=mac)
# and Linux (PLATFORM=linux) are supported for this script.
#
case "$(uname)" in
	Darwin)
		PLATFORM=mac
		;;
	Linux)
		PLATFORM=linux
		;;
	*)
		echo "Only x86_64 versions of MacOS or Linux supported, '$(uname)' unavailable."
	exit 1
esac

#
# Application specific variables
#
PROJECT=CgminerMicronautHttpServer
VERSION=1.0-JDK8
MAINCLASS=com.jtconnors.cgminerapi.micronaut.Application
MAINJAR=$PROJECT-$VERSION.jar

#
# Local maven repository for jars
#
REPO=~/.m2/repository

#
# Directory under which maven places compiled classes and built jars
#
TARGET=target

#
# Required external modules for this application
#
# The monstrosity below was derived by looking at the debug
# output running 'mvn -X exec:java'
#

FASTER_XML_VERSION=2.11.2
MICRONAUT_VERSION=2.2.1
NETTY_VERSION=4.1.54
SLF4J_VERSION=1.7.30

EXTERNAL_CLASSPATH=(
    "$REPO/com/fasterxml/jackson/core/jackson-annotations/$FASTER_XML_VERSION/jackson-annotations-$FASTER_XML_VERSION.jar"
	"$REPO/com/fasterxml/jackson/core/jackson-core/$FASTER_XML_VERSION/jackson-core-$FASTER_XML_VERSION.jar"
	"$REPO/com/fasterxml/jackson/core/jackson-databind/$FASTER_XML_VERSION/jackson-databind-$FASTER_XML_VERSION.jar"
	"$REPO/com/fasterxml/jackson/core/jackson-datatype-jdk8/$FASTER_XML_VERSION/jackson-datatype-jdk8-$FASTER_XML_VERSION.jar"
	"$REPO/com/fasterxml/jackson/core/jackson-datatype-jsr310/$FASTER_XML_VERSION/jackson-datatype-jsr310-$FASTER_XML_VERSION.jar"
	"$REPO/com/github/spotbugs/spotbugs-annotations/4.0.3/spotbugs-annotations-4.0.3.jar"
	"$REPO/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar"
    "$REPO/com/jtconnors/com.jtconnors.cgminerapi/4.10.0.1-JDK8/com.jtconnors.cgminerapi-4.10.0.1-JDK8.jar"
	"$REPO/commons-io/commons-io/2.5/commons-io-2.5.jar"
	"$REPO/io/micronaut/micronaut-aop/$MICRONAUT_VERSION/micronaut-aop-$MICRONAUT_VERSION.jar"
	"$REPO/io/micronaut/micronaut-buffer-netty/$MICRONAUT_VERSION/micronaut-buffer-netty-$MICRONAUT_VERSION.jar"
	"$REPO/io/micronaut/micronaut-core/$MICRONAUT_VERSION/micronaut-core-$MICRONAUT_VERSION.jar"
	"$REPO/io/micronaut/micronaut-http/$MICRONAUT_VERSION/micronaut-http-$MICRONAUT_VERSION.jar"
	"$REPO/io/micronaut/micronaut-http-netty/$MICRONAUT_VERSION/micronaut-http-netty-$MICRONAUT_VERSION.jar"
	"$REPO/io/micronaut/micronaut-http-server/$MICRONAUT_VERSION/micronaut-http-server-$MICRONAUT_VERSION.jar"
	"$REPO/io/micronaut/micronaut-http-server-netty/$MICRONAUT_VERSION/micronaut-http-server-netty-$MICRONAUT_VERSION.jar"
	"$REPO/io/micronaut/micronaut-inject/$MICRONAUT_VERSION/micronaut-inject-$MICRONAUT_VERSION.jar"
	"$REPO/io/micronaut/micronaut-router/$MICRONAUT_VERSION/micronaut-router-$MICRONAUT_VERSION.jar"
	"$REPO/io/micronaut/micronaut-runtime/$MICRONAUT_VERSION/micronaut-runtime-$MICRONAUT_VERSION.jar"
	"$REPO/io/micronaut/micronaut-validation/$MICRONAUT_VERSION/micronaut-validation-$MICRONAUT_VERSION.jar"
	"$REPO/io/micronaut/micronaut-websocket/$MICRONAUT_VERSION/micronaut-websocket-$MICRONAUT_VERSION.jar"
	"$REPO/io/netty/netty-buffer/$NETTY_VERSION.Final/netty-buffer-$NETTY_VERSION.Final.jar"
	"$REPO/io/netty/netty-codec-http/$NETTY_VERSION.Final/netty-codec-http-$NETTY_VERSION.Final.jar"
	"$REPO/io/netty/netty-codec-http2/$NETTY_VERSION.Final/netty-codec-http2-$NETTY_VERSION.Final.jar"
	"$REPO/io/netty/netty-codec/$NETTY_VERSION.Final/netty-codec-$NETTY_VERSION.Final.jar"
	"$REPO/io/netty/netty-common/$NETTY_VERSION.Final/netty-common-$NETTY_VERSION.Final.jar"
	"$REPO/io/netty/netty-handler/$NETTY_VERSION.Final/netty-handler-$NETTY_VERSION.Final.jar"
	"$REPO/io/netty/netty-resolver/$NETTY_VERSION.Final/netty-resolver-$NETTY_VERSION.Final.jar"
	"$REPO/io/netty/netty-transport/$NETTY_VERSION.Final/netty-transport-$NETTY_VERSION.Final.jar"
	"$REPO/io/reactivex/rxjava2/rxjava/2.2.10/rxjava-2.2.10.jar"
	"$REPO/io/swagger/core/v3/swagger-annotations/2.1.5/swagger-annotations-2.1.5.jar"
	"$REPO/javax/annotation/javax.annotation-api/1.3.2/javax.annotation-api-1.3.2.jar"
	"$REPO/javax/inject/javax.inject/1/javax.inject-1.jar"
	"$REPO/javax/json/javax.json.api/1.1.4/json-api-1.1.4.jar"
	"$REPO/javax/validation/validation-api/2.0.1.Final/validation-api-2.0.1.Final.jar"
	"$REPO/org/apache/commons/commons-compress/1.11/commons-compress-1.11.jar"
	"$REPO/org/glassfish/javax.json/1.1/javax.json-1.1.jar"
	"$REPO/org/iq80/snappy/snappy/0.4/snappy-0.4.jar"
	"$REPO/org/reactivestreams/reactive-streams/1.0.3/reactive-streams-1.0.3.jar"
	"$REPO/org/slf4j/slf4j-api/$SLF4J_VERSION/slf4j-api-$SLF4J_VERSION.jar"
	"$REPO/org/slf4j/slf4j-simple/$SLF4J_VERSION/slf4j-simple-$SLF4J_VERSION.jar"
	"$REPO/org/tukaani/xz/1.5/xz-1.5.jar"
	"$REPO/org/yaml/snakeyaml/1.26/snakeyaml-1.26.jar"    
)

#
# Create a CLASSPATH for the java command.  It either includes the classes
# in the $TARGET directory or the $TARGET/$MAINJAR (if it exists) and the
# $EXTERNAL_CLASSPATH defined in env.sh.
#
if [ -f $PROJECTDIR/$TARGET/$MAINJAR ]
then
	CLASSPATH=$TARGET/$MAINJAR
else
	CLASSPATH=$TARGET
fi
for ((i=0; i<${#EXTERNAL_CLASSPATH[@]}; i++ ))
do
    CLASSPATH=${CLASSPATH}":""${EXTERNAL_CLASSPATH[$i]}"
done

#
# Function to print command-line options to standard output
#
print_options() {
	echo usage: $0 [-?,--help,-e,-n,-v]
	echo -e "\t-? or --help - print options to standard output and exit"
	echo -e "\t-e - echo the jdk command invocations to standard output"
	echo -e "\t-n - don't run the java commands, just print out invocations"
	echo -e "\t-v - --verbose flag for jdk commands that will accept it"
	echo
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
VERBOSE_OPTION=""
ECHO_CMD=false
EXECUTE_OPTION=true

for i in $*
do
	case $i in
		"-?")
			print_options
			exit 0
			;;
		"--help")
			print_options
			exit 0
			;;
		"-e")
			ECHO_CMD=true
			;;
		"-n")
			ECHO_CMD=true
			EXECUTE_OPTION=false
			;;
		"-v")
			VERBOSE_OPTION="--verbose"
			;;
                *)
			echo "$0: bad option '$i'"
			print_options
			exit 1
			;;
	esac
done

#
# Function to execute command specified by arguments.  If $ECHO_CMD is true
# then print the command out to standard output first.
#
exec_cmd() {
	if [ "$ECHO_CMD" = "true" ]
	then
		echo
		echo $*
	fi
        if [ "$EXECUTE_OPTION" = "true" ]
	then
		eval $*
	fi
}

#
# Check if $PROJECTDIR exists
#
if [ ! -d $PROJECTDIR ]
then
	echo Project Directory "$PROJECTDIR" does not exist. Edit PROJECTDIR variable in sh/env.sh
	exit 1
fi

#
# Check if JAVA_HOME is both set and assigned to a valid Path
#
if [ -z $JAVA_HOME ]
then
    echo "JAVA_HOME Environment Variable is not set. Set the JAVA_HOME variable to a vaild JDK runtime location in your environment or uncomment and edit the 'export JAVA_HOME=' statement at the beginning of the sh/env.sh file." 
	exit 1
elif [ ! -d $JAVA_HOME ]
then
    echo "Path for JAVA_HOME \"$JAVA_HOME\" does not exist. Set the JAVA_HOME variable to a vaild JDK runtime location in your environment or uncomment and edit the 'export JAVA_HOME=' statement at the beginning of the sh\env.sh file."
	exit 1
fi

cd $PROJECTDIR
