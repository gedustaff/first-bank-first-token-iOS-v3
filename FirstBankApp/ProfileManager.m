//
//  ProfileManager.m
//  FirstBankApp
//
//  Created by cbc gedu on 11/11/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "ProfileManager.h"
#import "KeychainUtility.h" // Required for secure PIN checks
#import <CommonCrypto/CommonCrypto.h>

//const int kPBKDF2SaltLengths = 16;      // same as you used
//static const int kPBKDF2KeyLengths = 32;
//static const int kPBKDF2Iterationss = 100000;

// Key used to store the ARRAY of profiles in NSUserDefaults (LESS sensitive data)
NSString *const kUserProfileKey = @"com.gedu.FirstBankProfiles";

// Key used to store the PIN hash in the Keychain (HIGHLY sensitive data)
 NSString *const kPinAccessKey = @"UserAPPCenterPinHash";



 // match your setup

@implementation ProfileManager

+ (NSMutableArray<NSDictionary *> *)loadProfiles {
    NSArray *storedArray = [[NSUserDefaults standardUserDefaults] arrayForKey:kUserProfileKey];
    // Return a mutable copy so we can add new profiles to it
    if (storedArray) {
        return [storedArray mutableCopy];
    }
    return [NSMutableArray array]; // Return an empty mutable array if none exist
}

+ (void)saveNewProfile:(NSDictionary *)newProfile {
    // 1. Load existing profiles
    NSMutableArray *profiles = [self loadProfiles];
    
    // 2. Add the new profile
    [profiles addObject:newProfile];
    
    // 3. Save the updated array back to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:profiles forKey:kUserProfileKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"Profiles saved. Total profiles: %lu", (unsigned long)profiles.count);
    
    // CRITICAL FIX: Removed the insecure and buggy call to [self setPinStatus:YES];
    // PIN setup must be handled separately by saving the hash via KeychainUtility.
}

#pragma mark - Conditional Flow Checks

// DELETED: + (void)setPinStatus:(BOOL)isSet - Removed as it was insecure and buggy.
// PIN status is now managed exclusively by the Keychain.


+ (BOOL)setPin:(NSString *)pin {
    // SECURITY BEST PRACTICE: NEVER store the raw PIN. Hash it first.
    // This assumes KeychainUtility has a secure hashing method (e.g., SHA-256).
    NSString *pinHash = [KeychainUtility hashString:pin];
    
    if (!pinHash || pinHash.length == 0) {
        NSLog(@"[Security Error] Failed to generate PIN hash for storage.");
        return NO;
    }

    // Store the hash securely in the Keychain.
    BOOL success = [KeychainUtility addValue:pinHash forKey:kPinAccessKey];
    
    if (success) {
        NSLog(@"[ProfileManager] New PIN hash successfully stored in Keychain.");
    } else {
        NSLog(@"[ProfileManager Error] Failed to store PIN hash in Keychain.");
    }
    return success;
}


+ (BOOL)verifyPin:(NSString *)enteredPin withStoredHash:(NSString *)storedBase64 {
    NSData *combinedData = [[NSData alloc] initWithBase64EncodedString:storedBase64 options:0];
    if (combinedData.length < kPBKDF2SaltLength + kPBKDF2KeyLength) {
        NSLog(@"Invalid stored hash length");
        return NO;
    }

    // Extract salt and stored derived key
    NSData *salt = [combinedData subdataWithRange:NSMakeRange(0, kPBKDF2SaltLength)];
    NSData *storedDerivedKey = [combinedData subdataWithRange:NSMakeRange(kPBKDF2SaltLength, kPBKDF2KeyLength)];

    // Derive key from entered PIN using the same parameters
    NSData *pinData = [enteredPin dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *derivedKey = [NSMutableData dataWithLength:kPBKDF2KeyLength];
    int status = CCKeyDerivationPBKDF(kCCPBKDF2,
                                      pinData.bytes,
                                      pinData.length,
                                      salt.bytes,
                                      salt.length,
                                      kCCPRFHmacAlgSHA256,
                                      kPBKDF2Iterations,
                                      derivedKey.mutableBytes,
                                      derivedKey.length);

    if (status != kCCSuccess) {
        NSLog(@"PBKDF2 verification failed: %d", status);
        return NO;
    }

    // Compare derived key to stored key
    return [storedDerivedKey isEqualToData:derivedKey];
}



+ (BOOL)hasSavedProfiles {
    return [[self loadProfiles] count] > 0;
}

+ (BOOL)isPinSet {
    // SECURITY FIX: Check for the presence of the PIN hash in the Keychain.
    NSString *storedPinHash = [KeychainUtility retrieveValueForKey:kPinAccessKey];
    
    if (storedPinHash && storedPinHash.length > 0) {
        NSLog(@"PIN Check: PIN hash found in Keychain (Secure).");
        return YES;
    } else {
        NSLog(@"PIN Check: PIN hash NOT found in Keychain (Secure).");
        return NO;
    }
}

+ (BOOL)clearPin {
    // SECURITY FIX: Delete the PIN data from the Keychain.
    // NOTE: This assumes you have added the + (BOOL)deleteValueForKey:(NSString *)key
    // method to your KeychainUtility.m implementation.
    BOOL success = [KeychainUtility deleteValueForKey:kPinAccessKey];
    
    if (success) {
        NSLog(@"PIN successfully cleared from Keychain.");
    } else {
        NSLog(@"Failed to clear PIN from Keychain.");
    }
    return success;
}

@end
