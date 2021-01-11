package com.jtconnors.cgminerapi.quarkus;

import java.lang.management.ManagementFactory;
import java.util.logging.Level;
import java.util.logging.Logger;

import io.quarkus.runtime.Quarkus;
import io.quarkus.runtime.QuarkusApplication;

import static com.jtconnors.cgminerapi.quarkus.ServerArgs.*;
import static com.jtconnors.cgminerapi.quarkus.Main.serverArgs;

import com.jtconnors.cgminerapi.Util;

public class CgminerQuarkusHttpServer implements QuarkusApplication {

    private static final Logger LOGGER = 
            Logger.getLogger("com.jtconnors.cgminerapi");

    @Override
    public int run(String... args) {
        Main.serverArgs.parseArgs(args);
        /*
         * Print out elasped time it took to get to here.  For argument's sake
         * we'll call this the startup time.
         */
        System.err.println("Startup time = " +
                (System.currentTimeMillis() -
                ManagementFactory.getRuntimeMXBean().getStartTime()) + "ms");

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
          
        Quarkus.waitForExit();
        return 0;
    }

}