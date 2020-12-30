/*
 * Code lifted and modified from the Netty Project as indicated by license
 * below.
 *
 * Copyright 2012 The Netty Project
 *
 * The Netty Project licenses this file to you under the Apache License,
 * version 2.0 (the "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at:
 *
 *   https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 */

package com.jtconnors.cgminerapi.netty;

import java.lang.invoke.MethodHandles;
import java.lang.management.ManagementFactory;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.jtconnors.cgminerapi.Util;

import static com.jtconnors.cgminerapi.netty.ServerArgs.*;

import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.Channel;
import io.netty.channel.ChannelOption;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.handler.logging.LogLevel;
import io.netty.handler.logging.LoggingHandler;
//import io.netty.handler.ssl.SslContext;
//import io.netty.handler.ssl.SslContextBuilder;
//import io.netty.handler.ssl.util.SelfSignedCertificate;

/**
 * An HTTP interface into a {@code cgminer} - virtual currency mining software
 */
public final class CgminerNettyHttpServer {

    private static final Logger LOGGER = 
            Logger.getLogger("com.jtconnors.cgminerapi");

    private static final String PROGNAME= "cgminerNettyHttpServer";
    public static final String CONTEXT = "/cgminer";

    private static ServerArgs serverArgs;

    static {
        serverArgs = new ServerArgs(MethodHandles.lookup().lookupClass(),
            RESOURCE_NAME, PROGNAME);
        serverArgs.addAllowableArg(CGMINERHOST, "jtconnors.com");
        serverArgs.addAllowableArg(CGMINERPORT, "4028");
        serverArgs.addAllowableArg(HTTPPORT, "8001");
        serverArgs.addAllowableArg(HTTPSPORT, "8002");
        serverArgs.addAllowableArg(SSL, "false");
    }

    public static void main(String[] args) throws Exception {
        String cgminerHost;
        int cgminerPort;
        boolean ssl;
        int port;
        boolean debugLog;
        boolean logMemUsage;
        //final SslContext sslCtx;

        serverArgs.parseArgs(args);
        cgminerHost = serverArgs.getProperty(CGMINERHOST);
        cgminerPort = Integer.parseInt(serverArgs.getProperty(CGMINERPORT));
        ssl = Boolean.parseBoolean(serverArgs.getProperty(SSL));
        port = ssl  ? Integer.parseInt(serverArgs.getProperty(HTTPSPORT))
                    : Integer.parseInt(serverArgs.getProperty(HTTPPORT));
        debugLog = Boolean.parseBoolean(serverArgs.getProperty(DEBUGLOG));
        logMemUsage = Boolean.parseBoolean(serverArgs.getProperty(LOGMEMUSAGE));
        System.err.println("starting at " + (ssl ? "https" : "http") +
                "://localhost:" + port);
        System.err.println("cgminer at " + cgminerHost + ":" + cgminerPort);
                
        if (!debugLog) {
            LOGGER.setLevel(Level.OFF);
            Logger.getLogger("io.netty").setLevel(Level.OFF);    
        }
        Util.checkHostValidity(cgminerHost);

        // Configure SSL.
        //if (ssl) {
        //    SelfSignedCertificate ssc = new SelfSignedCertificate();
        //    sslCtx = SslContextBuilder.forServer(ssc.certificate(),
        //        ssc.privateKey()).build();
        //} else {
        //    sslCtx = null;
        //}

        // Configure the server.
        EventLoopGroup bossGroup = new NioEventLoopGroup(1);
        EventLoopGroup workerGroup = new NioEventLoopGroup();
        try {
            ServerBootstrap b = new ServerBootstrap();
            b.option(ChannelOption.SO_BACKLOG, 1024);
            b.group(bossGroup, workerGroup)
             .channel(NioServerSocketChannel.class)
             .handler(new LoggingHandler(LogLevel.INFO))
            // .childHandler(new CgminerNettyHttpServerInitializer(sslCtx,
            //     cgminerHost, cgminerPort));
             .childHandler(new CgminerNettyHttpServerInitializer(
                    cgminerHost, cgminerPort, logMemUsage));

            Channel ch = b.bind(port).sync().channel();

            /*
             * Print out elasped time it took to get to here.  For argument's 
             * sake we'll call this the startup time.
             */
            System.err.println("Startup time = " +
                    (System.currentTimeMillis() -
                    ManagementFactory.getRuntimeMXBean().getStartTime()) +
                    "ms");

            ch.closeFuture().sync();
        } finally {
            bossGroup.shutdownGracefully();
            workerGroup.shutdownGracefully();
        }
    }
}