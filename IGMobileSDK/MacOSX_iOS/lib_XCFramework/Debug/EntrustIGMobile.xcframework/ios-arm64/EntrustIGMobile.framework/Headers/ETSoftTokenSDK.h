/*
 
 ETSoftTokenSDK.h
 Entrust IdentityGuard Mobile SDK
 
 Copyright (c) 2014 Entrust, Inc. All rights reserved.
 Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
 
 */

#import <Foundation/Foundation.h>
#import "ETDataTypes.h"
#import "ETCommCallback.h"
#import "ETLaunchUrlParams.h"
#import "ETNotificationParams.h"
#import "ETLogger.h"


/// This class stores configuration settings for the SDK which allow
/// the SDK to be customized and initalized.

@interface ETSoftTokenSDK : NSObject


/// Initailize the Soft Token SDK.  If the SDK detects that this is the first time the application
/// has been run or that data has been restored from another device, it will reset the SDK
/// and clear the encryption key.  If the SDK resets itself, it will return true from this method.
/// This should be an indication to your app that it should clear any existing data from a previous
/// invocation of the application.  In particular, this will reset the device encryption key so
/// any application data that was previously encrypted with this key will become invalid.
/// Note: This will only perform initialization the first time it is called.  If it is called again,
/// it simply returns whether or not a reset was performed during initalization.

/// - Returns: Whether the Soft Token SDK was reset during initalization.

+ (BOOL) initializeSDK;


/// This command resets the SDK and generates new encryption abd MACing keys used for data protection.
/// Any data that was encrypted using the old keys will no longer be readable.

+ (void) resetSDK;


/// Gets the SDK short version number.
/// - Returns: The SDK short version number.
/// For example "2.0.0".

+ (NSString *) getVersion;


/// Gets the SDK full version number.
/// - Returns: The SDK full version number.
/// For example "2.0.0.21".

+ (NSString *) getFullVersion;


/// Gets the highest Entrust IdentityGuard Self-Service Transaction
/// component API version that is supported by the SDK.
/// - Returns: The highest API version supported by the SDK.

+ (NSString *) getApiVersion;


/// Gets the list of Entrust IdentityGuard Self-Service Transaction
/// component API versions that is supported by the SDK.  These are
/// sorted in descending order.
///
/// API versions supported and their mapping to Entrust IdentityGuard Self-Service Module versions:
/// <ul>
/// <li>4 = 10.2 Patch 184895</li>
/// <li>3 = 10.2</li>
/// <li>2 = 9.3 Patch 160589</li>
/// <li>1 = 9.3</li>
/// </ul>
///
/// - Returns: The array of API versions in descending order.

+ (NSArray *) getAllApiVersions;


/// Gets whether the SDK should attempt to fallback to an older
/// version of the Entrust IdentityGuard Self-Service Transaction
/// Component API.
/// This can be overriden in the ETIdentityProvider class.
/// Defaults to YES.

+ (BOOL) getAutoApiVersionFallback;


/// Sets whether the SDK should attempt to fallback to an older
/// version of the Entrust IdentityGuard Self-Service Transaction
/// Component API.
/// This can be overriden in the ETIdentityProvider class.
/// This does not affect any instances of ETIdentityProvider that
/// have already been created.
/// Defaults to YES.

+ (void) setAutoApiVersionFallback:(BOOL)allowFallback;


/// Checks to see if the device is secure.  It checks for jailbreaking and
/// device rooting on platforms that support these checks.
/// Note: Not supported on Mac OS X.
/// - Returns: True if the device is secure, false otherwise.

+ (BOOL) isDeviceSecure;


/// Sets the device root status. This is helpful if you want your application
/// to perform its own root checking, or to disable checking whether a device
/// is rooted by overriding the root status. When the root status is set to True
/// or False, calls to isDeviceSecure will return that value instead of
/// performing root detection. If the root status has not been set,
/// root checking is performed.
/// YES to Device rooted
/// NO to Device not rooted

+ (void) setDeviceRooted:(BOOL)deviceRooted;


/// Sets the keychain access group that should be used by the SDK
/// when accessing the keychain.  This is useful if keys should be
/// written into a shared access group.  Ensure that you always
/// set the keychain access group to the same value or your data
/// won't be able to be decrypted.  You need to set this each time
/// your application starts up.
/// Note: iOS Only
/// - Parameter accessGroup: The keychain access group identifier.  For
/// example 12319232.com.example.myapp.shared

+ (void) setKeychainAccessGroup:(NSString *)accessGroup;


/// Gets the current keychain access group that will be used by the SDK.
/// Note: iOS Only
/// - Returns: The keychain access group.

+ (NSString *) getKeychainAccessGroup;


/// Sets the custom scheme used to generate app-specific links that should only be handled by the
/// client app. For example, for app-specific links of the form yourcorp://?somedata, yourcorp
/// should be provided as the appScheme.
/// - Parameter appScheme: The appScheme to use and register with IdentityGuard.

+ (void) setApplicationScheme: (NSString *) appScheme;


/// Gets the custom scheme used to generate app-specific links that should only be handled by the
/// client app.
/// - Returns: The appScheme to use and register with IdentityGuard.

+ (NSString *) getApplicationScheme;


/// Gets the accessibility of the keychain item used by the encrypt/decrypt methods of the SDK.
/// This returns the value configured in the SDK and doesn't query the keychain for the current
/// keychain item accessibility.
///
/// By default the value used by the SDK is kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly.
///
/// Note: Applies to iOS only.
/// - Returns: The keychain item accessibility attribute.

+ (CFTypeRef) getKeychainItemAccessibleAttr;


/// Sets the accessibility of the keychain item used by the encrypt/decrypt methods of the SDK.
/// This control when the keys can be accessed and whether they can be restored to another device.
/// See the iOS documentation for kSecAttrAccessible.
///
/// The default value is kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly which means the
/// encryption/MACing keys are available when the device is first unlocked by the user.  This
/// allows applications to run in the background and make use of the encrypt/decrypt functionality.
///
/// If your application does not run in the background or does not need to use the encrypt/decrypt
/// SDK methods while in the background, you can increase security by setting this value to
/// kSecAttrAccessibleWhenUnlockedThisDeviceOnly.
///
/// This should be set before you initialize the SDK each time the application launches.  Changing
/// this value once a key has been generated ([ETSoftTokenSDK initalizeSDK]) will only take effect by calling [ETSoftTokenSDK resetSDK]
/// which will generate a new key and store it with the new accessible attribute.
///
/// Note: Applies to iOS only.
///
/// - Parameter attrAccessible: The kSecAttrAccessible constant representing the key protection mode.

+ (void) setKeychainItemAccessibleAttr:(CFTypeRef)attrAccessible;


/// Sets the keychain entry name that should be used by the SDK
/// when storing the encryption key in the keychain.  Ensure that you
/// always set the keychain access group to the same value or your data
/// won't be able to be decrypted.  You need to set this each time
/// your application starts up.  This defaults to
/// "ETSoftTokenSDK_EncryptionKey" but you can optionally set this to
/// your another value if you so choose.
///
/// Note: Applies to both iOS and Mac OS X.
///
/// - Parameter entryName: The keychain entry name.  For
/// example "ETSoftTokenSDK_EncryptionKey".

+ (void) setKeychainEntryName:(NSString *)entryName;


/// Gets the current keychain service name that will be used by the SDK.
/// Note: Mac OS X Only
/// - Returns: The keychain service name.

+ (NSString *) getKeychainEntryName;


/// Sets the keychain service name that should be used by the SDK
/// when accessing the keychain.  Ensure that you always
/// set the keychain service name to the same value or your data
/// won't be able to be decrypted.  You need to set this each time
/// your application starts up.  This defaults to "Entrust IdentityGuard
/// Mobile SDK" but you should set this to your application name.
///
/// It is highly recommended that you change this value.
///
/// Note: Applies to Mac OS X only.
///
/// - Parameter serviceName: The keychain service name identifier.  For
/// example "Entrust IdentityGuard Mobile SDK"

+ (void) setKeychainServiceName:(NSString *)serviceName;


/// Gets the current keychain service name that will be used by the SDK.
///
/// Note: Applies to Mac OS X only.
///
/// - Returns: The keychain service name.

+ (NSString *) getKeychainServiceName;


/// Sets whether the keychain item will be locked to the current
/// Mac OS X computer hardware.  By default this is set to YES
/// and prevents restoring and decrypting data on another Mac
/// OS X computer.
///
/// This must be set before the SDK is initialized each time the
/// application starts up if you don't want to use the default value.
///
/// To change after the SDK has been initalized, you must reset the SDK
/// which will generate a new encryption key.  All existing encrypted
/// data will unreadable after calling resetSDK.
///
/// Note: Applies to Mac OS X only.  For iOS this is controlled
/// by the accessible attribute methods.
///
/// - Parameter isLocked: Whether or not to lock the keychain item to the
///      current computer.

+ (void) setKeychainItemLockedToHardware:(BOOL)isLocked;


/// Returns whether the keychain item is locked to the current
/// Mac OS X computer hardware.  By default this returns YES.
///
/// Note: Applies to Mac OS X only. For iOS this is controlled
/// by the accessible attribute methods.
///
/// - Returns: Yes if the keychain item is locked to the current
///      Mac OS X computer.

+ (BOOL) isKeychainItemLockedToHardware;


/// Encrypts and MACs the provided data using the device specific key.
/// Your application should configure SDK and initialize the SDK using ``ETSoftTokenSDK/initializeSDK``
/// before calling this method.
///
/// - Parameter plainText: The plaintext data.
/// - Returns: The encrypted data.

+ (NSData *) encryptData:(NSData *)plainText;


/// Decrypts and validates the MAC of the provided data using the device specific key.
/// Your application should configure SDK and initialize the SDK using ``ETSoftTokenSDK/initializeSDK``
/// before calling this method.
///
/// - Parameter encrypted: The encrypted data.
/// - Returns: The plaintext data.

+ (NSData *) decryptData:(NSData *)encrypted;


/// Encrypts and MACs the provided string using the device specific key.
/// Your application should configure SDK and initialize the SDK using ``ETSoftTokenSDK/initializeSDK``
/// before calling this method.
///
/// - Parameter plainText: The plaintext string.
/// - Returns: The encrypted data in string format (base64)

+ (NSString *) encryptString:(NSString *)plainText;


/// Decrypts and validates the MAC of the provided string using the device specific key.
/// Your application should configure SDK and initialize the SDK using ``ETSoftTokenSDK/initializeSDK``
/// before calling this method.
///
/// - Parameter encrypted: The encrypted string.
/// - Returns: The plaintext string.

+ (NSString *) decryptString:(NSString *)encrypted;


/// Return the platform this class was implemented for. For example,
/// IPHONE, MACOSX

+ (NSString *) getPlatform;


/// Get the application version. If this is not set with ``ETSoftTokenSDK/setApplicationVersion:``,
/// a default version string is returned.
///
/// - Returns: the application version.

+ (NSString *) getApplicationVersion;


/// Set the application version. This is used when registering an Identity
/// with the transaction service, for informational purposes.
///
/// - Parameter version:
///   The application version. For example, "1.1" or "Banking app 2.5"

+ (void) setApplicationVersion:(NSString *)version;


/// Get the application identifier used for sending push notifications.
/// This is used by Self-Service Module to determine which mobile
/// application it is sending notifications to.  For example:
/// com.example.myapp
///
/// - Returns: the application identifier

+ (NSString *) getApplicationId;


/// Sets the application identifier used for sending push notifications.
/// This is used by Self-Service Module to determine which mobile
/// application it is sending notifications to.  For example:
/// com.example.myapp
///
/// - Parameter appId: the application identifier

+ (void) setApplicationId:(NSString *)appId;


/// Sets the log level for the SDK.
///
/// - Parameter level: The log level for the SDK.

+ (void) setLogLevel:(ETLogLevel)level;


/// Gets the log level for the SDK.
///
/// - Returns: The log level for the SDK.

+ (ETLogLevel) getLogLevel;


/// Logs the given message if the log level is set to ``ETLogLevel/ETLogLevelError`` or above.
/// - Parameter message: The message to log.

+ (void) logError:(NSString *)message;


/// Logs the given message if the log level is set to ``ETLogLevel/ETLogLevelInfo`` or above.
/// - Parameter message: The message to log.

+ (void) logInfo:(NSString *)message;



/// Logs the given message if the log level is set to ``ETLogLevel/ETLogLevelWarning`` or above.
/// - Parameter message: The message to log.

+ (void) logWarning:(NSString *)message;


/// Logs the given message if the log level is set to ``ETLogLevel/ETLogLevelDebug`` or above.
///
/// - Parameter message: The message to log.

+ (void) logDebug:(NSString *)message;


/// Logs the given message as long as logging isn't set to ``ETLogLevel/ETLogLevelOff``.
///
/// - Parameter message: The message to log.

+ (void) logAlways:(NSString *)message;


/// Returns the current logger implementation.
///
/// - Returns: The current logger implementation.

+ (id<ETLogger>) getLogger;


/// Sets the logger implemenation.
///
/// - Parameter logger: The logger implementation.

+ (void) setLogger:(id<ETLogger>)logger;


/// Sets the HTTP communication callback implementation.
///
/// - Parameter commCallback: The ETCommCallback implementation.

+ (void) setCommCallback:(id<ETCommCallback>)commCallback;


/// Return an HTTP communication callback implementation.
///
/// - Returns: The ETCommCallback implementation.

+ (id<ETCommCallback>) getCommCallback;


/// Returns the launch URL parameters out of the given URL.
///
/// - Parameter launchUrl: The URL that launched the application.
/// - Returns: A subclass of ETLaunchUrlParameters such as ETActivationLaunchUrlParams

+ (ETLaunchUrlParams *) parseLaunchUrl:(NSURL *)launchUrl;


/// Returns the notifications parameters out of the given push notification.
///
/// - Parameter notification: The push notification that was received.
/// - Returns: A subclass of ETNotificationParameters such as ETTransactionNotificationParams

+ (ETNotificationParams *) parseNotification:(NSDictionary *)notification;


/// Sets the minimum SSL protocol version that is supported by the default
/// ``ETCommCallback`` implementation included with the SDK.  This
/// configuration only affects iOS 7 and later and Mac OS X 10.9 and later.
/// The default value for the minimum protocol is TLS 1.0.
///
/// - Parameter version: The SSLProtocol version to use as the minimum.
/// @note setMinimumSSLProtocol is deprecated. Use `setMinimumSSLProtocolVersion` instead.

+ (void) setMinimumSSLProtocol:(SSLProtocol)version API_DEPRECATED_WITH_REPLACEMENT("setMinimumSSLProtocolVersion:", macos(10.2, 10.15), ios(5.0, 13.0));


/// Sets the minimum SSL protocol version that is supported by the default
/// ``ETCommCallback`` implementation included with the SDK.  This
/// configuration only affects iOS 13 and later and Mac OS X 10.15 and later.
/// The default value for the minimum protocol is TLS 1.0.
///
/// - Parameter version: The tls_protocol_version_t version to use as the minimum.

+ (void) setMinimumSSLProtocolVersion:(tls_protocol_version_t)version API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0));


/// Gets the minimum SSL protocol version that is supported by the default
/// ``ETCommCallback`` implementation included with the SDK.  This
/// configuration only affects iOS 7 and later and Mac OS X 10.9 and later.
/// The default value for the minimum protocol is TLS 1.0.
///
/// - Returns: The SSLProtocol version to use as the minimum.
/// @note This getMinimumSSLProtocol is deprecated. Use `getMinimumSSLProtocolVersion` instead.

+ (SSLProtocol) getMinimumSSLProtocol API_DEPRECATED_WITH_REPLACEMENT("getMinimumSSLProtocolVersion", macos(10.2, 10.15), ios(5.0, 13.0));


/// Gets the minimum SSL protocol version that is supported by the default
/// ``ETCommCallback`` implementation included with the SDK.  This
/// configuration only affects iOS 7 and later and Mac OS X 10.9 and later.
/// The default value for the minimum protocol is TLS 1.0.
///
/// - Returns: The tls_protocol_version_t version to use as the minimum.

+ (tls_protocol_version_t) getMinimumSSLProtocolVersion API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0));


/// Returns whether a minimum SSL protocol was set by the calling application.
///
/// - Returns: Whether a minimum SSL protocol was set by the calling application.

+ (BOOL) minimumSSLProtocolWasSet;


/// Sets the maximum SSL protocol version that is supported by the default
/// ``ETCommCallback`` implementation included with the SDK.  This
/// configuration only affects iOS 7 and later and Mac OS X 10.9 and later.
/// If a value isn't explicitly set, it will use the latest version available
/// on the operating system.  Currently this is TLS 1.2.
///
/// - Parameter version: The SSLProtocol version to use as the maximum.
/// @note setMaximumSSLProtocol is deprecated. Use  `setMaximumSSLProtocol` instead.

+ (void) setMaximumSSLProtocol:(SSLProtocol)version API_DEPRECATED_WITH_REPLACEMENT("setMaximumSSLProtocolVersion:", macos(10.2, 10.15), ios(5.0, 13.0));



/// Sets the maximum SSL protocol version that is supported by the default
/// ``ETCommCallback`` implementation included with the SDK.  This
/// configuration only affects iOS 7 and later and Mac OS X 10.9 and later.
/// If a value isn't explicitly set, it will use the latest version available
/// on the operating system.  Currently this is TLS 1.3.
///
/// - Parameter version: The tls_protocol_version_t version to use as the maximum.

+ (void) setMaximumSSLProtocolVersion:(tls_protocol_version_t)version API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0));


/// Gets the maximum SSL protocol version that is supported by the default
/// ``ETCommCallback`` implementation included with the SDK.  This
/// configuration only affects iOS 7 and later and Mac OS X 10.9 and later.
/// If a value isn't explicitly set, it will use the latest version available
/// on the operating system.  Currently this is TLS 1.2.
///
/// - Returns: The SSLProtocol version to use as the maximum.
/// @note getMaximumSSLProtocol is deprecated. Use `getMaximumSSLProtocolVersion` instead.
/// @since 2.1.0

+ (SSLProtocol) getMaximumSSLProtocol API_DEPRECATED_WITH_REPLACEMENT("getMaximumSSLProtocolVersion", macos(10.2, 10.15), ios(5.0, 13.0));


/// Gets the maximum SSL protocol version that is supported by the default
/// ``ETCommCallback`` implementation included with the SDK.  This
/// configuration only affects iOS 7 and later and Mac OS X 10.9 and later.
/// If a value isn't explicitly set, it will use the latest version available
/// on the operating system.  Currently this is TLS 1.3.
///
/// - Returns: The tls_protocol_version_t version to use as the maximum.
/// @since 3.7.1

+ (tls_protocol_version_t) getMaximumSSLProtocolVersion API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0));



/// Returns whether a maximim SSL protocol was set by the calling application.
///
/// - Returns: Whether a maximum SSL protocol was set by the calling application.

+ (BOOL) maximumSSLProtocolWasSet;


/// Return the parse result of a mobile security profile
///
/// - Parameter securityPolicyString: the mobile securiy string fetched from the server.
/// - Returns: the dictionary with security policy details.

+ (NSDictionary *) parseSecurityPolicyString:(NSString *)securityPolicyString;


///  Initialize the Face Recognition SDK.
///
///  Initialization is successful when appropriate face recognition frameworks is available and
///      Identity provider is reachable and at least one of the identities in the given list allows
///      face recognition by policy and holds a valid license.
///      If the identity provider is not reachable and the identities list has at least one
///      identity with face recognition flag set to true
///
///  - Parameter txnUrl: identity provider address
///  - Parameter identities: array of soft token identities
///  - Parameter errorPtr: holds the error during operation
///  - Returns: the identities list flagged with face recognition offline validation
///          if initialization was succesful, nil if failed.

+(NSArray*) initializeFaceRecognitionLicense:(NSString*) txnUrl forTokens:(NSArray*) identities
                                       error:(NSError**) errorPtr;


///  Returns the FPBMatcherLicenseManager instance if {@link initializeFaceRecognitionLicenses}
///  was invoked without any errors. Used for face recognition.
///
///  - Returns: FPBMatcherLicenseManager instance, null if no instance found

+ (id) getFPBMatcherLicenseManager;

@end
