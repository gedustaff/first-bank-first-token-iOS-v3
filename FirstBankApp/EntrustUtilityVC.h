//
//  EntrustUtilityVC.h
//  FirstBankApp
//
//  Created by cbc gedu on 07/11/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EntrustIGMobile/ETIdentityProvider.h>

NS_ASSUME_NONNULL_BEGIN

@interface EntrustUtilityVC : NSObject
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *enrollmentId;
@property (nonatomic, strong) NSString *referenceNumber;
@property (nonatomic, strong) NSString *organizationName;
@property (nonatomic, strong) NSString *platform;
@property (nonatomic, strong) NSString *username;


//  New properties for PIN setup
@property (nonatomic, strong, nullable) NSString *pinCode;       // user's PIN
@property (nonatomic, assign) BOOL isPinSet;                     // status flag
@property (nonatomic, strong, nullable) NSDate *pinLastUpdated;  // optional timestamp
@property (nonatomic, strong, nullable) NSString *activateCode;
@property (nonatomic, strong, nullable) ETIdentity *identity;
@property (nonatomic, strong, nullable) NSString *serialNumber;


+ (instancetype)sharedInstance;

- (void)saveEnrollmentDataWithEmail:(NSString *)email
                       enrollmentId:(NSString *)enrollmentId
//                    organizationName:(NSString *)organizationName
//                            platform:(NSString *)platform
//                            username:(NSString *)username
                    referenceNumber:(NSString *)referenceNumber;


- (void)loadSavedEnrollmentData;

// Secure PIN API (double-layered AES + Keychain)
- (BOOL)saveSecurePIN:(NSString *)pin;                 // encrypts with AES and stores in Keychain
- (nullable NSString *)retrieveSecurePIN;              // returns decrypted PIN or nil
- (void)clearSecurePIN;                                // removes encrypted PIN and AES key


@end

NS_ASSUME_NONNULL_END
