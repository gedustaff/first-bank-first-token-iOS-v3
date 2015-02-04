//
//  SDKUtils.h
//  Entrust IdentityGuard Mobile SDK
//  Command Line Example
//
//  Copyright (c) 2013 Entrust, Inc. All rights reserved.
//  Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
//

#import <Foundation/Foundation.h>
#import "ETIdentity.h"
#import "ETConfigurationFile.h"

@interface SDKUtils : NSObject

/**
 * Display a prompt and ask the user to answer yes or no.
 * @param question The question to display.  This will append (y/n) at the end.
 * @return YES if the user entered yes or NO if the user entered no.
 */
+ (BOOL) askYesNoQuestion:(NSString *) question;

/**
 * Display a prompt and wait for a response.
 * @param prompt The question to display.
 * @param maxLength How much data to read in.
 * @return The user response.
 */
+ (NSString *) promptForString:(NSString *)prompt maxLength:(int)maxLength;

/**
 * Prompt the user for an identity provider address
 * and fetch the configuration file from that address.
 * @param optional True if the user can skip this step.
 * @return The parsed configuration file object or nil.
 */
+ (ETConfigurationFile *) promptAndFetchIdentityProviderAddressAndIsOptional:(BOOL)optional;

/**
 * Gets the file name where the soft token identity will be stored.
 * @return The file name where the soft token identity will be stored.
 */
+ (NSString *)getIdentityFileName;
+ (NSString *)getPINFileName;
+ (NSString *)getLockFileName;

/**
 * Saves the current identity to disk.
 * @param identity The identity to save.
 * @return YES on success, NO otherwise.
 */
+ (BOOL) saveIdentity:(ETIdentity *)identity;
+ (BOOL) savePIN:(NSString *)pin;
+ (BOOL) saveLockState:(NSString *)pin;

/**
 * Loads the identity from disk.
 * @return The identity from disk or nil if no identity exists.
 */
+ (ETIdentity *)loadIdentity;
+ (NSString *)retrievePIN;
+ (NSString *)fetchLockState;

/**
 * Deletes the current identity file from disk.
 * @return YES on success, false otherwise.
 */
+ (BOOL) deleteIdentityFile;
+ (BOOL) deletePIN;
+ (BOOL) deleteLockState;


/**
 * Store the transaction url in the user defaults.
 * Note: You could save this in your identity file.
 * @param url The transaction URL.
 */
+ (void) saveTransactionUrl:(NSString *)url;

/**
 * Load the transaction url from the user defaults.
 * @return The transaction URL.
 */
+ (NSString *)loadTransactionUrl;

@end
