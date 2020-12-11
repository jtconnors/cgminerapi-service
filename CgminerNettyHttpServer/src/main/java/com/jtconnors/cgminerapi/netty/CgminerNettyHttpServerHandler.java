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

import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelFutureListener;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.handler.codec.http.DefaultFullHttpResponse;
import io.netty.handler.codec.http.FullHttpResponse;
import io.netty.handler.codec.http.HttpRequest;
import io.netty.handler.codec.http.HttpResponseStatus;
import io.netty.handler.codec.http.HttpUtil;

import static io.netty.handler.codec.http.HttpHeaderNames.CONTENT_TYPE;
import static io.netty.handler.codec.http.HttpHeaderNames.CONTENT_LENGTH;
import static io.netty.handler.codec.http.HttpHeaderNames.CONNECTION;
import static io.netty.handler.codec.http.HttpHeaderValues.KEEP_ALIVE;
import static io.netty.handler.codec.http.HttpResponseStatus.CONTINUE;
import static io.netty.handler.codec.http.HttpResponseStatus.OK;
import static io.netty.handler.codec.http.HttpResponseStatus.BAD_REQUEST;
import static io.netty.handler.codec.http.HttpVersion.HTTP_1_1;

import java.io.IOException;
import java.lang.invoke.MethodHandles;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.jtconnors.cgminerapi.APIConnection;
import com.jtconnors.cgminerapi.Command;
import com.jtconnors.cgminerapi.InvalidQueryStringException;
import com.jtconnors.cgminerapi.Util;

public class CgminerNettyHttpServerHandler
    extends ChannelInboundHandlerAdapter {

    private static final Class<?> thisClass =
        MethodHandles.lookup().lookupClass();
    private static final Logger LOGGER = Logger.getLogger(thisClass.getName());

    class ResponseBlock {
        HttpResponseStatus httpResponseStatus;
        String contentStr;    
    }

    private final String cgminerHost;
    private final int cgminerPort;

    public CgminerNettyHttpServerHandler(String cgminerHost, int cgminerPort) {
        super();
        this.cgminerHost = cgminerHost;
        this.cgminerPort = cgminerPort;
    } 

    private ResponseBlock parseUriString(String uriStr) {
        ResponseBlock rb = new ResponseBlock();
        /*
         * Make sure the URI string starts with "/cgminer" context
         */
        if (!uriStr.startsWith(CgminerNettyHttpServer.CONTEXT)) {
            rb.httpResponseStatus = BAD_REQUEST;
            rb.contentStr = getInvalidQueryStringExceptionStr(
                    "URI must begin with" + CgminerNettyHttpServer.CONTEXT);
            return rb;
        }
        /*
         * Before parsing query string make sure there's at least a "?"
         * character after the /cgminer context
         */
        if (!uriStr.contains("?")) {
            rb.httpResponseStatus = BAD_REQUEST;
            rb.contentStr = getInvalidQueryStringExceptionStr(
                    "Invalid URI Query String " + uriStr);
            return rb;
        }
        /*
         * Parse the query string, convert to JSON, issue an API call to the
         * cgminer instance.  Collect the returned JSON string
         */ 
        try {
            String queryStr = uriStr.substring(CgminerNettyHttpServer.CONTEXT.length()+1);
            String jsonCommandStr = Command.parseQueryString(queryStr).toJSONString();
            LOGGER.log(Level.INFO, "JSON  command = {0}", jsonCommandStr);
            rb.contentStr = new APIConnection(cgminerHost, cgminerPort)
                    .apiCall(jsonCommandStr); 
            rb.httpResponseStatus = OK;           
        } catch (InvalidQueryStringException | IOException e) {
            rb.contentStr = Util.exceptionStackTraceToString(e);
            LOGGER.log(Level.SEVERE, "{0}", rb.contentStr);
            rb.httpResponseStatus = BAD_REQUEST;
        }    
        return rb;
    }

    @Override
    public void channelReadComplete(ChannelHandlerContext ctx) {
        ctx.flush();
    }

    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) {
        if (msg instanceof HttpRequest) {
            HttpRequest req = (HttpRequest) msg;
            ResponseBlock rb = parseUriString(req.uri());
            
            if (HttpUtil.is100ContinueExpected(req)) {
                ctx.write(new DefaultFullHttpResponse(HTTP_1_1, CONTINUE));
            }
            boolean keepAlive = HttpUtil.isKeepAlive(req);
            FullHttpResponse response = new DefaultFullHttpResponse(HTTP_1_1, 
                rb.httpResponseStatus, Unpooled.wrappedBuffer(rb.contentStr.getBytes()));
            response.headers().set(CONTENT_TYPE, "text/plain");
            response.headers().set(CONTENT_LENGTH, response.content().readableBytes());
            if (!keepAlive) {
                ctx.write(response).addListener(ChannelFutureListener.CLOSE);
            } else {
                response.headers().set(CONNECTION, KEEP_ALIVE);
                ctx.write(response);
            }
        }
    }

    private String getInvalidQueryStringExceptionStr(String msg) {
        InvalidQueryStringException e = new InvalidQueryStringException(msg);
        return Util.exceptionStackTraceToString(e);    
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
        cause.printStackTrace();
        ctx.close();
    }
}

