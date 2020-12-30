/*
 * Copyright (c) 2020, Jim Connors
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above
 *     copyright notice, this list of conditions and the following
 *     disclaimer in the documentation and/or other materials provided
 *     with the distribution.
 *   * Neither the name of this project nor the names of its
 *     contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package com.jtconnors.cgminerapi.netty;

import com.jtconnors.cgminerapi.CLArgs;

/**
 * This class is an implementation of the {@code CLArgs} class, enabling
 * options that can be set in a properties file and optionally overriden
 * by command-line.
 * <br>
 * To see how it is used elsewhere in a main program see {@link Samples}.
 */
public class ServerArgs extends CLArgs {

    public static final String RESOURCE_NAME = "/cgminerapi.properties";

    /* DASH, HELP and DEBUGLOG already defined in superclass */
    public static final String CGMINERHOST = "cgminerHost";
    public static final String CGMINERPORT = "cgminerPort";
    public static final String HTTPPORT = "httpPort";
    public static final String HTTPSPORT = "httpsPort";
    public static final String SSL = "ssl";
    public static final String LOGMEMUSAGE = "logMemUsage";

    /* DASH_HELP and DASH_DEBUG_LOG already defined in superclass */
    public static final String DASH_CGMINERHOST = "-" + CGMINERHOST;
    public static final String DASH_CGMINERPORT = "-" + CGMINERPORT;
    public static final String DASH_HTTPPORT = "-" + HTTPPORT;
    public static final String DASH_HTTPSPORT = "-" + HTTPSPORT;
    public static final String DASH_SSL = "-" + SSL;
    public static final String DASH_LOGMEMUSAGE = "-" + LOGMEMUSAGE;

    public static final String DEFAULT_CGMINERHOST = "jtconnors.com";
    public static final String DEFAULT_CGMINERPORT = "4028";
    public static final String DEFAULT_HTTPPORT = "8000";
    public static final String DEFAULT_HTTPSPORT = "8001";
    public static final String DEFAULT_SSL = "false";
    public static final String DEFAULT_LOGMEMUSAGE = "false";

    /*
     * Associate a printable help string with each Command-line option
     */
    static {
        /*
         * helpStrMap defined and instantiated in superclass.  Help strings for
         * DASH_HELP and DASH_DEBUGLOG put in the helpStrMap by superclass.
         */
        helpStrMap.put(DASH_CGMINERHOST,
            "  -cgminerHost:HOSTNAME (default " + DEFAULT_CGMINERHOST + ")\n" +
            "\tSpecify hostname (or IP Address) of socket");
        helpStrMap.put(DASH_CGMINERPORT,
            "  -cgminerPort:PORT (default " + DEFAULT_CGMINERPORT + ")\n" +
            "\tSpecify port for socket connection to cgminer");
        helpStrMap.put(DASH_HTTPPORT,
            "  -httpPort:PORT (default " + DEFAULT_HTTPPORT + ")\n" +
            "\tSpecify http server port");
        helpStrMap.put(DASH_HTTPSPORT,
            "  -httpsPort:PORT (default " + DEFAULT_HTTPSPORT +")\n" +
            "\tSpecify HTTPS server port");
        helpStrMap.put(DASH_SSL,
            "  -ssl:{true|false} (default " + DEFAULT_SSL + ")\n" +
            "\tEnable|Disable SSL/HTTPS");
        helpStrMap.put(DASH_LOGMEMUSAGE,
            "  -logMemUsage:{true|false} (default "+DEFAULT_LOGMEMUSAGE+ ")\n" +
            "\tLog memory usage after each http request");
    }

    /**
     * Initializes a newly created {@code ServerArgs} instance.  {@code CLArgs}
     * instances include a {@code Properties} object where individual properties
     * are stored in the following format: {@code progName.key=value}.
     * Initial propery values are read from a resource file that is bundled
     * relative to this application's project or jar file.
     * 
     * @param clazz {@code Class} instance of caller of this constructor
     * @param resourceName the name of the {@code properties} resource
     * @param progName Progam name used by {@code properties} to store and
     * retrieve key-value pairs. Individual properties will be prefaced by the
     * propertyName as in {@code programName.property=value}.
     */
    public ServerArgs(Class<?> clazz, String resourceName, String progName) {
        super(clazz, RESOURCE_NAME, progName);
    }


    /**
     * Process the Command-line arguments and set {@code CLArgs} instance
     * properties accordingly
     * @param args the list cf command-line arguments
     */
    @Override
    public void parseArgs(String[] args) {
        super.parseArgs(args);
        if (isOnCmdLine(DASH_CGMINERHOST, args)) {
            setProperty(CGMINERHOST, getArgValue(DASH_CGMINERHOST, args));
        }
        if (isOnCmdLine(DASH_CGMINERPORT, args)) {
            setProperty(CGMINERPORT, getArgValue(DASH_CGMINERPORT, args));
        }
        if (isOnCmdLine(DASH_HTTPPORT, args)) {
            setProperty(HTTPPORT, getArgValue(DASH_HTTPPORT, args));
        }
        if (isOnCmdLine(DASH_HTTPSPORT, args)) {
            setProperty(HTTPSPORT, getArgValue(DASH_HTTPSPORT, args));
        }
        if (isOnCmdLine(DASH_SSL, args)) {
            setProperty(SSL, getArgValue(DASH_SSL, args));    
        }
        if (isOnCmdLine(DASH_LOGMEMUSAGE, args)) {
            setProperty(LOGMEMUSAGE, getArgValue(DASH_LOGMEMUSAGE, args));
        }
    }    
}