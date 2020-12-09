# CgminerProxy
Utilizing the Netty framework ([https://netty.io](https://nett.io)), ```CgminerProxy``` is a simple proxy server server that acts as a gateway between an internal *cgminer* instance and a larger outside network.  It effectively allows external entities to perform cgminer API requests from the outside on an internal cgminer instance, as if it had direct access to that instance.  ```CgminerProxy``` is reposoble for routing the socket communication to/from the internal cgminer instance.

Of note, the following maven goals can be executed to clean and build the software:

   - ```mvn clean```
   - ```mvn dependency:copy-dependencies``` - to pull down the maven dependencies
   - ```mvn package``` - to create the ```target/CgminerProxy-1.0-JDK8.jar``` and a GraalVM-compiled native image called ```target/CgminerProxy```
   - ```mvn -f pom-sans-native-image.xml package```  can be executed to build without creating a native-image binary

# Running the Proxy
The source for this server can be found in the [src/main/java/com/jtconnors/cgminerapi/netty/CgminerProxy.java](src/main/java/com/jtconnors/cgminerapi/netty/CgminerProxy.java) source file.

The proxy sever accepts optional command-line arguments which may need to be modified:
 
- ```-localPort:PORT```  - (default 4028) 
Specify the external port number the proxy will utilize.
- ```-remoteHost:HOSTNAME``` - (default: 49er)
Specify the remote hostname (or IP Address) of the running cgminer instance.  This will have to be modified to match the hostname of your cgminer instance.  
- ```-remotePort:PORT```  - (default 8000) 
Specify the port number used by the internal cgminer instance.  Chances are this will remain unchanged.

There are at least three different ways to start up this application

## 1. Starting from Maven
To start the HTTP server from maven, issue the following command:  
- ```mvn exec:java``` 
  
**Before doing so, you'll most liekly want to modify the aforementioned ```remoteHost``` argument**.  The most straightforward way of doing this is by editing the [pom.xml](pom.xml) file and looking for a property called ```cgminerHost```:
```xml
<properties>
  ...
  <mainClass>com.jtconnors.cgminerapi.netty.CgminerProxy</mainClass>
  <localPort>4028</localPort>
  <remoteHost>49er</remoteHost>
  <remotePort>4028</remotePort>
  ...
</properties>
```

## 2. Starting via script
The following scripts are provided as part of this project which can be run from a terminal in the project's main directory.  Command-line arguments associated with ```CgminerProxy``` can be modified inside these scripts, if necessary:
- [sh/run-proxy.sh](sh/run-proxy.sh) - for Linux and MacOS
- [ps1\run-proxy.ps1](ps1/run-proxy.ps1) - for Windows

### Notes
- The scripts referred to above have a few available command-line options related to how they execute. To print out the options, add ```-?``` or ```--help``` as an argument to any script.
- The scripts share common properties that can be found in [sh/env.sh](sh/env.sh) or [ps1\env.ps1](ps1/env.ps1). These may need to be slightly modified to match your specific environment.
- A sample [Microsoft.PowerShell_profile.ps1](Microsoft.PowerShell_profile.ps1) file has been included to help configure a default Powershell execution environment. A similar file can be generated specific to environments appropriate for running the ```bash(1)``` shell with a ```.bash_login``` or ```.bash_profile``` file.

## 3. Starting the GraalVM native-image
Once ```mvn package``` is executed, a GraalVM-compiled native image is created called ```target/CgminerProxy```.  It can be run from a terminal (from the main project directory) as follows:
- ```$ target/CgminerProxy [optional command-line arguments]```

or with the provided script:
- [sh/run-proxy-native-image.sh](sh/run-proxy-native-image.sh)

*Note: As of this document's creation, only the Linux and MacOS native-images are functional.  Use the Windows version (if it builds) at your own risk.*

# See also:

- cgminer project on GitHub - https://github.com/ckolivas/cgminer
- com.jtconnors.cgminerapi project on GitHub - https://gitbub.com/jtconnors/com.jtconnors.cgminerapi
