# cgminerapi-service
*Various implementations of a Java HTTP-based cgminer service*  
This project aims to survey some of the Java frameworks available for microservices development and deployment.  By
duplicating the same service (called the *cgminerapi-service*) on top of the selected frameworks,
it attempts to create both traditional bytecode and [GraalVM](https://www.graalvm.org/) native-image versions
in order to compare and contrast memory consumption and startup times.
## What is the cgminerapi-service?
*cgminer* is open-source cryptocurrency miner software that is available for most platforms (Windows, Linux, MacOS ...)
and has support for many of the popular GPU and mining-specific ASICs.  As part of its operation,
a cgminer instance can be configured to expose a
[socket based API](https://github.com/ckolivas/cgminer/blob/v4.10.0/API-README) in order to
access and manage that instance.  The *cgminerapi-service* Is an HTTP-based service that accepts
cgminer API requests in the form of HTTP query strings.  It converts the HTTP request into a cgminer socket API call,
commuinicates with the cgminer instance, and after successful completion, retuns a response in JSON format.  To assist
in the HTTP Query and JSON handling it enlists the services of the
[com.jtconnors.cgminerapi](https://github.com/jtconnors/com.jtconnors.cgminerapi) package, available as an artifact in
the [Maven Central Repositry](https://mvnrepository.com/artifact/com.jtconnors/com.jtconnors.cgminerapi).
## The Framework Implementations
This project is organized into a set of subdirectories -- each a separate implementation of the *cgminerapi-service*
using a different framework. Each subdirectory is its
own distinct [Apache Maven](https://maven.apache.org/) project and contains its own ```pom.xml``` file.  The projects include
- [CgminerHttpServer](CgminerHttpServer) - An implementation using the JDK's simple high-level [com.sun.net.httpserver](https://docs.oracle.com/javase/8/docs/jre/api/net/httpserver/spec/com/sun/net/httpserver/package-summary.html) API.
- [CgminerNettyHttpServer](CgminerNettyHttpServer) - An implementation using the client-server [Netty](https://netty.io) framework.
- [CgminerMicronautHttpServer](CgminerMicronautHttpServer) - An implementation using the [Micronaut](https://micronaut.io/) framework.
[CgminerQuarkusHttpServer](CgminerQuarkusHttpServer) - An implementation using the [Quarkus](https://quarkus.io/) framework.
## CgminerProxy
One additional project, called [CgminerProxy](CgminerProxy), is provided that is not a *cgminerapi-service* implementation.
Rather it is a proxy service that allows internal cgminer instances to be exposed to a larger audience.
The various *cgminerapi-service* implementations contained within this project use ```jtconnors.com``` as the default cgminer instance
(you can change the cgminer instance via command-line or properties file). ```jtconnors.com```
(when fully operating - no guarantees) does not contain a cgminer instance.  Instead, it runs ```CgminerProxy```
and forwards requests/replies from an otherwise inaccessible internal instance running real, albeit humble, bitcoin mining equipment.
# See Also:
- cgminer project on GitHub - https://github.com/ckolivas/cgminer
- com.jtconnors.cgminerapi project on GitHub - https://gitbub.com/jtconnors/com.jtconnors.cgminerapi
