# cgminerapi-service
*Various implementations of a Java HTTP-based cgminer service*  
This project aims to survey some of the Java frameworks available for microservices development and deployment.  By
duplicating the same service, referred to as the *cgminerapi-service*, on top of the selected frameworks,
it attempts to create both traditional bytecode and [GraalVM](https://www.graalvm.org/) native-image versions
of the service for each framework in order to compare and contrast memory consumption and startup
time.
## What is the cgminerapi-service?
*cgminer* is open-source cryptocurrency miner software that is available for most platforms (Windows, Linux, MacOS ...)
and has support for many of the popular GPU and mining-specific ASICs.  As part of its operation,
a cgminer instance can be configured to expose a
[socket based API](https://github.com/ckolivas/cgminer/blob/v4.10.0/API-README) in order to
access and manage that instance.  Generically speaking, the *cgminerapi-service* Is an HTTP-based service that accepts
cgminer API requests in the form of HTTP query strings that it uses to communicate with a cgminer instance.
After successful completion of an HTTP API request, the service retuns a response in JSON format.
## The Framework Implementations
This project is organized into a set of subdirectories -- each a separate implementation of the *cgminerapi-service*
using a different framework. Each subdirectory is its
own distinct [Apache Maven](https://maven.apache.org/) project and contains its own ```pom.xml``` file.  The projects include
- [CgminerHttpServer](CgminerHttpServer) - An implementation using the JDK's simple high-level [com.sun.net.httpserver](https://docs.oracle.com/javase/8/docs/jre/api/net/httpserver/spec/com/sun/net/httpserver/package-summary.html) API.
- [CgminerNettyHttpServer](CgminerNettyHttpServer) - An implementation using the client-server [Netty](https://netty.io) framework.
