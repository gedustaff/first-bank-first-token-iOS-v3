/*
 
 ETLogger.h
 Entrust IdentityGuard Mobile SDK
 
 Copyright (c) 2014 Entrust, Inc. All rights reserved.
 Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
 
 */

#import <Foundation/Foundation.h>


/// The ETLogger protocol an application to provide its own logging
/// implementation to the SDK so it can direct SDK log messages to
/// its own logging file.  The SDK includes a default logger which
/// writes all log messages to NSLog.  To override the logging
/// implementation create a class which implements ETLogger and
/// provide the implementation to ETSoftTokenSDK.

@protocol ETLogger <NSObject>
@required


/// Logs the given message if the log level is set to ``ETLogLevel/ETLogLevelError`` or above.
///
/// @param message The message to log.

- (void) logError:(NSString *)message;


/// Logs the given message if the log level is set to ``ETLogLevel/ETLogLevelInfo`` or above.
///
/// @param message The message to log.

- (void) logInfo:(NSString *)message;



/// Logs the given message if the log level is set to ``ETLogLevel/ETLogLevelWarning`` or above.
///
/// @param message The message to log.

- (void) logWarning:(NSString *)message;


/// Logs the given message if the log level is set to ``ETLogLevel/ETLogLevelDebug`` or above.
///
/// @param message The message to log.

- (void) logDebug:(NSString *)message;


/// Logs the given message as long as logging isn't set to ``ETLogLevel/ETLogLevelOff``.
///
/// @param message The message to log.

- (void) logAlways:(NSString *)message;

@end
