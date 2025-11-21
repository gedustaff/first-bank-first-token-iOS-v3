//
//  PinSetUp.m
//  FirstBankApp
//
//  Created by cbc gedu on 28/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "PinSetUp.h"
#import "OTPInputView.h"
#import "InstructionCardView.h"
#import "ProfilesViewController.h"
#import <EntrustIGMobile/ETIdentityProvider.h>
#import <EntrustIGMobile/ETIdentity.h>
#import "EntrustUtilityVC.h"
#import "ProfileManager.h"
#import "KeychainUtility.h"
#import <CommonCrypto/CommonCrypto.h>



// External constant declaration (assuming this is defined elsewhere)


// --- PBKDF2 Constants ---
// Recommended iteration count for modern PIN/Password hashing


@interface PinSetUp ()<OTPInputViewDelegate>
@property (nonatomic, strong) OTPInputView *otpInputView;
@property (nonatomic, strong) InstructionCardView *instructionView;
@property(nonatomic, strong) NSString *otpInput;
@property (nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) NSString *completedPin;
// Private methods for security
- (nullable NSString *)hashPin:(NSString *)pin;
- (nullable NSData *)generateRandomSalt;

@end

@implementation PinSetUp

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *titleContainer = [[UIView alloc] init];
    titleContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *titleIconView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge-otp"]];
    titleIconView.translatesAutoresizingMaskIntoConstraints = NO;
    titleIconView.contentMode = UIViewContentModeScaleAspectFit;
    

       _titleLabel = [[UILabel alloc] init];
       _titleLabel.text = @"Set Your PIN";
       _titleLabel.font = [UIFont boldSystemFontOfSize:18];
       _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [titleContainer addSubview:titleIconView];
    [titleContainer addSubview:_titleLabel];
    
    UILabel *instruction=[[UILabel alloc] init];
    instruction.text=@"Kindly enter your 4-digit PIN";
    instruction.textAlignment=NSTextAlignmentCenter;
    instruction.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.view addSubview: instruction];
    
    
    
    // Initialize OTP input (choose 4 or 6)
     self.otpInputView= [[OTPInputView alloc] initWithDigits:4];
     self.otpInputView.delegate = self;
    [self.view addSubview:titleContainer];
     [self.view addSubview:self.otpInputView];
    
    
    
    UIButton  *nextButton= [UIButton buttonWithType: UIButtonTypeSystem];
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    nextButton.backgroundColor = [UIColor colorWithRed:0.03 green:0.2 blue:0.4 alpha:1];
//        nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
       nextButton.layer.cornerRadius = 8;
//       nextButton.backgroundColor = [UIColor systemBlueColor];
       [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    // ✅ Add action for tap
    [nextButton addTarget:self action:@selector(nextButtonTapped) forControlEvents:UIControlEventTouchUpInside];
       [self.view addSubview:nextButton];
    
    
    
    
    self.instructionView = [[InstructionCardView alloc]
        initWithTitle:@"Important"
        items:@[
            @"Please ensure the account details shown above are correct,If any information is incorrect, contact customer support before proceeding."
        ]
        style:InstructionListStyleNone];

    [self.view addSubview:self.instructionView];
     
     // Center on screen
     [NSLayoutConstraint activateConstraints:@[
        [titleContainer.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [titleContainer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [titleContainer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [titleIconView.topAnchor constraintEqualToAnchor:titleContainer.topAnchor constant:16],
          [titleIconView.leadingAnchor constraintEqualToAnchor:titleContainer.leadingAnchor constant:12],
          [titleIconView.widthAnchor constraintEqualToConstant:16],
          [titleIconView.heightAnchor constraintEqualToConstant:16],

        [_titleLabel.leadingAnchor constraintEqualToAnchor:titleIconView.trailingAnchor constant:16],
        [_titleLabel.centerYAnchor constraintEqualToAnchor:titleIconView.centerYAnchor],
        [instruction.topAnchor constraintEqualToAnchor:titleContainer.topAnchor constant:50],
        [instruction.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [instruction.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-80],
//         [self.otpInputView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
//         [self.otpInputView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
        
        [self.otpInputView.topAnchor constraintEqualToAnchor:instruction.bottomAnchor constant:20],
        [self.otpInputView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        
        [nextButton.topAnchor constraintEqualToAnchor:self.otpInputView.bottomAnchor constant:30],
             [nextButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
             [nextButton.widthAnchor constraintEqualToConstant:200],
             [nextButton.heightAnchor constraintEqualToConstant:50],
        
        
        [self.instructionView.topAnchor constraintEqualToAnchor:nextButton.bottomAnchor constant:30],
        [self.instructionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.instructionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20]    
        

     ]];
    
    [self setupNavigationBar];
}

- (nullable NSData *)generateRandomSalt {
    NSMutableData *saltData = [NSMutableData dataWithLength:kPBKDF2SaltLength];
    // Use the secure random number generator provided by the system
    int result = SecRandomCopyBytes(kSecRandomDefault, kPBKDF2SaltLength, saltData.mutableBytes);
    if (result != 0) {
        NSLog(@"SECURITY ERROR: Failed to generate random salt: %d", result);
        return nil;
    }
    return saltData;
}


- (nullable NSString *)hashPin:(NSString *)pin {
    
    NSData *pinData = [pin dataUsingEncoding:NSUTF8StringEncoding];
    NSData *saltData = [self generateRandomSalt];

    if (!pinData || !saltData) {
        return nil;
    }

    // 1. Derive Key using PBKDF2 (SHA256)
    NSMutableData *derivedKey = [NSMutableData dataWithLength:kPBKDF2KeyLength];
    
    int status = CCKeyDerivationPBKDF(kCCPBKDF2,
                                      pinData.bytes,
                                      pinData.length,
                                      saltData.bytes,
                                      saltData.length,
                                      kCCPRFHmacAlgSHA256,
                                      kPBKDF2Iterations,
                                      derivedKey.mutableBytes,
                                      derivedKey.length);

    if (status != kCCSuccess) {
        NSLog(@"SECURITY ERROR: PBKDF2 derivation failed with status: %d", status);
        return nil;
    }
    
    NSLog(@"INFO: PBKDF2 PIN hashing successful (Iterations: %d)", kPBKDF2Iterations);

    // 2. Combine Salt and Derived Key for storage (Salt || DerivedKey)
    // The salt must be stored with the hash to verify the PIN later.
    NSMutableData *combinedData = [NSMutableData dataWithData:saltData];
    [combinedData appendData:derivedKey];

    // 3. Base64 Encode for storage (KeychainUtility expects an NSString)
    return [combinedData base64EncodedStringWithOptions:0];
}



- (void)setupNavigationBar {
    self.title = nil;
    self.navigationItem.titleView = nil;

    // Set navigation bar tint color (icons/buttons)
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    // --- Create Container for Left Items ---
    UIView *leftContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    leftContainerView.userInteractionEnabled = YES;

    // ---  Back Button ---
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [[UIImage imageNamed:@"arrow-back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backButton setImage:backBtnImage forState:UIControlStateNormal];
    backButton.tintColor = [UIColor whiteColor];
    backButton.translatesAutoresizingMaskIntoConstraints = NO;
    backButton.userInteractionEnabled = YES;
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];

    // --- Badge Icon (Next to Back Button) ---
    UIImage *badgeImage = [UIImage imageNamed:@"lock-icon"];
    UIImageView *badgeIconView = [[UIImageView alloc] initWithImage:badgeImage];
    badgeIconView.contentMode = UIViewContentModeScaleAspectFit;
    badgeIconView.translatesAutoresizingMaskIntoConstraints = NO;
    badgeIconView.tintColor = [UIColor whiteColor];

    // --- Title Label ---
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Pin Setup";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

    // --- Add All to Container ---
    [leftContainerView addSubview:backButton];
    [leftContainerView addSubview:badgeIconView];
    [leftContainerView addSubview:titleLabel];

    // ---  Layout Constraints ---
    [NSLayoutConstraint activateConstraints:@[
        // Back Button
        [backButton.leadingAnchor constraintEqualToAnchor:leftContainerView.leadingAnchor constant:0],
        [backButton.centerYAnchor constraintEqualToAnchor:leftContainerView.centerYAnchor],
        [backButton.widthAnchor constraintEqualToConstant:30],
        [backButton.heightAnchor constraintEqualToConstant:30],

        // Badge Icon (Right of back button)
        [badgeIconView.leadingAnchor constraintEqualToAnchor:backButton.trailingAnchor constant:6],
        [badgeIconView.centerYAnchor constraintEqualToAnchor:leftContainerView.centerYAnchor],
        [badgeIconView.widthAnchor constraintEqualToConstant:20],
        [badgeIconView.heightAnchor constraintEqualToConstant:20],

        // Title Label (Right of badge)
        [titleLabel.leadingAnchor constraintEqualToAnchor:badgeIconView.trailingAnchor constant:6],
        [titleLabel.centerYAnchor constraintEqualToAnchor:leftContainerView.centerYAnchor],
        [titleLabel.trailingAnchor constraintEqualToAnchor:leftContainerView.trailingAnchor constant:-4]
        
    ]];

    // ---  Create a Bar Button with the Container ---
    UIBarButtonItem *customLeftItem = [[UIBarButtonItem alloc] initWithCustomView:leftContainerView];
    self.navigationItem.leftBarButtonItem = customLeftItem;

    // --- Right Icon (Support Button) ---
    UIImage *chatImage = [[UIImage imageNamed:@"Support"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithImage:chatImage
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(supportTapped)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
}

#pragma mark - OTPInputViewDelegate
//- (void)otpInputView:(OTPInputView *)otpView didCompleteOTP:(NSString *)otp {
//    NSLog(@" Entered OTP: %@", otp);
//    _otpInput=otp;
//    
//    // Example success navigati
//    if ([otp isEqualToString:@"1234"]) {
//        NSLog(@"Correct OTP!");
//        // Push or show success popup
//        ProfilesViewController *profileVC=[[ProfilesViewController alloc] init];
//        [self.navigationController pushViewController:profileVC animated:YES];
//    } else {
//        NSLog(@"Invalid OTP");
//    }
//}

- (void)otpInputView:(OTPInputView *)otpView didCompleteOTP:(NSString *)otp {
    // Store the completed PIN
    self.completedPin = otp;
}

- (void)didFinishEnteringPIN:(NSString *)pin {
    NSLog(@"Entered PIN: %@", pin);
    // You can now validate or navigate
    ProfilesViewController *profileVC=[[ProfilesViewController alloc] init];
    [self.navigationController pushViewController:profileVC animated:YES];
    
}

- (void)generateTokenWithPIN:(NSString *)pin  pinHash:(NSString *)pinHash{
    NSLog(@"Generating token...");
    
    EntrustUtilityVC *entrust = [EntrustUtilityVC sharedInstance];
    
    // Mock network call - replace with real backend API
    UIAlertController *loadingAlert = [UIAlertController alertControllerWithTitle:@"Processing"
                                                                           message:@"Generating token..."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:loadingAlert animated:YES completion:nil];
  
    
    NSURL *url = [NSURL URLWithString:@"https://firsttokenapp.firstbanknigeria.com/generate-soft-token.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSDictionary *body = @{@"enrolmentID": entrust.enrollmentId};
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"tijJDpd+yN9rMXTYLFbC8HHQZsIiD7HG6MsZauAHzTEN/EOqoIgPW6t8DbWo1kN2" forHTTPHeaderField:@"AppKey"];
    [request setValue:@"DxvjTUHIaqCcepTj3f9rWMi0x48+//3UC+HwwcwoEcs=" forHTTPHeaderField:@"AppId"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Token generation failed: %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlert:@"Error" message:error.localizedDescription];
            });
            return;
        }
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSDictionary *innerData = json[@"data"][@"data"];
        NSString *activationCode = innerData[@"activationCode"];
        NSString *serialNumber = innerData[@"serialNumber"];
        
        NSLog(@"res for generate token %@", innerData);
        
        // Initialize Entrust Identity
        //        ETIdentityProvider *provider = [[ETIdentityProvider alloc] init];
        error = nil;
        
        NSString *deviceId = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        
        
        // The variable to hold the new identity
        
        @try{
            ETIdentity *newIdentity = nil;
            newIdentity = [ETIdentityProvider generate:deviceId
                                          serialNumber:serialNumber
                                        activationCode:activationCode];
            
            if (newIdentity) {
                NSLog(@"Entrust identity generated successfully! %@", newIdentity);
                
                // 2. Store the identity and profile details (NEW LOGIC)
                entrust.identity = newIdentity; // Store identity locally in your manager
                
              
              
                
                // 3. Continue to activate (which should include PIN saving)
                NSDictionary *details = @{@"enrolmentID": entrust.enrollmentId, @"serialNumber": serialNumber, @"registrationCode": activationCode};
                
                NSLog(@"to send for activation %@", details);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self activateEntrustTokenWithPIN:details rawPin:pin pinHash:pinHash];
                });
                
            } else {
                // Should not happen if successful, but a failsafe
                NSLog(@" Identity generation returned nil without exception.");
                [self showAlert:@"Error" message:@"Identity generation failed mysteriously."];
            }
            
        }@catch(NSException *exception){
            // Handle the Entrust SDK exception (e.g., invalid activation code)
            NSLog(@" Identity Generation Failed: %@", exception.reason);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlert:@"Activation Error" message:exception.reason];
            });
            
        }
        
    
    

  
    
    }];
    
    [task resume];

}




- (void)activateEntrustTokenWithPIN:(NSDictionary *)details rawPin:(NSString *)rawPin pinHash:(NSString *)pinHash{
    UIAlertController *loadingAlert = [UIAlertController alertControllerWithTitle:@"Processing"
                                                                        message:@"Activating token..."
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:loadingAlert animated:YES completion:nil];
    
    EntrustUtilityVC *entrust = [EntrustUtilityVC sharedInstance];
    
    // --- API Call: Activate Soft Token ---
    NSURL *url = [NSURL URLWithString:@"https://firsttokenapp.firstbanknigeria.com/activate-soft-token.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:details options:0 error:nil];
    request.HTTPBody = jsonData;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"tijJDpd+yN9rMXTYLFbC8HHQZsIiD7HG6MsZauAHzTEN/EOqoIgPW6t8DbWo1kN2" forHTTPHeaderField:@"AppKey"];
    [request setValue:@"DxvjTUHIaqCcepTj3f9rWMi0x48+//3UC+HwwcwoEcs=" forHTTPHeaderField:@"AppId"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
                                  dataTaskWithRequest:request
                                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingAlert dismissViewControllerAnimated:YES completion:^{
                if (error) {
                    [self showAlert:@"Error" message:error.localizedDescription];
                    return;
                }
                
                // 1. SAVE HASHED PIN TO KEYCHAIN
                BOOL hashSaved = [KeychainUtility addValue:pinHash forKey:kPinAccessKey];
                
                if (hashSaved) {
                    NSLog(@"SUCCESS: Securely hashed PIN saved to Keychain for key: %@", kPinAccessKey);
                } else {
                    NSLog(@"ERROR: Failed to save PIN Hash to Keychain!");
                    [self showAlert:@"Security Error" message:@"Failed to securely set your PIN. Please restart the enrollment."];
                    return;
                }
                
                // 2. SAVE PROFILE DETAILS
                NSDictionary *profileDetails = @{
                    @"username": entrust.username,
                    @"organizationName": entrust.organizationName,
                    @"emailAddress": entrust.email,
                    @"platform":entrust.platform,
                    @"enrolmentID":entrust.enrollmentId
                };
                
                
                [ProfileManager saveNewProfile:profileDetails];
                [self presentViewController:loadingAlert animated:YES completion:nil];
                // 3. NAVIGATE TO PROFILES SCREEN
                ProfilesViewController *profileVC = [[ProfilesViewController alloc] init];
                [self.navigationController pushViewController:profileVC animated:YES];
            }];
        });
    }];
    
    [task resume];
    
}


-(void)storedKeyPIN:(NSString *)Key{
    
}

-(void)storeProfileDetails:(NSArray *)profile{
    
}


- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}




- (void)nextButtonTapped {
    
    // Use the completed PIN stored from the delegate callback
    NSString *enteredPIN = self.completedPin;
    
    NSLog(@"Next button tapped with PIN: %@", enteredPIN);
    
    if (enteredPIN.length == 4) {
        // 1. SECURELY HASH THE PIN
        NSString *pinHash = [self hashPin:enteredPIN];
        if (!pinHash) {
            [self showAlert:@"Security Error" message:@"Failed to securely process PIN during hashing."];
            return;
        }

        // 2. Proceed with token generation, passing both raw PIN and hash
        [self generateTokenWithPIN:enteredPIN pinHash:pinHash];
    } else {
        [self showAlert:@"Invalid PIN" message:@"Please enter a 4-digit PIN."];
    }
}


-(void)supportTapped {
    NSLog(@"Support button tapped");
}



@end
