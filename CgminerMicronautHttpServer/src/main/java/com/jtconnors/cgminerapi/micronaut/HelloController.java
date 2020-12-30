/*
 * Copyright 2017 original authors
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License. 
 */
package com.jtconnors.cgminerapi.micronaut;

import io.micronaut.http.MediaType;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.jtconnors.cgminerapi.APIConnection;
import com.jtconnors.cgminerapi.Command;
import com.jtconnors.cgminerapi.InvalidQueryStringException;
import com.jtconnors.cgminerapi.Util;

import io.micronaut.http.HttpRequest;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.Produces;

@Controller("/cgminer")
public class HelloController {

    private static final Logger LOGGER = 
            Logger.getLogger("com.jtconnors.cgminerapi");

    @Get()
    @Produces(MediaType.TEXT_PLAIN)
    public String index(HttpRequest<?> httpRequest) {
        String replyStr = null;
        String queryStr = httpRequest.getUri().toString();
        LOGGER.log(Level.INFO, "URI string = {0}", queryStr);
        // Get rid of "/cgminer context in query string"
        queryStr = queryStr.substring(8);
        
        try {
            if (queryStr == null || queryStr.charAt(0) != '?') {
                throw new InvalidQueryStringException(
                    "missing '?' immediately after '/cgminer' in query string");
            } else {
                // Strip the '?' from the front of the query string
                queryStr = queryStr.substring(1);
            }

            LOGGER.log(Level.INFO, "http query string = {0}", queryStr);
            String jsonCommandStr =
                Command.parseQueryString(queryStr).toJSONString();
            LOGGER.log(Level.INFO, "JSON  command = {0}", jsonCommandStr);
            replyStr =
                new APIConnection(
                    Application.cgArgs.getProperty(CgArgs.CGMINERHOST),
                    Integer.parseInt(
                        Application.cgArgs.getProperty(CgArgs.CGMINERPORT)))
                    .apiCall(jsonCommandStr) + "\n";      
        } catch (InvalidQueryStringException | IOException e) {
            replyStr = Util.exceptionStackTraceToString(e);
            LOGGER.log(Level.SEVERE, "{0}", replyStr);
        } finally {
            if (Boolean.parseBoolean(Application.cgArgs.getProperty(
                    CgArgs.LOGMEMUSAGE))) {
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
