package com.jtconnors.cgminerapi.quarkus;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.UriInfo;

import com.jtconnors.cgminerapi.APIConnection;
import com.jtconnors.cgminerapi.Command;
import com.jtconnors.cgminerapi.InvalidQueryStringException;
import com.jtconnors.cgminerapi.Util;

@Path("/cgminer")
public class CgminerResource {

    private static final Logger LOGGER = 
            Logger.getLogger("com.jtconnors.cgminerapi");
    
    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String getBase(@Context UriInfo uriInfo) {
        LOGGER.log(Level.INFO, "Base URI = {0}", uriInfo.getBaseUri());
        /*
         * Strips the base URI and Path from the original
         * request leaving the remaining query string
         * 
         * Example: 
         * Original URI: "http://localhost:8001/cgminer?command=stats"
         * Query String: "?command=stats"
         */
        String queryStr = uriInfo.getRequestUri()
                .toString()
                .substring(uriInfo.getBaseUri().toString().length() +
                           uriInfo.getPath().toString().length() - 1);
        LOGGER.log(Level.INFO, "Query String = {0}", queryStr);
        String replyStr = null;
        
        try {
            if (queryStr == null || queryStr.charAt(0) != '?') {
                throw new InvalidQueryStringException(
                    "missing '?' immediately after '/cgminer' in query string");
            } else {
                // Strip the '?' from the front of the query string
                queryStr = queryStr.substring(1);
            }

            String jsonCommandStr =
                Command.parseQueryString(queryStr).toJSONString();
            LOGGER.log(Level.INFO, "JSON  command = {0}", jsonCommandStr);
            replyStr =
                new APIConnection(
                    Main.serverArgs.getProperty(ServerArgs.CGMINERHOST),
                    Integer.parseInt(
                        Main.serverArgs.getProperty(ServerArgs.CGMINERPORT)))
                    .apiCall(jsonCommandStr) + "\n";      
        } catch (InvalidQueryStringException | IOException e) {
            replyStr = Util.exceptionStackTraceToString(e);
            LOGGER.log(Level.SEVERE, "{0}", replyStr);
        } finally {
            if (Boolean.parseBoolean(Main.serverArgs.getProperty(
                    ServerArgs.LOGMEMUSAGE))) {
                Level originalLogLevel = LOGGER.getLevel();
                LOGGER.setLevel(Level.INFO);
                LOGGER.log(Level.INFO, "Memory usage = {0}", 
                    Runtime.getRuntime().totalMemory() -
                    Runtime.getRuntime().freeMemory());
                LOGGER.setLevel(originalLogLevel);
            }
        }
        return replyStr;
    }
}