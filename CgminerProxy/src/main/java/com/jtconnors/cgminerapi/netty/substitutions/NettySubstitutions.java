
package com.jtconnors.cgminerapi.netty.substitutions;

import com.oracle.svm.core.annotate.TargetClass;
import com.oracle.svm.core.annotate.Substitute;
import io.netty.util.internal.logging.InternalLoggerFactory;
import io.netty.util.internal.logging.JdkLoggerFactory;

@TargetClass(io.netty.util.internal.logging.InternalLoggerFactory.class)
final class Target_io_netty_util_internal_logging_InternalLoggerFactory {
    @Substitute
    private static InternalLoggerFactory newDefaultFactory(String name) {
        return JdkLoggerFactory.INSTANCE;
    }
}
