# CgminerQuarkusHttpServer
Utilizing the Quarkus framework ([https://quarkus.io](https://quarkus.io)), ```CgminerQuarkusHttpServer``` is a simple HTTP server instance that can handle *cgminer* API requests via query strings over HTTP.

A Java version of the cgminer RPC API version 4.10.0 (https://github.com/jtconnors/com.jtconnors.cgminerapi), referenced by https://github.com/ckolivas/cgminer/blob/v4.10.0/API-README is used as part of this project.  It enables Java applications and frameworks to access running ```cgminer``` instances.  The API has facilities for both querying and manipulating mining (e.g bitcoin, etherium ...) activity.

Of note, the following maven goals can be executed to clean and build the software:

   - ```mvn clean```
   - ```mvn dependency:copy-dependencies``` - to pull down the maven dependencies
   - ```mvn package``` - to create the ```target/CgminerQuarkusHttpServer-1.0-JDK11.jar``` and ```target/CgminerQuarkusHttpServer-1.0-JDK11-runner.jar``` files.
   - ```mvn package -Dquarkus.package.type=native``` to create a  GraalVM-compiled native image called ```CgminerQuarkusHttpServer-1.0-JDK11-runner```

# Running the Http Server
The source for the program can be found in the [src/main/java/com/jtconnors/cgminerapi/quarkus/](src/main/java/com/jtconnors/cgminerapi/quarkus/) directory.

The program accepts optional command-line arguments which may need to be modified:

- ```-cgminerHost:HOSTNAME``` - (default: jtconnors.com)
Specify hostname (or IP Address) of the running cgminer instance.  This will have to be modified to match the hostname of your cgminer instance.
- ```-cgminerPort:PORT_NUMBER```  - (default 4028) 
Specify the port number used to communicate with a running cgminer instance.  Chances are this will remain unchanged.  
- *Note: There is no command line option to change the default port number for this implementation.*  Quarkus does allow other mechanisms to do so, namely by editing the [resources/application.properties](src/main/resources/application.properties) file.


There are at least three different ways to start up this application

## 1. Starting from Maven
To start the HTTP server from maven, issue the following command:  
- ```mvn exec:java```

**Before doing so, you'll most liekly want to modify the aforementioned ```cgminerHost``` argument**.  The most straightforward way of doing this is by editing the [pom.xml](pom.xml) file and looking for a property called ```cgminerHost```:
```xml
<properties>
  ...
  <mainClass>com.jtconnors.cgminerapi.quarkus.Main</mainClass>
  <cgminerHost>jtconnors.com</cgminerHost>
  <cgminerPort>4028</cgminerPort>
  <logMemUsage>true</logMemUsage>
  ...
</properties>
```

## 2. Starting via script
The following scripts are provided as part of this project which can be run from a terminal in the project's main directory.  Command-line arguments associated with ```CgminerQuarkusHttpServer``` can be modified inside these scripts, if necessary:
- [sh/run-quarkus-httpserver-without-mvn.sh](sh/run-quarkus-httpserver-without-mvn.sh) - for Linux and MacOS, run the program outside of the ```maven``` framework
- [ps1\run-quarkus-httpserver-without-mvn.ps1](ps1/run-quarkus-httpserver-without-mvn.ps1) - for Windows, run the program outside of the ```maven``` framework
- [sh/run-quarkus-httpserver-mvn.sh](sh/run-quarkus-httpserver-mvn.sh) - for Linux and MacOS, run the program within the ```maven``` framework
- [ps1\run-quarkus-httpserver-mvn.ps1](ps1/run-quarkus-httpserver-mvn.ps1) - for Windows, run the program within the ```maven``` framework

### Notes
- The scripts referred to above have a few available command-line options related to how they execute. To print out the options, add ```-?``` or ```--help``` as an argument to any script.
- The scripts share common properties that can be found in [sh/env.sh](sh/env.sh) or [ps1\env.ps1](ps1/env.ps1). These may need to be slightly modified to match your specific environment.
- A sample [Microsoft.PowerShell_profile.ps1](sample-Microsoft.PowerShell_profile.ps1) file has been included to help configure a default Powershell execution environment. A similar file can be generated specific to environments appropriate for running the ```bash(1)``` shell with a ```.bash_login``` or ```.bash_profile``` file.

## 3. Starting the GraalVM native-image
Once ```mvn package``` is executed, a GraalVM-compiled native image is created called ```target/CgminerQuarkusHttpServer-1.0-JDK11-runner```.  It can be run from a terminal (from the main project directory) as follows:
- ```$ target/CgminerQuarkusHttpServer-1.0-JDK11-runner [optional command-line arguments]```

or with the provided script:
- [sh/run-quarkus-httpserver-native-image.sh](sh/run-quarkus-httpserver-native-image.sh)

*Note: As of this document's creation, only the Linux and MacOS native-images are functional.  Use the Windows version (if it builds) at your own risk.*

# Sample HTTP queries

Assuming the HTTP Server is running on ```localhost``` and defaults to port ```8001```, the following commands can be executed from a standard terminal on ```localhost```:

- ```curl http://localhost:8001/cgminer?command=summary```   
to recieve a summary status of the cgminer instance
- ```curl http://localhost:8001/cgminer?command=devs```  
to recieve the details of each available PGA and ASIC managed by the cgminer instance
- ```curl "http://localhost:8001/cgminer?command=ascenable;parameter=0"```
to enable ASIC number 0 managed by the cgminer instance

# See also:

- cgminer project on GitHub - https://github.com/ckolivas/cgminer
- com.jtconnors.cgminerapi project on GitHub - https://gitbub.com/jtconnors/com.jtconnors.cgminerapi
