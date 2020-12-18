/*
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

/*
 * Code lifted and modified from the Netty Project as indicated by license
 * above.
 */

package com.jtconnors.cgminerapi.netty;

import com.jtconnors.cgminerapi.Util;
import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.Channel;
import io.netty.channel.ChannelOption;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.handler.logging.LogLevel;
import io.netty.handler.logging.LoggingHandler;
import java.lang.invoke.MethodHandles;
import java.lang.management.ManagementFactory;
import java.util.logging.Level;
import java.util.logging.Logger;

import static com.jtconnors.cgminerapi.netty.ProxyArgs.*;
 
public final class CgminerProxy {

    private static final String PROGNAME = "cgminerProxy";

    private static ProxyArgs proxyArgs;

    static {
        proxyArgs = new ProxyArgs(MethodHandles.lookup().lookupClass(),
            RESOURCE_NAME, PROGNAME);
        proxyArgs.addAllowableArg(LOCALPORT, "4028");
        proxyArgs.addAllowableArg(REMOTEHOST, "49er");
        proxyArgs.addAllowableArg(REMOTEPORT, "4028");
        proxyArgs.addAllowableArg(DEBUGLOG, "false");
    }
 
    public static void main(String[] args) throws Exception {
        int localPort;
        String remoteHost;
        int remotePort;
        boolean debugLog;

        proxyArgs.parseArgs(args);
        localPort = Integer.parseInt(proxyArgs.getProperty(LOCALPORT));
        remoteHost = proxyArgs.getProperty(REMOTEHOST);
        remotePort = Integer.parseInt(proxyArgs.getProperty(REMOTEPORT));
        debugLog = Boolean.parseBoolean(proxyArgs.getProperty(DEBUGLOG));
        if (!debugLog) {
            Logger.getLogger("io.netty").setLevel(Level.OFF);    
        }
        Util.checkHostValidity(remoteHost);
        
        System.err.println("Proxying *:" + localPort + " to " + 
            remoteHost + ':' + remotePort + " ...");
 
        // Configure the bootstrap.
        EventLoopGroup bossGroup = new NioEventLoopGroup(1);
        EventLoopGroup workerGroup = new NioEventLoopGroup();
        try {
            ServerBootstrap b = new ServerBootstrap();
            b.group(bossGroup, workerGroup)
            .channel(NioServerSocketChannel.class)
            .handler(new LoggingHandler(LogLevel.INFO))
            .childHandler(new CgminerProxyInitializer(remoteHost, remotePort))
            .childOption(ChannelOption.AUTO_READ, false);

            Channel ch = b.bind(localPort).sync().channel();

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
