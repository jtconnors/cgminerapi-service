# cgminerapi-service
*Various implementations of a Java HTTP-based cgminer service*  
This project aims to survey some of the Java frameworks available for microservices development and deployment.  By
duplicating the same service, referred to as the *cgminerapi-service*, on top of the selected frameworks,
it attempts to create both traditional bytecode and [GraalVM](https://www.graalvm.org/) native-image versions
of the service for each framework in order to compare and contrast memory consumption and startup
time.
## What is the cgminerapi-service?
```cgminer``` is open-source cryptocurrency miner software that is available for platforms (Windows, Linux, MacOS ...)
and has support for many of the popular GPU and mining-specific ASICs.  As part of its operation,
a ```cgminer``` instance can be configured to expose a
[socket based API](https://github.com/ckolivas/cgminer/blob/v4.10.0/API-README) in order to
access and manage that instance.  Generically speaking, the *cgminerapi-service* Is an HTTP-based service that accepts
cgminer API requests in the form of HTTP query strings that it uses to communicate with a cgminer instance.
After successful completion of HTTP API request, the service retuns a response in JSON format.
