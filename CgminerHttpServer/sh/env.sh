
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
PROJECT=CgminerHttpServer
VERSION=1.0-JDK8
MAINCLASS=com.jtconnors.cgminerapi.http.CgminerHttpServer
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
EXTERNAL_CLASSPATH=(
    "$REPO/javax/json/javax.json.api/1.1.4/json-api-1.1.4.jar"
    "$REPO/org/glassfish/javax.json/1.1/javax.json-1.1.jar"
    "$REPO/com/jtconnors/com.jtconnors.cgminerapi/4.10.0.1-JDK8/com.jtconnors.cgminerapi-4.10.0.1-JDK8.jar"
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
