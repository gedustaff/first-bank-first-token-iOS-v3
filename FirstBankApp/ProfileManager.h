//
//  ProfileManager.h
//  FirstBankApp
//
//  Created by cbc gedu on 11/11/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileManager : NSObject


+ (NSMutableArray<NSDictionary *> *)loadProfiles;
+ (void)saveNewProfile:(NSDictionary *)newProfile;

// --- Conditional Flow Methods ---

// Checks if any user profiles (tokens) have been saved.
+ (BOOL)hasSavedProfiles;

+ (BOOL)setPin:(NSString *)newPin;

// Checks if the user has set up a PIN/Passcode (Now uses Keychain).
+ (BOOL)isPinSet;

+ (BOOL)verifyPin:(NSString *)pin withStoredHash:(NSString *)storedBase64;
// Securely deletes the PIN from the Keychain.
+ (BOOL)clearPin;


@end

NS_ASSUME_NONNULL_END
