/*******************************************************************************
 * EBKLog.m                                                                    *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

#import "BindKit.h"
#import <os/log.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"

#define OS10 (([[[UIDevice currentDevice] systemVersion] compare: @"10.0" options:NSNumericSearch] != NSOrderedAscending))

#define LOGSIZE 256                ///< Maximum size that os_log_* can log to the console in one go.
#define LOGCHUNKSIZE (LOGSIZE-16)  ///< What we allow to log taking into account we also have to have "X of Y:" prefixed to each chunk.
#define NSLOGSIZE 2048             ///< Maximum size that NSLog can log to the console in one go.
#define NSCHUNKSIZE (NSLOGSIZE-16) ///< What we allow to log taking into account we also have to have "X of Y:" prefixed to each chunk.

static EBKLogLevel logLevel = EBKLogLevelError;
static os_log_t app_log;
static int maxSize;
static int chunkSize;

void EBKSetLogging(EBKLogLevel _logLevel) {
    logLevel = _logLevel;
}

void EBKLogS(EBKLogFlag _logFlag, NSString* _Nonnull msg) {
    if ((logLevel & _logFlag) == 0)
        return;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (OS10) {
            // OS10 and above uses the unified logging APIs.
            app_log = os_log_create("nz.co.electricbolt.bindkit", "lib");
            maxSize = LOGSIZE;
            chunkSize = LOGCHUNKSIZE;
        } else {
            // OS9 and below uses NSLog.
            maxSize = NSLOGSIZE;
            chunkSize = NSCHUNKSIZE;
        }
    });

    if ([msg length] < maxSize) {
        if (OS10)
            os_log_info(app_log, "%{public}@", msg);
        else
            NSLog(@"%@", msg);
    } else {
        int count = (int) [msg length] / chunkSize;
        int rem = [msg length] % chunkSize;
        count += (rem != 0 ? 1 : 0);
        int offset = 0, len = 0, i = 0;
        while (offset < [msg length]) {
            len = (int) [msg length] - offset;
            if (len > chunkSize)
                len = chunkSize;
            if (OS10)
                os_log_info(app_log, "%d of %d=%{public}@", ++i, count, [msg substringWithRange: NSMakeRange(offset, len)]);
            else
                NSLog(@"%d of %d=%@", ++i, count, [msg substringWithRange: NSMakeRange(offset, len)]);
            offset += chunkSize;
        }
    }
}

void EBKLogO(EBKLogFlag _logFlag, const char* path, NSString* method, int line, NSString* msg, ...) {
    if ((logLevel & _logFlag) == 0)
        return;

    va_list args;
    va_start(args, msg);

    // Extract filename from __FILE__
    NSArray* d = [[NSString stringWithCString: path encoding: NSASCIIStringEncoding] componentsSeparatedByString: @"/"];
    d = [((NSString*) [d lastObject]) componentsSeparatedByString: @"."];
    NSString* filename = [d objectAtIndex:0];

    // Prepend "filename.method:line"
    NSMutableString* s1 = [[NSMutableString alloc] initWithFormat: @"%@.%@:%d ", filename, method, line];
    [s1 appendString: [[NSString alloc] initWithFormat: msg arguments: args]];
    va_end(args);

    // NSLog has a limit of 256/2048 characters per statement. If our msg (including
    // filename and line number) is larger than that, then we'll have to break it
    // up into chunks and write each chunk individually.
    NSString* s2 = [s1 stringByReplacingOccurrencesOfString: @"%" withString: @"%%"];

    EBKLogS(_logFlag, s2);
}

#pragma clang diagnostic pop
