/*
 
 ETDataTypes.h
 Entrust IdentityGuard Mobile SDK
 
 Copyright (c) 2014 Entrust, Inc. All rights reserved.
 Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
 
 */


#ifndef EntrustIGMobileStatic_ETDataTypes_h
#define EntrustIGMobileStatic_ETDataTypes_h


/// Defines the logging levels for the SDK.

typedef enum ETLogLevel {
    /// Logging is disabled.  No logs will be generated.
    ETLogLevelOff,
    /// Only error level logs will be generated.
    ETLogLevelError,
    /// Only warning and more severe logs will be generated.
    ETLogLevelWarning,
    /// Only info and more severe logs will be generated.
    ETLogLevelInfo,
    /// All logs will be generated.
    ETLogLevelDebug
} ETLogLevel;


/// Defines the possible user responses to a transaction.

typedef enum ETTransactionResponse {
    
    ///  The user wants to confirm this transaction.
    
    ETTransactionResponseConfirm,
    
    ///  The user wants to cancel this transaction.
    
    ETTransactionResponseCancel,
    
    ///  The user wants to report a concern with this transaction.
    
    ETTransactionResponseConcern,
    
    ///  No response provided. Internal use only.
    
    ETTransactionResponseNone
} ETTransactionResponse;


/// Defines the possible transaction modes.  Modes refer to how the
/// transaction is fetched and responded to.

typedef enum ETTransactionMode {
    
    ///  This mode represents the classic mode of performing transactions
    ///  where the transaction is polled and fetched from Entrust IdentityGuard.
    ///  The user is displayed a confirmation code which they type into the
    ///  website or application that requested the transaction.
    
    ETTransactionModeClassic,
    
    ///  This mode represents the new online transaction confirmation mode
    ///  of performing transactions.  The transaction is polled and fetched from
    ///  Entrust IdentityGuard exactly like the classic mode however the response
    ///  is automatically sent back to Entrust IdentityGuard without displaying
    ///  a confirmation code to the user.  In this mode the cancel and concern
    ///  responses are also sent back to Entrust IdentityGuard.
    
    ETTransactionModeOnline,
    
    ///  This mode is a placeholder for future functionality where the transaction
    ///  is scanned from a QR code displayed by a website or application.  A confirmation
    ///  code is generated and displayed to the user to type into the website or application
    ///  that requested the transaction.
    ///  Not currently supported.
    
    ETTransactionModeOffline,
    
    ///  The provided transaction mode is unknown by this version of the SDK.
    
    ETTransactionModeUnknown
} ETTransactionMode;


/// Defines the possible return values when validating the device time against the server.

typedef enum ETTimeValidationResponse {
    
    ///  The server time is within the validity window.
    
    ETTimeValidationResponseOk,
    
    ///  The server time is not within the validity window.
    
    ETTimeValidationResponseMismatch,
    
    ///  Unable to perform the time validation.  The server may not support it,
    ///  networking may be disabled, the request to the server was too slow
    ///  or an error occurred.
    
    ETTimeValidationResponseError
} ETTimeValidationResponse;

#endif
