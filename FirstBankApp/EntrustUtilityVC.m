//
//  EntrustUtilityVC.m
//  FirstBankApp
//
//  Created by cbc gedu on 07/11/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "EntrustUtilityVC.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonRandom.h>


@interface EntrustUtilityVC ()

@end

@implementation EntrustUtilityVC
+ (instancetype)sharedInstance {
    static EntrustUtilityVC *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EntrustUtilityVC alloc] init];
        [sharedInstance loadSavedEnrollmentData];
    });
    return sharedInstance;
}


//- (void)saveEnrollmentDataWithEmail:(NSString *)email
//                       enrollmentId:(NSString *)enrollmentId
//                    referenceNumber:(NSString *)referenceNumber
////                           platform:(NSString *)platform
////                           username:(NSString *)username
////                   organizationName:(NSString *)organizationName
//
//{
//    self.email = email;
//    self.enrollmentId = enrollmentId;
//    self.referenceNumber = referenceNumber;
////    self.organizationName=organizationName;
////    self.platform=platform;
////    self.username=username;
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:email forKey:@"email"];
//    [defaults setObject:enrollmentId forKey:@"enrollmentId"];
//    [defaults setObject:referenceNumber forKey:@"referenceNumber"];
////    [defaults setObject:organizationName forKey:@"organizationName"];
////    [defaults setObject:username forKey:@"username"];
////    [defaults setObject:platform forKey:@"platform"];
//    [defaults synchronize];
//    
//    NSLog(@"Enrollment data saved");
//}


- (void)saveEnrollmentDataWithEmail:(NSString *)email
                       enrollmentId:(NSString *)enrollmentId
                    referenceNumber:(NSString *)referenceNumber {
    self.email = email;
    self.enrollmentId = enrollmentId;
    self.referenceNumber = referenceNumber;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:email forKey:@"email"];
    [defaults setObject:enrollmentId forKey:@"enrollmentId"];
    [defaults setObject:referenceNumber forKey:@"referenceNumber"];
    [defaults synchronize];
    
    NSLog(@"Enrollment data saved securely (non-sensitive).");
}

- (void)loadSavedEnrollmentData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.email = [defaults stringForKey:@"email"];
    self.enrollmentId = [defaults stringForKey:@"enrollmentId"];
    self.referenceNumber = [defaults stringForKey:@"referenceNumber"];
    
    NSLog(@"Loaded saved enrollment data: %@ / %@ / %@", self.email, self.enrollmentId, self.referenceNumber);
}


#pragma mark - Public Secure PIN Methods (AES + Keychain)

- (BOOL)saveSecurePIN:(NSString *)pin {
    if (!pin) return NO;
    NSData *pinData = [pin dataUsingEncoding:NSUTF8StringEncoding];
    
    // 1) Ensure AES key exists (create if not)
    NSData *aesKey = [self getAESKeyFromKeychain];
    if (!aesKey) {
        aesKey = [self generateRandomDataOfLength:kCCKeySizeAES256];
        if (!aesKey) {
            NSLog(@"Failed to generate AES key");
            return NO;
        }
        BOOL keySaved = [self storeAESKeyToKeychain:aesKey];
        if (!keySaved) {
            NSLog(@"Failed to save AES key to Keychain");
            return NO;
        }
    }
    
    // 2) Generate random IV
    NSData *iv = [self generateRandomDataOfLength:kCCBlockSizeAES128];
    if (!iv) {
        NSLog(@"Failed to generate IV");
        return NO;
    }
    
    // 3) Encrypt
    NSData *cipher = [self aesEncryptData:pinData key:aesKey iv:iv];
    if (!cipher) {
        NSLog(@"AES encryption failed");
        return NO;
    }
    
    // 4) Store iv || cipher in Keychain (overwrite if exists)
    NSMutableData *storeData = [NSMutableData dataWithData:iv];
    [storeData appendData:cipher];
    
    BOOL saved = [self storeEncryptedPinData:storeData];
    if (!saved) {
        NSLog(@"Failed to store encrypted PIN");
        return NO;
    }
    
    NSLog(@" PIN encrypted and saved to Keychain (double-layer)");
    return YES;
}



- (nullable NSString *)retrieveSecurePIN {
    NSData *stored = [self getEncryptedPinDataFromKeychain];
    if (!stored || stored.length <= kCCBlockSizeAES128) {
        NSLog(@"No encrypted PIN data found");
        return nil;
    }
    
    // Separate IV and ciphertext
    NSData *iv = [stored subdataWithRange:NSMakeRange(0, kCCBlockSizeAES128)];
    NSData *cipher = [stored subdataWithRange:NSMakeRange(kCCBlockSizeAES128, stored.length - kCCBlockSizeAES128)];
    
    NSData *aesKey = [self getAESKeyFromKeychain];
    if (!aesKey) {
        NSLog(@"AES key not found in Keychain");
        return nil;
    }
    
    NSData *plainData = [self aesDecryptData:cipher key:aesKey iv:iv];
    if (!plainData) {
        NSLog(@"AES decryption failed");
        return nil;
    }
    
    NSString *pin = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    return pin;
}

- (void)clearSecurePIN {
    // delete PIN item
    NSDictionary *pinQuery = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: @"com.firstbankapp.securepin",
        (__bridge id)kSecAttrAccount: @"user_pin"
    };
    SecItemDelete((__bridge CFDictionaryRef)pinQuery);
    
    // delete AES key
    NSDictionary *keyQuery = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassKey,
        (__bridge id)kSecAttrApplicationTag: [@"com.firstbankapp.aeskey" dataUsingEncoding:NSUTF8StringEncoding]
    };
    // Some implementations store key as generic password; we remove both possibilities:
    SecItemDelete((__bridge CFDictionaryRef)keyQuery);
    NSDictionary *keyQuery2 = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: @"com.firstbankapp.aeskey",
        (__bridge id)kSecAttrAccount: @"aes_key"
    };
    SecItemDelete((__bridge CFDictionaryRef)keyQuery2);
    
    NSLog(@"Cleared secure PIN and AES key from Keychain");
}




#pragma mark - Keychain helpers for AES key & PIN storage

- (BOOL)storeAESKeyToKeychain:(NSData *)keyData {
    if (!keyData) return NO;
    // try to remove existing first
    NSDictionary *delQuery = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: @"com.firstbankapp.aeskey",
        (__bridge id)kSecAttrAccount: @"aes_key"
    };
    SecItemDelete((__bridge CFDictionaryRef)delQuery);
    
    NSDictionary *add = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: @"com.firstbankapp.aeskey",
        (__bridge id)kSecAttrAccount: @"aes_key",
        (__bridge id)kSecValueData: keyData,
        (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly
    };
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)add, NULL);
    return (status == errSecSuccess);
}



- (nullable NSData *)getAESKeyFromKeychain {
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: @"com.firstbankapp.aeskey",
        (__bridge id)kSecAttrAccount: @"aes_key",
        (__bridge id)kSecReturnData: @YES,
        (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitOne
    };
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (status == errSecSuccess && result) {
        NSData *keyData = (__bridge_transfer NSData *)result;
        return keyData;
    }
    return nil;
}



- (BOOL)storeEncryptedPinData:(NSData *)data {
    if (!data) return NO;
    // Remove existing
    NSDictionary *delQuery = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: @"com.firstbankapp.securepin",
        (__bridge id)kSecAttrAccount: @"user_pin"
    };
    SecItemDelete((__bridge CFDictionaryRef)delQuery);
    
    NSDictionary *add = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: @"com.firstbankapp.securepin",
        (__bridge id)kSecAttrAccount: @"user_pin",
        (__bridge id)kSecValueData: data,
        (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly
    };
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)add, NULL);
    return (status == errSecSuccess);
}



- (nullable NSData *)getEncryptedPinDataFromKeychain {
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: @"com.firstbankapp.securepin",
        (__bridge id)kSecAttrAccount: @"user_pin",
        (__bridge id)kSecReturnData: @YES,
        (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitOne
    };
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (status == errSecSuccess && result) {
        NSData *data = (__bridge_transfer NSData *)result;
        return data;
    }
    return nil;
}



#pragma mark - AES helpers (CommonCrypto)

- (NSData *)generateRandomDataOfLength:(size_t)length {
    NSMutableData *data = [NSMutableData dataWithLength:length];
    int result = SecRandomCopyBytes(kSecRandomDefault, length, data.mutableBytes);
    if (result != 0) {
        return nil;
    }
    return data;
}

- (NSData *)aesEncryptData:(NSData *)plain key:(NSData *)key iv:(NSData *)iv {
    if (!plain || !key || !iv) return nil;
    size_t outLength;
    NSMutableData *cipherData = [NSMutableData dataWithLength:plain.length + kCCBlockSizeAES128];
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt,
                                     kCCAlgorithmAES,
                                     kCCOptionPKCS7Padding, // CBC + PKCS7
                                     key.bytes,
                                     key.length,
                                     iv.bytes,
                                     plain.bytes,
                                     plain.length,
                                     cipherData.mutableBytes,
                                     cipherData.length,
                                     &outLength);
    if (result == kCCSuccess) {
        cipherData.length = outLength;
        return cipherData;
    } else {
        NSLog(@"CCCrypt encrypt failed: %d", result);
        return nil;
    }
}


- (NSData *)aesDecryptData:(NSData *)cipher key:(NSData *)key iv:(NSData *)iv {
    if (!cipher || !key || !iv) return nil;
    size_t outLength;
    NSMutableData *decrypted = [NSMutableData dataWithLength:cipher.length + kCCBlockSizeAES128];
    
    CCCryptorStatus result = CCCrypt(kCCDecrypt,
                                     kCCAlgorithmAES,
                                     kCCOptionPKCS7Padding,
                                     key.bytes,
                                     key.length,
                                     iv.bytes,
                                     cipher.bytes,
                                     cipher.length,
                                     decrypted.mutableBytes,
                                     decrypted.length,
                                     &outLength);
    if (result == kCCSuccess) {
        decrypted.length = outLength;
        return decrypted;
    } else {
        NSLog(@"CCCrypt decrypt failed: %d", result);
        return nil;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
