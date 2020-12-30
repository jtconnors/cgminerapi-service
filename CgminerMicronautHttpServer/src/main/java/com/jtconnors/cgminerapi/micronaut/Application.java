
package com.jtconnors.cgminerapi.micronaut;

import io.micronaut.runtime.Micronaut;

import java.util.logging.Level;
import java.util.logging.Logger;
import java.lang.invoke.MethodHandles;

import static com.jtconnors.cgminerapi.micronaut.ServerArgs.*;

import com.jtconnors.cgminerapi.Util;


public class Application {

    private static final Logger LOGGER = 
    Logger.getLogger("com.jtconnors.cgminerapi");

    private static final String PROGNAME= "cgminerMicronautHttpServer";
    public static final String CONTEXT = "/cgminer";

    public static ServerArgs serverArgs;

    static {
        serverArgs = new ServerArgs(MethodHandles.lookup().lookupClass(), 
            RESOURCE_NAME, PROGNAME);
        serverArgs.addAllowableArg(CGMINERHOST, DEFAULT_CGMINERHOST);
        serverArgs.addAllowableArg(CGMINERPORT, DEFAULT_CGMINERPORT);
        serverArgs.addAllowableArg(DEBUGLOG, "false");
        serverArgs.addAllowableArg(LOGMEMUSAGE, "false");
    }

    public static void main(String[] args) {
        serverArgs.parseArgs(args);
        String cgminerHost = serverArgs.getProperty(CGMINERHOST);
        int cgminerPort = Integer.parseInt(serverArgs.getProperty(CGMINERPORT));
        boolean debugLog = Boolean.parseBoolean(serverArgs.getProperty(DEBUGLOG));
        System.err.println("cgminer at " + cgminerHost + ":" + cgminerPort);

        if (!debugLog) {
            LOGGER.setLevel(Level.OFF);
        }

        Util.checkHostValidity(cgminerHost);
        LOGGER.log(Level.INFO, "cgminerHost = {0}", cgminerHost);
        LOGGER.log(Level.INFO, "cgminerPort = {0}", cgminerPort);
        LOGGER.log(Level.INFO, "debugLog = {0}", debugLog);

        Micronaut.run(Application.class);
    }
}
