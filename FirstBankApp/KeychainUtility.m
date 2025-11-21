//
//  KeychainUtility.m
//  FirstBankApp
//
//  Created by cbc gedu on 11/11/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "KeychainUtility.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h> 

@interface KeychainUtility ()
// Helper method to create the base query dictionary
+ (NSMutableDictionary *)baseQueryForKey:(NSString *)key;

@end

@implementation KeychainUtility

+ (NSMutableDictionary *)baseQueryForKey:(NSString *)key {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
            key, (__bridge id)kSecAttrService,
            @"UserAccount", (__bridge id)kSecAttrAccount, // Consistent account name
            nil];
}
//+ (BOOL)storeValue:(NSString *)value forKey:(NSString *)key {
//    NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSDictionary *query = @{
//        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
//        (__bridge id)kSecAttrService: key,
//        (__bridge id)kSecAttrAccount: @"UserAccount", // Use a generic account or unique ID
//        (__bridge id)kSecValueData: valueData,
//        (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly // Highly secure
//    };
//}
    
    + (BOOL)addValue:(NSString *)value forKey:(NSString *)key {
        NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];

        // 1. Create the base query dictionary
        NSMutableDictionary *query = [self baseQueryForKey:key];
        
        // 2. Add the data and accessibility attributes for adding
        [query setObject:valueData forKey:(__bridge id)kSecValueData];
        // Highly secure setting: available only after first device unlock.
        [query setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];

        // Attempt to add the new item
        OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
        
        if (status != errSecSuccess) {
            if (status == errSecDuplicateItem) {
                NSLog(@"Keychain Error: Item already exists for key %@. Use updateValue:forKey:", key);
            } else {
                NSLog(@"Keychain Error: Failed to add value for key %@, Status: %d", key, (int)status);
            }
        }
        return status == errSecSuccess;
    }

    
#pragma mark - Update

+ (BOOL)updateValue:(NSString *)value forKey:(NSString *)key {
    NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];

    // 1. Define the item to match (the query)
    NSDictionary *query = [self baseQueryForKey:key];

    // 2. Define the attributes to update
    NSDictionary *attributesToUpdate = @{
        (__bridge id)kSecValueData: valueData
    };

    // Attempt to update the existing item
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributesToUpdate);
    
    if (status != errSecSuccess) {
        if (status == errSecItemNotFound) {
            NSLog(@"Keychain Error: Item not found for key %@. Use addValue:forKey: instead of update.", key);
        } else {
            NSLog(@"Keychain Error: Failed to update value for key %@, Status: %d", key, (int)status);
        }
    }
    return status == errSecSuccess;
}

+ (NSString *)retrieveValueForKey:(NSString *)key {
    // 1. Define the item to match (the query)
    NSMutableDictionary *query = [self baseQueryForKey:key];
    
    // 2. Add retrieval attributes
    [query setObject:@YES forKey:(__bridge id)kSecReturnData];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];

    CFTypeRef item = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &item);

    if (status == errSecSuccess) {
        NSData *valueData = (__bridge NSData *)item;
        NSString *value = [[NSString alloc] initWithData:valueData encoding:NSUTF8StringEncoding];
        if (item) CFRelease(item);
        return value;
    } else if (status != errSecItemNotFound) {
        NSLog(@"Keychain Error: Failed to retrieve value for key %@, Status: %d", key, (int)status);
    }
    
    // Handles errSecItemNotFound and other errors
    return nil;
}
//    // Delete existing item if it exists
//    SecItemDelete((__bridge CFDictionaryRef)query);
//
//    // Add the new item
//    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
//    
//    if (status != errSecSuccess) {
//        NSLog(@"Keychain Error: Failed to store PIN for key %@, Status: %d", key, (int)status);
//    }
//    return status == errSecSuccess;
//}



+ (NSString *)hashString:(NSString *)inputString {
    if (!inputString || inputString.length == 0) {
        return nil;
    }
    
    // Standard procedure to convert string to C string for hashing
    const char *cString = [inputString UTF8String];
    CC_LONG length = (CC_LONG)strlen(cString);
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    
    // Perform the SHA-256 calculation
    CC_SHA256(cString, length, digest);
    
    // Convert the 32-byte digest into a 64-character hex string
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return [NSString stringWithString:output];
}



+ (BOOL)deleteValueForKey:(NSString *)key {
    // 1. Define the item to match (the query)
    NSDictionary *query = [self baseQueryForKey:key];

    // Attempt to delete the existing item
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    
    if (status != errSecSuccess && status != errSecItemNotFound) {
        NSLog(@"Keychain Error: Failed to delete item for key %@, Status: %d", key, (int)status);
    }
    
    // Returns YES if successful or if the item wasn't found (it's already deleted)
    return status == errSecSuccess || status == errSecItemNotFound;
}

@end
