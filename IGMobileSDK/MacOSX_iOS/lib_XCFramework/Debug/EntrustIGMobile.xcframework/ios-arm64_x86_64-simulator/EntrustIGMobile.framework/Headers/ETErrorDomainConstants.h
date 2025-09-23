/*
 
 ETErrorDomainConstants.h
 Entrust IdentityGuard Mobile SDK
 
 Copyright (c) 2014 Entrust, Inc. All rights reserved.
 Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
 
 */

#import <Foundation/Foundation.h>

/// Error codes for the Entrust IdentityGuard Mobile Soft Token SDK

typedef enum ETErrorCode {
    ///  The server returned an unexpected response code or invalid data.
    ETErrorCodeBadServerResponse = 10001,
    ///  The connection to a server failed.  Possible causes include connection timeouts or DNS lookup issues
    ETErrorCodeConnectionFailed = 10002,
    ///  A generic error has occurred.
    ETErrorCodeGenericError = 10003,
    ///  The maximum response size from a HTTP server request has been reached.
    ETErrorCodeMaxSizeReached = 10004,
    ///  The mobile device doesn't have a network connection available.
    ETErrorCodeNoNetworkAvailable = 10005,
    ///  The registration password provided has expired and is no longer valid.
    ETErrorCodeRegPasswordExpired = 10006,
    ///  The registration password provided is invalid.
    ETErrorCodeRegPasswordInvalid = 10007,
    ///  The transaction has expired or been canceled on the server and is no longer valid.
    ETErrorCodeTransactionInvalid = 10008,
    ///  There was an issue with the SSL server certificate. This may include it being untrusted, self-signed or having a hostname mismatch.
    ETErrorCodeServerSSLInvalid = 10009,
    ///  The remote server is out of service or temporarily unavailable.  Retry the request later.
    ETErrorCodeServerUnavailable = 10010,
    ///  The Entrust IdentityGuard Self-Service Transaction component has encountered an error with the request.
    ETErrorCodeUnauthorized = 10011,
    ///  The Entrust IdentityGuard Self-Service Transaction component doesn't support this version of the API.
    ETErrorCodeUnsupportedApiVersion = 10012,
    ///  The activation code has expired.  Request a new activation code from IdentityGuard.
    ETErrorCodeActivationCodeExpired = 10013,
    ///  The device is unsecure and based on the policy the identity cannot run on an unsecured device.
    ETErrorCodeUnsecuredDevice = 10014
} ETErrorCode;

/// Provides the error domain for the Entrust IdentityGuard Mobile SDK.

@interface ETErrorDomainConstants : NSObject

/// The error domain for the Entrust IdentityGuard Mobile SDK.

extern NSString * const ETErrorDomain;

///  The error user info key that contains the highest common API version
/// supported by the SDK and the Entrust IdentityGuard Self-Service
/// Transaction component.  This is only included in ETErrorCodeUnsupportedApiVersion
/// errors.

extern NSString * const ETErrorCommonApiVersion;

@end
