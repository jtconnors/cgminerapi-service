package com.jtconnors.cgminerapi.quarkus;

import static com.jtconnors.cgminerapi.CLArgs.DEBUGLOG;
import static com.jtconnors.cgminerapi.quarkus.ServerArgs.CGMINERHOST;
import static com.jtconnors.cgminerapi.quarkus.ServerArgs.CGMINERPORT;
import static com.jtconnors.cgminerapi.quarkus.ServerArgs.DEFAULT_CGMINERHOST;
import static com.jtconnors.cgminerapi.quarkus.ServerArgs.DEFAULT_CGMINERPORT;
import static com.jtconnors.cgminerapi.quarkus.ServerArgs.LOGMEMUSAGE;
import static com.jtconnors.cgminerapi.quarkus.ServerArgs.RESOURCE_NAME;

import java.lang.invoke.MethodHandles;

import io.quarkus.runtime.Quarkus;
import io.quarkus.runtime.annotations.QuarkusMain;

@QuarkusMain
public class Main {

    protected static final String PROGNAME="cgminerQuarkusHttpServer";

    public static ServerArgs serverArgs;

    static {
        serverArgs = new ServerArgs(MethodHandles.lookup().lookupClass(), 
            RESOURCE_NAME, PROGNAME);
        serverArgs.addAllowableArg(CGMINERHOST, DEFAULT_CGMINERHOST);
        serverArgs.addAllowableArg(CGMINERPORT, DEFAULT_CGMINERPORT);
        serverArgs.addAllowableArg(LOGMEMUSAGE, "false");
        serverArgs.addAllowableArg(DEBUGLOG, "false");
    }
    
    public static void main(String... args) {
        Quarkus.run(CgminerQuarkusHttpServer.class, args);
    }
   
}