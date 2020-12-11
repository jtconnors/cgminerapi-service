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

import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelPipeline;
import io.netty.channel.socket.SocketChannel;
import io.netty.handler.codec.http.HttpServerCodec;
//import io.netty.handler.ssl.SslContext;

public class CgminerNettyHttpServerInitializer
    extends ChannelInitializer<SocketChannel> {

    //private final SslContext sslCtx;
    private final String cgminerHost;
    private final int cgminerPort;

    //public CgminerNettyHttpServerInitializer(SslContext sslCtx, 
    public CgminerNettyHttpServerInitializer( 
            String cgminerHost, int cgminerPort) {
        //this.sslCtx = sslCtx;
        this.cgminerHost = cgminerHost;
        this.cgminerPort = cgminerPort;
    }

    @Override
    public void initChannel(SocketChannel ch) {
        ChannelPipeline p = ch.pipeline();
        //if (sslCtx != null) {
        //    p.addLast(sslCtx.newHandler(ch.alloc()));
        //}
        p.addLast(new HttpServerCodec());
        p.addLast(new CgminerNettyHttpServerHandler(cgminerHost, cgminerPort));
    }
}