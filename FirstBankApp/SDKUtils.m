//
//  SDKUtils.m
//  Entrust IdentityGuard Mobile SDK
//  Command Line Example
//
//  Copyright (c) 2013 Entrust, Inc. All rights reserved.
//  Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
//

#import "SDKUtils.h"
#import "ETConfigurationFile.h"
#import "ETIdentityProvider.h"
#import "ETSoftTokenSDK.h"

#define kFileName @"FBIdentityFirstToken123KGH"
#define kFileNameB @"FBPINFirstToken459SVX"
#define kFileNameC @"FBlockFirstToken695KLR"
#define kDefaultsKeyTransactionUrl @"transactionUrl"

@implementation SDKUtils

static NSString *dataFileName, *dataFileNameB, *dataFileNameC;

/**
 * Display a prompt and ask the user to answer yes or no.
 * @param question The question to display.  This will append (y/n) at the end.
 * @return YES if the user entered yes or NO if the user entered no.
 */
+ (BOOL) askYesNoQuestion:(NSString *) question
{
    while (true) {
        NSString *response = [[self promptForString:[NSString stringWithFormat:@"%@ (y/n):", question] maxLength:10] lowercaseString];
        if ([response isEqualToString:@"y"] || [response isEqualToString:@"yes"]) {
            return YES;
        } else if ([response isEqualToString:@"n"] || [response isEqualToString:@"no"]) {
            return NO;
        }
    }
}

/**
 * Display a prompt and wait for a response.
 * @param prompt The question to display.
 * @param maxLength How much data to read in.
 * @return The user response.
 */
+ (NSString *) promptForString:(NSString *)prompt maxLength:(int)maxLength
{
    if (maxLength == 0) maxLength = 100;
    char buf[maxLength];
    printf("%s\n", [prompt UTF8String]);
    fgets(buf, sizeof(buf)-1, stdin);
    // Get rid of any extra data in stdin
    fpurge(stdin);
    
    // Trim trailing newline. The validation method assumes
    // whitespace has been stripped.
    if (buf[strlen(buf)-1] == '\n') {
        buf[strlen(buf)-1] = '\0';
    }
    
    NSString *response = [NSString stringWithCString:buf encoding:NSASCIIStringEncoding];
    if ([[response lowercaseString] isEqualToString:@"exit"] || [[response lowercaseString] isEqualToString:@"quit"]) {
        exit(0);
    }
    return response;
}

/**
 * Prompt the user for an identity provider address
 * and fetch the configuration file from that address.
 * @param optional True if the user can skip this step.
 * @return The parsed configuration file object or nil.
 */
+ (ETConfigurationFile *) promptAndFetchIdentityProviderAddressAndIsOptional:(BOOL)optional
{
    BOOL addressOk = NO;
    NSString *addressString = nil;
    while (!addressOk) {
        NSString *prompt = [NSString stringWithFormat:@"Please enter the identity provider address (e.g. example.com:8445/igst)%@:", optional? @"\nor 'skip' to skip this step" : @""];
        addressString = [SDKUtils promptForString:prompt maxLength:100];
        if (optional && [[addressString lowercaseString] isEqualToString:@"skip"]) {
            return nil;
        }
        NSError *fetchError;
        ETConfigurationFile *config = [ETIdentityProvider fetchConfigurationFile:addressString callback:nil error:&fetchError];
        if (config == nil) {
            printf("The identity provider configuration could not be fetched from %s.\n", [addressString UTF8String]);
            if (fetchError != nil) {
                printf("Error: %s\n", [[fetchError localizedDescription] UTF8String]);
            }
        }
        return config;
    }
    return nil;
}


/**
 * Gets the file name where the soft token identity will be stored.
 * @return The file name where the soft token identity will be stored.
 */
+ (NSString *)getIdentityFileName
{
    if (dataFileName == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        dataFileName = [documentsDirectory stringByAppendingPathComponent:kFileName];
    }
    return dataFileName;
}

+ (NSString *)getPINFileName
{
    if (dataFileNameB == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        dataFileNameB = [documentsDirectory stringByAppendingPathComponent:kFileNameB];
    }
    return dataFileNameB;
}


+ (NSString *)getLockFileName
{
    if (dataFileNameC == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        dataFileNameC = [documentsDirectory stringByAppendingPathComponent:kFileNameC];
    }
    return dataFileNameC;
}

/**
 * Saves the current identity to disk.
 * @param identity The identity to save.
 * @return YES on success, NO otherwise.
 */
+ (BOOL) saveIdentity:(ETIdentity *)identity
{
    NSData *serialized = [NSKeyedArchiver archivedDataWithRootObject:identity];
    NSData *encrypted = [ETSoftTokenSDK encryptData:serialized];
    return [encrypted writeToFile:[SDKUtils getIdentityFileName] atomically:YES];
}


+ (BOOL) savePIN:(NSString *)pin
{
    NSData *serialized = [NSKeyedArchiver archivedDataWithRootObject:pin];
    NSData *encrypted = [ETSoftTokenSDK encryptData:serialized];
    return [encrypted writeToFile:[SDKUtils getPINFileName] atomically:YES];
}


+ (BOOL) saveLockState:(ETIdentity *)identity
{
    NSData *serialized = [NSKeyedArchiver archivedDataWithRootObject:identity];
    NSData *encrypted = [ETSoftTokenSDK encryptData:serialized];
    return [encrypted writeToFile:[SDKUtils getLockFileName] atomically:YES];
}


/**
 * Loads the identity from disk.
 * @return The identity from disk or nil if no identity exists.
 */
+ (ETIdentity *)loadIdentity
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[SDKUtils getIdentityFileName]]) {
        return nil;
    }
    //printf("File: %s\n", [[SDKUtils getIdentityFileName] UTF8String]);
    NSData *encrypted = [[NSData alloc] initWithContentsOfFile:[SDKUtils getIdentityFileName]];
    NSData *serialized = [ETSoftTokenSDK decryptData:encrypted];
    return [NSKeyedUnarchiver unarchiveObjectWithData:serialized];
}

/**
 * Loads the PIN from disk.
 * @return The PIN from disk or nil if no identity exists.
 */
+ (NSString *)retrievePIN
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[SDKUtils getPINFileName]]) {
        return nil;
    }
    //printf("File: %s\n", [[SDKUtils getIdentityFileName] UTF8String]);
    NSData *encrypted = [[NSData alloc] initWithContentsOfFile:[SDKUtils getPINFileName]];
    NSData *serialized = [ETSoftTokenSDK decryptData:encrypted];
    return [NSKeyedUnarchiver unarchiveObjectWithData:serialized];
}

+ (NSString *)fetchLockState
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[SDKUtils getLockFileName]]) {
        return nil;
    }
    //printf("File: %s\n", [[SDKUtils getIdentityFileName] UTF8String]);
    NSData *encrypted = [[NSData alloc] initWithContentsOfFile:[SDKUtils getLockFileName]];
    NSData *serialized = [ETSoftTokenSDK decryptData:encrypted];
    return [NSKeyedUnarchiver unarchiveObjectWithData:serialized];
}

/**
 * Deletes the current identity file from disk.
 * @return YES on success, false otherwise.
 */
+ (BOOL) deleteIdentityFile
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[SDKUtils getIdentityFileName]]) {
        //printf("Removed existing identity state file.\n\n");
        return [[NSFileManager defaultManager] removeItemAtPath:[SDKUtils getIdentityFileName] error:nil];
    }
    return NO;
}

+ (BOOL) deletePIN
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[SDKUtils getPINFileName]]) {
        //printf("Removed existing identity state file.\n\n");
        return [[NSFileManager defaultManager] removeItemAtPath:[SDKUtils getPINFileName] error:nil];
    }
    return NO;
}


+ (BOOL) deleteLockState
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[SDKUtils getLockFileName]]) {
        //printf("Removed existing identity state file.\n\n");
        return [[NSFileManager defaultManager] removeItemAtPath:[SDKUtils getLockFileName] error:nil];
    }
    return NO;
}


/**
 * Store the transaction url in the user defaults.
 * Note: You could save this in your identity file.
 * @param url The transaction URL.
 */
+ (void) saveTransactionUrl:(NSString *)url
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[ETSoftTokenSDK encryptData:[url dataUsingEncoding:NSUTF8StringEncoding]] forKey:kDefaultsKeyTransactionUrl];
    [defaults synchronize];
}

/**
 * Load the transaction url from the user defaults.
 * @return The transaction URL.
 */
+ (NSString *)loadTransactionUrl
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [ETSoftTokenSDK decryptData:[defaults objectForKey:kDefaultsKeyTransactionUrl]];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}



@end
