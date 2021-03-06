package com.jtconnors.cgminerapi.http;

import com.jtconnors.cgminerapi.APIConnection;
import com.jtconnors.cgminerapi.Command;
import com.jtconnors.cgminerapi.InvalidQueryStringException;
import com.jtconnors.cgminerapi.Util;
import com.sun.net.httpserver.HttpContext;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.io.OutputStream;
import java.lang.invoke.MethodHandles;
import java.lang.management.ManagementFactory;
import java.net.InetSocketAddress;
import java.util.logging.Level;
import java.util.logging.Logger;
import static com.jtconnors.cgminerapi.http.serverArgs.*;

public class CgminerHttpServer {

    private static final Logger LOGGER = 
            Logger.getLogger("com.jtconnors.cgminerapi");

    private static final String PROGNAME= "cgminerHttpServer";
    public static final String CONTEXT = "/cgminer";

    private static serverArgs serverArgs;

    static {
        serverArgs = new serverArgs(MethodHandles.lookup().lookupClass(), 
            RESOURCE_NAME, PROGNAME);
        serverArgs.addAllowableArg(CGMINERHOST, DEFAULT_CGMINERHOST);
        serverArgs.addAllowableArg(CGMINERPORT, DEFAULT_CGMINERPORT);
        serverArgs.addAllowableArg(HTTPPORT, DEFAULT_HTTPPORT);
        serverArgs.addAllowableArg(LOGMEMUSAGE, "false");
        serverArgs.addAllowableArg(DEBUGLOG, "false");
    }

    private static String cgminerHost;
    private static int cgminerPort;
    private static int httpPort;

    private static void handleRequest(HttpExchange exchange) throws IOException{
        String queryStr = exchange.getRequestURI().getQuery();
        LOGGER.log(Level.INFO, "http query string = {0}", queryStr);
        try (OutputStream os = exchange.getResponseBody()) {
            try {
                String jsonCommandStr =
                    Command.parseQueryString(queryStr).toJSONString();
                LOGGER.log(Level.INFO, "JSON  command = {0}", jsonCommandStr);
                String replyStr =
                    new APIConnection(cgminerHost, cgminerPort)
                        .apiCall(jsonCommandStr);      
                exchange.sendResponseHeaders(200, replyStr.length());
                os.write(replyStr.getBytes());
            } catch (InvalidQueryStringException e) {
                String errMsg = Util.exceptionStackTraceToString(e);
                LOGGER.log(Level.SEVERE, "{0}", errMsg);
                exchange.sendResponseHeaders(400, errMsg.length());
                os.write(errMsg.getBytes());
            } finally {
                if (Boolean.parseBoolean(serverArgs.getProperty(LOGMEMUSAGE))) {
                    Level originalLogLevel = LOGGER.getLevel();
                    LOGGER.setLevel(Level.INFO);
                    LOGGER.log(Level.INFO, "Memory usage = {0}", 
                        Runtime.getRuntime().totalMemory() -
                        Runtime.getRuntime().freeMemory());
                    LOGGER.setLevel(originalLogLevel);
                }
            }
        }
    }

    public static void main(String[] args) throws Exception {
        serverArgs.parseArgs(args);
        cgminerHost = serverArgs.getProperty(CGMINERHOST);
        cgminerPort = Integer.parseInt(serverArgs.getProperty(CGMINERPORT));
        httpPort = Integer.parseInt(serverArgs.getProperty(HTTPPORT));
        System.err.println("starting at http://localhost:" + httpPort);
        System.err.println("cgminer at " + cgminerHost + ":" + cgminerPort);

        if (!Boolean.parseBoolean(serverArgs.getProperty(DEBUGLOG))) {
            LOGGER.setLevel(Level.OFF);
        }

        Util.checkHostValidity(cgminerHost);
        LOGGER.log(Level.INFO, "cgminerHost = {0}", cgminerHost);
        LOGGER.log(Level.INFO, "cgminerPort = {0}", cgminerPort);
        LOGGER.log(Level.INFO, "httpPort = {0}", httpPort);
        HttpServer server = HttpServer.create(
            new InetSocketAddress(httpPort), 0);
        HttpContext context = server.createContext(CONTEXT);
        context.setHandler(CgminerHttpServer::handleRequest);

        server.start();
        /*
         * Print out elasped time it took to get to here.  For argument's sake
         * we'll call this the startup time.
         */
        System.err.println("Startup time = " +
            (System.currentTimeMillis() -
            ManagementFactory.getRuntimeMXBean().getStartTime()) + "ms");
    }
    
}
