
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
PROJECT=CgminerQuarkusHttpServer
VERSION=1.0-JDK11
MAINCLASS=com.jtconnors.cgminerapi.quarkus.Main
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
QUARKUS_VERSION=1.10.5
QUARKUS_SECURITY_VERSION=1.1.3
FASTER_XML_VERSION=2.11.3
NETTY_VERSION=4.1.49
SMALLRYE_VERSION=1.4.1
SMALLRYE_CONFIG_VERSION=1.9.3
VERTX_VERSION=3.9.5

EXTERNAL_CLASSPATH=(
    "$REPO/com/fasterxml/jackson/core/jackson-core/$FASTER_XML_VERSION/jackson-core-$FASTER_XML_VERSION.jar"
    "$REPO/com/ibm/async/asyncutil/0.1.0/asyncutil-0.1.0.jar"
    "$REPO/com/jtconnors/com.jtconnors.cgminerapi/4.10.0.1-JDK8/com.jtconnors.cgminerapi-4.10.0.1-JDK8.jar"
    "$REPO/commons-io/commons-io/2.8.0/commons-io-2.8.0.jar"
    "$REPO/com/sun/activation/jakarta.activation/1.2.1/jakarta.activation-1.2.1.jar"
    "$REPO/io/netty/netty-buffer/$NETTY_VERSION.Final/netty-buffer-$NETTY_VERSION.Final.jar"
    "$REPO/io/netty/netty-codec/$NETTY_VERSION.Final/netty-codec-$NETTY_VERSION.Final.jar"
    "$REPO/io/netty/netty-codec-dns/$NETTY_VERSION.Final/netty-codec-dns-$NETTY_VERSION.Final.jar"
    "$REPO/io/netty/netty-codec-http2/$NETTY_VERSION.Final/netty-codec-http2-$NETTY_VERSION.Final.jar"
    "$REPO/io/netty/netty-codec-http/$NETTY_VERSION.Final/netty-codec-http-$NETTY_VERSION.Final.jar"
    "$REPO/io/netty/netty-codec-socks/$NETTY_VERSION.Final/netty-codec-socks-$NETTY_VERSION.Final.jar"
    "$REPO/io/netty/netty-common/$NETTY_VERSION.Final/netty-common-$NETTY_VERSION.Final.jar"
    "$REPO/io/netty/netty-handler/$NETTY_VERSION.Final/netty-handler-$NETTY_VERSION.Final.jar"
    "$REPO/io/netty/netty-handler-proxy/$NETTY_VERSION.Final/netty-handler-proxy-$NETTY_VERSION.Final.jar"
    "$REPO/io/netty/netty-resolver/$NETTY_VERSION.Final/netty-resolver-$NETTY_VERSION.Final.jar"
    "$REPO/io/netty/netty-resolver-dns/$NETTY_VERSION.Final/netty-resolver-dns-$NETTY_VERSION.Final.jar"
    "$REPO/io/netty/netty-transport/$NETTY_VERSION.Final/netty-transport-$NETTY_VERSION.Final.jar"
    "$REPO/io/quarkus/arc/arc/$QUARKUS_VERSION.Final/arc-$QUARKUS_VERSION.Final.jar"
    "$REPO/io/quarkus/quarkus-arc/$QUARKUS_VERSION.Final/quarkus-arc-$QUARKUS_VERSION.Final.jar"
    "$REPO/io/quarkus/quarkus-bootstrap-runner/$QUARKUS_VERSION.Final/quarkus-bootstrap-runner-$QUARKUS_VERSION.Final.jar"
    "$REPO/io/quarkus/quarkus-core/$QUARKUS_VERSION.Final/quarkus-core-$QUARKUS_VERSION.Final.jar"
    "$REPO/io/quarkus/quarkus-development-mode-spi/$QUARKUS_VERSION.Final/quarkus-development-mode-spi-$QUARKUS_VERSION.Final.jar"
    "$REPO/io/quarkus/quarkus-ide-launcher/$QUARKUS_VERSION.Final/quarkus-ide-launcher-$QUARKUS_VERSION.Final.jar"
    "$REPO/io/quarkus/quarkus-netty/$QUARKUS_VERSION.Final/quarkus-netty-$QUARKUS_VERSION.Final.jar"
    "$REPO/io/quarkus/quarkus-resteasy-common/$QUARKUS_VERSION.Final/quarkus-resteasy-common-$QUARKUS_VERSION.Final.jar"
    "$REPO/io/quarkus/quarkus-resteasy/$QUARKUS_VERSION.Final/quarkus-resteasy-$QUARKUS_VERSION.Final.jar"
    "$REPO/io/quarkus/quarkus-resteasy-server-common/$QUARKUS_VERSION.Final/quarkus-resteasy-server-common-$QUARKUS_VERSION.Final.jar"
    "$REPO/io/quarkus/quarkus-security-runtime-spi/$QUARKUS_VERSION.Final/quarkus-security-runtime-spi-$QUARKUS_VERSION.Final.jar"
    "$REPO/io/quarkus/quarkus-vertx-core/$QUARKUS_VERSION.Final/quarkus-vertx-core-$QUARKUS_VERSION.Final.jar"
    "$REPO/io/quarkus/quarkus-vertx-http/$QUARKUS_VERSION.Final/quarkus-vertx-http-$QUARKUS_VERSION.Final.jar"
    "$REPO/io/quarkus/security/quarkus-security/$QUARKUS_SECURITY_VERSION.Final/quarkus-security-$QUARKUS_SECURITY_VERSION.Final.jar"
    "$REPO/io/smallrye/common/smallrye-common-annotation/$SMALLRYE_VERSION/smallrye-common-annotation-$SMALLRYE_VERSION.jar"
    "$REPO/io/smallrye/common/smallrye-common-classloader/$SMALLRYE_VERSION/smallrye-common-classloader-$SMALLRYE_VERSION.jar"
    "$REPO/io/smallrye/common/smallrye-common-constraint/$SMALLRYE_VERSION/smallrye-common-constraint-$SMALLRYE_VERSION.jar"
    "$REPO/io/smallrye/common/smallrye-common-expression/$SMALLRYE_VERSION/smallrye-common-expression-$SMALLRYE_VERSION.jar"
    "$REPO/io/smallrye/common/smallrye-common-function/$SMALLRYE_VERSION/smallrye-common-function-$SMALLRYE_VERSION.jar"
    "$REPO/io/smallrye/common/smallrye-common-io/$SMALLRYE_VERSION/smallrye-common-io-$SMALLRYE_VERSION.jar"
    "$REPO/io/smallrye/config/smallrye-config/$SMALLRYE_CONFIG_VERSION/smallrye-config-$SMALLRYE_CONFIG_VERSION.jar"
    "$REPO/io/smallrye/config/smallrye-config-common/$SMALLRYE_CONFIG_VERSION/smallrye-config-common-$SMALLRYE_CONFIG_VERSION.jar"
    "$REPO/io/smallrye/reactive/mutiny/0.11.0/mutiny-0.11.0.jar"
    "$REPO/io/vertx/vertx-auth-common/$VERTX_VERSION/vertx-auth-common-$VERTX_VERSION.jar"
    "$REPO/io/vertx/vertx-bridge-common/$VERTX_VERSION/vertx-bridge-common-$VERTX_VERSION.jar"
    "$REPO/io/vertx/vertx-core/$VERTX_VERSION/vertx-core-$VERTX_VERSION.jar"
    "$REPO/io/vertx/vertx-web/$VERTX_VERSION/vertx-web-$VERTX_VERSION.jar"
    "$REPO/io/vertx/vertx-web-common/$VERTX_VERSION/vertx-web-common-$VERTX_VERSION.jar"
    "$REPO/jakarta/annotation/jakarta.annotation-api/1.3.5/jakarta.annotation-api-1.3.5.jar"
    "$REPO/jakarta/el/jakarta.el-api/3.0.3/jakarta.el-api-3.0.3.jar"
    "$REPO/jakarta/enterprise/jakarta.enterprise.cdi-api/2.0.2/jakarta.enterprise.cdi-api-2.0.2.jar"
    "$REPO/jakarta/inject/jakarta.inject-api/1.0/jakarta.inject-api-1.0.jar"
    "$REPO/jakarta/interceptor/jakarta.interceptor-api/1.2.5/jakarta.interceptor-api-1.2.5.jar"
    "$REPO/jakarta/transaction/jakarta.transaction-api/1.3.3/jakarta.transaction-api-1.3.3.jar"
    "$REPO/jakarta/validation/jakarta.validation-api/2.0.2/jakarta.validation-api-2.0.2.jar"
    "$REPO/javax/json/javax.json-api/1.1.4/javax.json-api-1.1.4.jar"
    "$REPO/org/apache/commons/commons-compress/1.20/commons-compress-1.20.jar"
    "$REPO/org/eclipse/microprofile/config/microprofile-config-api/1.4/microprofile-config-api-1.4.jar"
    "$REPO/org/eclipse/microprofile/context-propagation/microprofile-context-propagation-api/1.0.1/microprofile-context-propagation-api-1.0.1.jar"
    "$REPO/org/glassfish/javax.json/1.1/javax.json-1.1.jar"
    "$REPO/org/graalvm/compiler/compiler/19.2.1/compiler-19.2.1.jar"
    "$REPO/org/graalvm/sdk/graal-sdk/20.2.0/graal-sdk-20.2.0.jar"
    "$REPO/org/iq80/snappy/snappy/0.4/snappy-0.4.jar"
    "$REPO/org/jboss/logging/jboss-logging/3.4.1.Final/jboss-logging-3.4.1.Final.jar"
    "$REPO/org/jboss/logging/jboss-logging-annotations/2.1.0.Final/jboss-logging-annotations-2.1.0.Final.jar"
    "$REPO/org/jboss/logmanager/jboss-logmanager-embedded/1.0.6/jboss-logmanager-embedded-1.0.6.jar"
    "$REPO/org/jboss/resteasy/resteasy-core/4.5.8.Final/resteasy-core-4.5.8.Final.jar"
    "$REPO/org/jboss/resteasy/resteasy-core-spi/4.5.8.Final/resteasy-core-spi-4.5.8.Final.jar"
    "$REPO/org/jboss/slf4j/slf4j-jboss-logmanager/1.1.0.Final/slf4j-jboss-logmanager-1.1.0.Final.jar"
    "$REPO/org/jboss/spec/javax/ws/rs/jboss-jaxrs-api_2.1_spec/2.0.1.Final/jboss-jaxrs-api_2.1_spec-2.0.1.Final.jar"
    "$REPO/org/jboss/spec/javax/xml/bind/jboss-jaxb-api_2.3_spec/2.0.0.Final/jboss-jaxb-api_2.3_spec-2.0.0.Final.jar"
    "$REPO/org/jboss/threads/jboss-threads/3.1.1.Final/jboss-threads-3.1.1.Final.jar"
    "$REPO/org/ow2/asm/asm/9.0/asm-9.0.jar"
    "$REPO/org/reactivestreams/reactive-streams/1.0.3/reactive-streams-1.0.3.jar"
    "$REPO/org/slf4j/slf4j-api/1.7.30/slf4j-api-1.7.30.jar"
    "$REPO/org/tukaani/xz/1.5/xz-1.5.jar"
    "$REPO/org/wildfly/common/wildfly-common/1.5.4.Final-format-001/wildfly-common-1.5.4.Final-format-001.jar"
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
	CLASSPATH=$TARGET/classes
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
