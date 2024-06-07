/*
 
 ETIdentityProvider.h
 Entrust IdentityGuard Mobile SDK
 
 Copyright (c) 2014 Entrust, Inc. All rights reserved.
 Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
 
 */

/// \mainpage Entrust IdentityGuard Mobile
///
/// \section intro_sec Introduction
///
/// This is the class documentation for the Entrust IdentityGuard Mobile
/// SDK. Select the Classes tab for a brief overview of all the classes in
/// the SDK. The Readme_MacOSX-iOS.html file included with the SDK includes some
/// instructions on how to link the SDK to your application.  See the
/// Programmers Guide for details on using the SDK and it also
/// includes sample code showing how to use the SDK.  There is also a working
/// example application included with the SDK which can be used for reference.
///


#import "ETCommCallback.h"
#import "ETDataTypes.h"
#import "ETConfigurationFile.h"

@class ETIdentity;
@class ETTransaction;


/// The ETIdentityProvider class provides functionality that can be used to
/// generate a new identity, register the identity with the Entrust IdentityGuard
/// Self-Service Module Transaction components for transaction verification,
/// and to download transactions from the Transaction component.
/// <p>
/// To generate a new identity, call the <code>generate</code> method
/// specifying the device token obtained from registering the application
/// for notifications (optional) and the serial number and activation code
/// obtained from Entrust IdentityGuard.
/// After calling generate, the registration code available in the new
/// ETIdentity must be sent to Entrust IdentityGuard to complete registration on the
/// server side.  This can be done automatically by calling
/// <code>registerIdentity</code>, or the value can be sent to Entrust IdentityGuard
/// through some other mechanism, for example by displaying it to the user
/// and having the user enter it in a web page.
/// <p>
/// To register for transaction verification, call the <code>registerIdentity</code>
/// method.  If registration does not complete successfully, the method can
/// be called at a later time to perform registration.  If the device token
/// changes, call <code>registerIdentity</code> again to register the new value.
/// <p>
/// To retrieve any available transactions from the server call
/// <code>poll</code>.

@interface ETIdentityProvider : NSObject {
@private
    /// The URL of the Transaction component
    NSString *transactionURL;
    /// The version of the Transaction component API to use.
    NSString *apiVersion;
    /// Whether the SDK should attempt to fallback to an older version of the API.
    BOOL autoApiVersionFallback;
}

@property (nonatomic, strong) NSString *transactionURL;
@property (nonatomic, strong) NSString *apiVersion;
@property (nonatomic) BOOL autoApiVersionFallback;
@property (nonatomic,strong) NSMutableArray<ETTransaction*> *transactionIdList; // For Transaction Queuing


/// Initialize an instance of ETIdentityProvider specifying the URL of the
/// Entrust IdentityGuard Self-Service Module Transaction component. With a typical installation
/// of Entrust IdentityGuard Self-Service Module, the URL would look like
/// https://myhostname:8445/igst, but firewalls, proxies, and other
/// configuration changes may mean a different URL must be used.
/// <p>
/// The URL is an optional argument.
/// If not specified, the register and poll methods will not do anything.
///
/// - Parameter txnURL: the URL of the Transaction component.

-(id)initWithURLString:(NSString*)txnURL;


/// Generate a new soft token identity for the given serial number , activation code and default Security Policy setting.
/// By default, the Security Policy is disabled and does not allow identity to be used on an unsecured identity.
/// - Parameter deviceId: an identifier of the device on which the soft token is stored.
///                 This value is optional but
///                 if it is not specified calls to the register and
///                 poll methods will not do anything. For an application to receive
///                 notifications, the value required here is the device token obtained
///                 from calling the registerForRemoteNotificationTypes method
///                 in the UIApplication class, then base 64
///                 encoded to a string.
///
/// - Parameter serialNumber: the serial number of the identity to be generated.
///
/// - Parameter activationCode: the activation code of the identity to be
///                       generated.
///
/// - Returns: the new soft token identity.
///
/// - Throws: NSException if any error is encountered generating the identity.
///                      Potential errors include invalid or missing values
///                      for the serialNumber and activationCode.

+(ETIdentity*) generate:(NSString*)deviceId serialNumber:(NSString*)serialNumber activationCode:(NSString*)activationCode;


/// Generate a new soft token identity for the given serial number, activation code and Security Policy string.
/// - Parameter deviceId: an identifier of the device on which the soft token is stored.
///                 This value is optional but
///                 if it is not specified calls to the register and
///                 poll methods will not do anything. For an application to receive
///                 notifications, the value required here is the device token obtained
///                 from calling the registerForRemoteNotificationTypes method
///                 in the UIApplication class, then base 64
///                 encoded to a string.
///
/// - Parameter serialNumber: the serial number of the identity to be generated.
///
/// - Parameter activationCode: the activation code of the identity to be
///                       generated.
///
/// - Parameter securityPolicyString: the string of the  security policy asscotiate with the identity
///
/// - Returns: the new soft token identity.
///
/// - Throws: NSException if any error is encountered generating the identity.
///                      Potential errors include invalid or missing values
///                      for the serialNumber and activationCode.

+(ETIdentity*) generate:(NSString*)deviceId serialNumber:(NSString*)serialNumber activationCode:(NSString*)activationCode securityPolicyString:(NSString *)securityPolicyString;


/// Generate a new soft token identity for the given serial number and registration password.
/// - Parameter deviceId: an identifier of the device on which the soft token is stored.
///                 This value is optional but
///                 if it is not specified calls to the register and
///                 poll methods will not do anything. For an application to receive
///                 notifications, the value required here is the device token obtained
///                 from calling the registerForRemoteNotificationTypes method
///                 in the UIApplication class, then base 64
///                 encoded to a string.
///
/// - Parameter serialNumber: the serial number of the identity to be generated.
///
/// - Parameter regPassword: the registration password used to activate an identity.
///
/// - Parameter classicTransactions: Whether or not this identity should register for classic
///        transactions.
///
/// - Parameter onlineTransactions: Whether or not this identity should register for
///        online transaction confirmation.  In order to set this to YES, you
///        must also enable support for classic transactions.
///
/// - Parameter offlineTransactions: Whether or not this identity should register for
///        offline transaction confirmation.  In order to set this to YES, you
///        must also enable support for classic transactions.
///
/// - Parameter notifications: Whether or not this identity should register for push
///        notifications.
///
/// - Parameter comm: a class provided by the caller to handle HTTP communication.
///        If a value is not specified, the default implementation will
///        be used.
/// - Parameter errorPtr: If there is an error, upon return contains an NSError object that describes the problem.
///
/// - Returns: the new soft token identity or nil.
///
/// - Throws: NSException if any error is encountered generating the identity.
///                      Potential errors include invalid or missing values
///                      for the serialNumber and activationCode.

-(ETIdentity *) createIdentityUsingRegPassword:(NSString*)regPassword serialNumber:(NSString *)serialNumber deviceId:(NSString *) deviceId transactions:(BOOL)classicTransactions onlineTransactions:(BOOL)onlineTransactions offlineTransactions:(BOOL)offlineTransactions notifications:(BOOL)notifications callback:(id<ETCommCallback>) comm error:(NSError**)errorPtr;


/// Register the identity with Entrust IdentityGuard for transaction verification.
/// If activation has not been completed for the identity (i.e., the
/// registration code is still set inside the given identity and hasn't
/// been provided to Entrust IdentityGuard) this operation
/// will also complete activation.  This call will do nothing if the
/// ETIdentityProvider does not have a Transaction component URL configured.  If
/// the ETIdentity has already been registered for transactions and the
/// device ID specified as an argument to this method is the same as the
/// current device ID of the identity this call will do nothing.
/// <p>
/// The scenarios where this method should be called are:
/// <ul>
/// <li>an identity has just been generated and is not registered yet</li>
/// <li>a previous attempt to register a new identity failed</li>
/// <li>the device ID has changed</li>
/// </ul>
/// In the latter two scenarios, an application should consider calling
/// the method each time the application starts.  The method won't peform
/// any operations if it determines that registration is not required.
///
/// - Parameter identity: the identity to be registered
///
/// - Parameter deviceId: an identifier of the device on which the soft token is stored.
///        If the device ID is specified and it differs from the
///        current device ID of the identity, the new device ID will be
///        registered with IdentityGuard.  The new device ID will be
///        stored in the identity. If registration fails the identity will
///        be marked as not registered for transactions.
///        For an application to receive
///        notifications, the value required here is the device token obtained
///        from calling the registerForRemoteNotificationTypes method
///        in the UIApplication class, then base 64 encoded to a string.
///
/// - Parameter comm: a class provided by the caller to handle HTTP communication.
///        If a value is not specified, the default implementation will
///        be used.
/// - Parameter classicTransactions: Whether or not this identity should register for classic
///        transactions.
/// - Parameter onlineTransactions: Whether or not this identity should register for
///        online transaction confirmation.  In order to set this to YES, you
///        must also enable support for classic transactions.
/// - Parameter offlineTransactions: Whether or not this identity should register for
///        offline transaction confirmation.  In order to set this to YES, you
///        must also enable support for classic transactions.
/// - Parameter notifications: Whether or not this identity should register for push
///        notifications.
/// - Parameter errorPtr: If there is an error, upon return contains an NSError object that describes the problem.
/// - Returns: YES if the identity has been updated, NO otherwise.  If
///         the identity has been updated the caller should make sure the
///         identity is saved.

- (BOOL) registerIdentity:(ETIdentity*)identity deviceId:(NSString*)deviceId transactions:(BOOL)classicTransactions onlineTransactions:(BOOL)onlineTransactions offlineTransactions:(BOOL)offlineTransactions notifications:(BOOL)notifications callback:(id<ETCommCallback>)comm error:(NSError**)errorPtr __attribute__((swift_error(nonnull_error)));


/// Fetch a particular transaction from the Transaction component.
/// If the ETIdentityProvider doesn't have a Transaction component URL configured
/// or the identity is not registered for transactions, this method will
/// return <code>nil</code>. If the given transaction ID
/// cannot be found by the server, a transaction with <code>nil</code> transaction details
/// will be returned. If communication with the server fails for any reason,
/// <code>nil</code> is returned.
///
/// - Parameter transactionId:
///     The identifier of the transaction to fetch.
/// - Parameter identity:
///     the identity for which to fetch the transaction.
/// - Parameter comm: a class provided by the caller to handle HTTP communication.
///        If a value is not specified, the default implementation will
///        be used.
/// - Parameter errorPtr: If there is an error, upon return contains an NSError object that describes the problem.
/// - Returns: the requested transaction, if available.

-(ETTransaction *)fetchTransaction:(NSString*)transactionId forIdentity:(ETIdentity*)identity callback:(id<ETCommCallback>) comm error:(NSError**)errorPtr;


/// Fetch multiple pending transactions from the Transaction component. If the TransactionProvider
/// doesn't have a Transaction component URL configured or the identity is not registered for
/// transactions, this method will return <code>nil</code>. If the given transaction ID(s) cannot
/// be found by the server, a transaction with empty array[] transaction details will be
/// returned. If communication with the server fails for any reason, <code>nil</code> is
/// returned.
///
/// - Parameter transactionId:
///     The identifier of the transactions to fetch.
/// - Parameter identity:
///     the identity for which to fetch the transactions.
/// - Parameter comm: a class provided by the caller to handle HTTP communication
///           with the Transaction component.
/// - Parameter errorPtr: If there is an error, upon return contains an NSError object that describes the problem.
/// - Returns: the queue requesteds transaction, if available.

-(NSMutableArray *)fetchTransactionQueue:(NSString*)transactionId forIdentity:(ETIdentity*)identity callback:(id<ETCommCallback>) comm error:(NSError**)errorPtr;


/// Authenticate a particular transaction with the Transaction component.
/// If the ETIdentityProvider doesn't have a Transaction component URL configured
/// or the identity is not registered for transactions, this method will
/// return <code>NO</code>. If the given transaction
/// cannot be found by the server <code>NO</code> will be returned.
/// If communication with the server fails for any reason,
/// <code>NO</code> is returned.
///
/// - Parameter transaction:
///     The transaction to authenticate.
/// - Parameter identity:
///     the identity to authenticate with.
/// - Parameter response:
///     the response string to send back.
/// - Parameter comm: a class provided by the caller to handle HTTP communication.
///        If a value is not specified, the default implementation will
///        be used.
/// - Parameter errorPtr: If there is an error, upon return contains an NSError object that describes the problem.
/// - Returns: the requested transaction, if available.

-(BOOL)authenticateTransaction:(ETTransaction*)transaction forIdentity:(ETIdentity*)identity withResponse:(ETTransactionResponse)response callback:(id<ETCommCallback>) comm error:(NSError**)errorPtr;


/// Poll the Transaction component for transactions for the given identity.
/// If the ETIdentityProvider doesn't have a transaction URL configured
/// or the identity is not registered for transactions, this method will
/// return nil.  If the identity has no outstanding transactions,
/// this method will return nil.
///
/// - Parameter identity: the identity for which to fetch transactions.
/// - Parameter comm: a class provided by the caller to handle HTTP communication.
///        If a value is not specified, the default implementation will
///        be used.
/// - Parameter errorPtr: If there is an error, upon return contains an NSError object that describes the problem.
/// - Returns: any outstanding transaction for the identity,
///         or nil if there is no transaction.

-(ETTransaction *)poll:(ETIdentity*)identity callback:(id<ETCommCallback>)comm error:(NSError**)errorPtr;


/// Poll all the pending transactions for the given identity. If the
/// TransactionProvider doesn't have a transaction URL configured or the identity is not
/// registered for transactions, this method will return <code>nil</code>. If the identity has
/// no outstanding transaction, this method will return empty array[].
///
/// - Parameter identity: the identity for which to fetch transactions.
/// - Parameter comm: a class provided by the caller to handle HTTP communication
///           with the Transaction component.
/// - Parameter errorPtr: If there is an error, upon return contains an NSError object that describes the problem.
/// - Returns: any outstanding array of transactions for the identity,
///         or empty array[] if there is no transaction.

-(NSMutableArray *)pollQueue:(ETIdentity*)identity callback:(id<ETCommCallback>)comm error:(NSError**)errorPtr;



/// Obtains the current time from the identity provider server and validates
/// the time against the local device time.
///
/// This method takes a window size parameter in seconds that is used to generate
/// the validity window for comparison.  Because there are network delays in
/// fetching the time from the server, the algorithm takes the time the
/// network request was started and finished as the initial window.  It
/// then expands the window on both sides by subtracting the window size from
/// start time and adding the window size to the finish time.
///
/// A recommended window size is 2 minutes (120 seconds).
///
/// - Parameter windowInSecs: The number of seconds to expand the validity window.
///        This number of seconds is subtracted from the time the network
///        started and added to the time the network request completed.
/// - Parameter comm: a class provided by the caller to handle HTTP communication.
///        If a value is not specified, the default implementation will
///        be used.
/// - Parameter errorPtr: If there is an error, upon return contains an NSError object that describes the problem.
/// - Returns: The date from the server to the nearest second or nil if an error
/// occurred.

-(ETTimeValidationResponse) validateDeviceTimeAgainstServerWithWindow:(long)windowInSecs usingCommCallback:(id<ETCommCallback>)comm error:(NSError**)errorPtr;


/// Obtains the current time from the identity provider server.  This value can
/// used to detect time synchonization issues between the local device and the
/// server.  If there is a substantial time difference, the time or time zone
/// on the server or device may be incorrect. The server returns the time in
/// seconds since Epoch.
///
/// Note when comparing the time returned from the server against the local
/// device time, be aware that there are networking delays in sending the
/// request and receiving the response.  These delays should be factored in to
/// your time comparison algorithm.
///
/// - Parameter comm: a class provided by the caller to handle HTTP communication.
///        If a value is not specified, the default implementation will
///        be used.
/// - Parameter errorPtr: If there is an error, upon return contains an NSError object that describes the problem.
/// - Returns: The date from the server to the nearest second or nil if an error
/// occurred.

-(NSDate *) getServerTimeUsingCommCallback:(id<ETCommCallback>) comm error:(NSError**)errorPtr;


/// Check that the given value is a serial number.  Throws an exception
/// if it is not.
///
/// - Parameter serialNumber: the serial number to validate
/// - Parameter errorPtr:  If the given value is not valid, upon return contains an NSError object that describes the problem.
///

+(BOOL)validateSerialNumber:(NSString*)serialNumber error:(NSError**)errorPtr;


/// Check that the given value is a activation code.  Throws an exception
/// if it is not.
///
/// - Parameter activationCode: the activation code to validate
/// - Parameter errorPtr:  If the given value is not valid, upon return contains an NSError object that describes the problem.

+(BOOL)validateActivationCode:(NSString*)activationCode error:(NSError**)errorPtr;


/// Format the given code by inserting the specified breakChar every
/// numChars.  For example, given the code 1234567890 with numChars 5 and
/// breakChar of '-' this method will return the value 12345-67890.
///
/// - Parameter code: the value to be formatted.
/// - Parameter charsPerGroup: the number of characters between the breakChar
/// - Parameter breakChar: the breakChar to insert
/// - Returns: the formatted code

+(NSString*)formatCode:(NSString*)code charsPerGroup:(int)charsPerGroup breakChar:(char)breakChar;


/// Fetch the soft token identity provider configuration file.
/// If communication with the server fails for any reason,
/// <code>nil</code> is returned.
///
/// - Parameter address:
///     The identity provider configuration file address.  If this address
///     doesn't end with /config.json, it will be appended automatically.
/// - Parameter comm: a class provided by the caller to handle HTTP communication.
///        If a value is not specified, the default implementation will
///        be used.
/// - Parameter errorPtr: If there is an error, upon return contains an NSError object that describes the problem.
///
/// - Returns: the configuration file or nil.

+(ETConfigurationFile *)fetchConfigurationFile:(NSString*)address callback:(id<ETCommCallback>)comm error:(NSError**)errorPtr;


/// Fetch the identity provider logo image from the provided address.
/// Note: This method simply performs a GET request and returns the data however it is
/// included in the SDK for convenience.
/// 
/// - Parameter address:
///     The address of the provider image to fetch.
/// - Parameter comm: a class provided by the caller to handle HTTP communication.
///        If a value is not specified, the default implementation will
///        be used.
/// - Parameter errorPtr: If there is an error, upon return contains an NSError object that describes the problem.
///
/// - Returns: the provider image or nil.

+(NSData*)fetchProviderLogoFromUrl:(NSString*)address callback:(id<ETCommCallback>)comm error:(NSError**)errorPtr;

- (NSDictionary*)fetchFacePhiLicenseKeys:(NSString*)tokenSerialNumbers callback:(id<ETCommCallback>)comm error:(NSError**)errorPtr;


/// Obtains the new identity provider address(config url) from the current transaction URL header values.
/// This value can be used to detect any server migration for the tokens. If there is a new identity provider address in headers, the app can choose to update the identity and pull the configuration details from the new server. No exceptions thrown, just
/// returns a nil new provider address.
///
/// - Parameter commCallback: A class provided by the caller to handle HTTP communication. If a value is not
///                     provided, the default implementation will be used.
/// - Parameter identity:     The specific identity to check for. This parameter is optional.
/// - Returns: New Identity Provider address for the token from headers. nil if none found.

-(NSString *) fetchNewIdentityProvider:(id<ETCommCallback>) comm forIdentity:(ETIdentity*)identity;


/// Rotate seed for an identity
///
/// - Parameter commCallback: A class provided by the caller to handle HTTP communication. If a value is not
///                     provided, the default implementation will be used.
/// - Parameter identity: the identity for which to rotate seed
/// - Parameter errorPtr: If there is an error, upon return contains an NSError object that describes the problem.

-(void)getNewSeed:(ETIdentity *)identity callback:(id<ETCommCallback>)comm error:(NSError**)errorPtr __attribute__((swift_error(nonnull_error)));

@end
