//
//  AccountValidationViewController.m
//  FirstBankApp
//
//  Created by Tunde Adebanjo on 23/07/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "AccountValidationViewController.h"
#import "AESHelper.h"
//#import <SmileID/SmileID.h> // IMPORTANT: Ensure this is uncommented and SmileID is properly integrated via CocoaPods

// Constants for better readability and easier modification
static const NSUInteger kBVNLength = 11;
static const NSUInteger kAccountNumberLength = 10; // Assuming 10 digits for account number

// IMPORTANT: Replace with your actual Smile ID Partner ID and User ID
// These should ideally come from a secure configuration or your backend.
static NSString *const kSmileIDPartnerID = @"045";
static NSString *const kSmileIDUserID = @"user_id_355464646";
static NSString *const kAppKey = @"ae819f1e854c4d06af2bf4b68f32493a";
static NSString *const kAppId = @"FGT";
static NSString *const KBAppKey=@"e3r564erthgfre3wedfrmjuyhb";
static NSString *const KBAppID=@"23qweadserwfvdrefsxdgterfqmft";


@interface AccountValidationViewController () <UITextFieldDelegate>


- (NSString *)generateShortRequestId; // Declaration for the new helper method



// Private helper method declarations
- (void)configureNavigationBar;
- (void)styleSubmitButton;
- (void)styleTextField:(UITextField *)textField placeholder:(NSString *)placeholder;
- (void)showAlert:(NSString *)title message:(NSString *)message completion:(void (^)(void))completion;

// Backend API methods
- (void)validateBVNAccount:(NSString *)bvn accountNumber:(NSString *)accountNumber;
- (void)sendBVNDetails:(NSDictionary *)details;

// Smile ID Integration methods
- (void)fetchSmileIDSignatureWithCompletion:(void (^)(NSString *signature, NSString *timestamp, NSError *error))completion;
- (void)startSmileIDBiometricKYC;

@end




@implementation AccountValidationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.passedData) {
        self.passedData = [NSMutableDictionary dictionary];
    }

    _bvnTextField.secureTextEntry = YES;
    _accountNumberTextField.secureTextEntry=YES;
    
    self.view.backgroundColor = [self.class colorFromHexString:@"#F8F8F8"];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.backgroundColor=[AccountValidationViewController colorFromHexString:@"#FFD700"];
    self.title = @"Account validation";

    [self configureNavigationBar];
    [self styleTextField:self.bvnTextField placeholder:@"Enter your BVN"];
    [self styleTextField:self.accountNumberTextField placeholder:@"Enter account number"];
    [self styleSubmitButton];
}


- (void)configureNavigationBar {
    UINavigationBar *navBar = self.navigationController.navigationBar;
    if (navBar) {
        UIColor *primaryColor = [self.class colorFromHexString:@"#FFD700"];
        UIColor *textColor = [self.class colorFromHexString:@"#001F4E"];
        navBar.barTintColor = primaryColor;
        // navBar.backgroundColor = primaryColor; // barTintColor usually handles the background
        navBar.translucent = NO;
        navBar.titleTextAttributes = @{
            NSForegroundColorAttributeName: textColor,
            NSFontAttributeName: [UIFont boldSystemFontOfSize:18]
        };
        navBar.tintColor = textColor;
    }
}

- (void)styleSubmitButton {
    self.submitButton.backgroundColor = [self.class colorFromHexString:@"#FFD700"];
    [self.submitButton setTitleColor:[self.class colorFromHexString:@"#001F4E"] forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.submitButton.layer.cornerRadius = 8.0;
    self.submitButton.clipsToBounds = YES;
}

- (void)styleTextField:(UITextField *)textField placeholder:(NSString *)placeholder {
    textField.placeholder = placeholder;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.delegate = self;
    textField.layer.cornerRadius = 8.0;
    textField.layer.borderWidth = 1.0;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.backgroundColor = UIColor.whiteColor;
    textField.textColor = [self.class colorFromHexString:@"#333333"];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                      attributes:@{NSForegroundColorAttributeName: [self.class colorFromHexString:@"#888888"]}];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = textField.text.length + string.length - range.length;
    if (textField == self.bvnTextField) {
        return newLength <= kBVNLength;
    } else if (textField == self.accountNumberTextField) {
        return newLength <= kAccountNumberLength;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - IBActions

- (IBAction)submitButtonTapped:(UIButton *)sender {
    NSString *bvn = self.bvnTextField.text;
    NSString *accountNumber = self.accountNumberTextField.text;

    if (bvn.length == kBVNLength && accountNumber.length == kAccountNumberLength) {
        NSLog(@"BVN: %@, Account Number: %@", bvn, accountNumber);
        // Start the BVN/Account validation process with your backend
        [self validateBVNAccount:bvn accountNumber:accountNumber];
    } else {
        [self showAlert:@"Input Error"
                message:@"Please enter a valid 11-digit BVN and a 10-digit account number."
             completion:nil];
    }
}


- (NSString *)generateShortRequestId {
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%0.f", timestamp * 1000];
}



#pragma mark - Backend API Calls
- (void)validateBVNAccount:(NSString *)bvn accountNumber:(NSString *)accountNumber {
    UIAlertController *loadingAlert = [UIAlertController alertControllerWithTitle:@"Validating"
                                                                          message:@"Verifying BVN and Account..."
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:loadingAlert animated:YES completion:nil];
    
    // Trim leading/trailing whitespace from both strings
    NSString *trimmedBvn = [bvn stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trimmedAccountNumber = [accountNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Use the trimmed strings in the API call
    NSDictionary *body = @{
        @"acc": trimmedAccountNumber,
        @"requestId": [self generateShortRequestId],
        @"countryId": @"01",
        @"bvn": trimmedBvn
    };
    
    NSLog(@"What to send to backends: %@", body);
    
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&jsonError];
    
    if (jsonError || !jsonData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingAlert dismissViewControllerAnimated:YES completion:^{
                NSString *errorMessage = jsonError ? jsonError.localizedDescription : @"Unknown error creating request data.";
                [self showAlert:@"Error" message:[NSString stringWithFormat:@"Failed to create request payload: %@", errorMessage] completion:nil];
            }];
        });
        return;
    }
    
    // ... rest of the networking code remains the same
    
    NSURL *url = [NSURL URLWithString:@"https://firsttokenapp.firstbanknigeria.com/AccountCIFID.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    [request setHTTPBody:jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:kAppKey forHTTPHeaderField:@"AppKey"];
    [request setValue:kAppId forHTTPHeaderField:@"AppId"];
    
    NSLog(@"POST URL: %@", url);
    NSString *rawJsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"POST Body (Raw JSON String): %@", rawJsonString);
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingAlert dismissViewControllerAnimated:YES completion:^{
                if (error) {
                    [strongSelf showAlert:@"Network Error" message:error.localizedDescription completion:nil];
                    return;
                }
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
                    NSString *rawResponseString = data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : @"No data";
                    [strongSelf showAlert:@"Server Error" message:[NSString stringWithFormat:@"Server returned status code %ld. Response: %@", (long)httpResponse.statusCode, rawResponseString] completion:nil];
                    return;
                }
                
                if (!data || data.length == 0) {
                    [strongSelf showAlert:@"Error" message:@"No response received from server." completion:nil];
                    return;
                }
                
                NSError *parseError = nil;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                if (parseError || ![json isKindOfClass:[NSDictionary class]]) {
                    [strongSelf showAlert:@"Response Error" message:@"Failed to parse server response." completion:nil];
                    return;
                }
                
                NSString *encryptedString = json[@"encrypted"];
                if (!encryptedString) {
                    [strongSelf showAlert:@"Decryption Error" message:@"Server response is not encrypted." completion:nil];
                    return;
                }
                
                NSString *hexKey =@"43c26e9588231acdbc25d03288d13d024d2497eb15d080da9de84f7de36edf1b";
//                NSString *hexIV = @"37383966647267687479693435363764";
                NSString *decryptedResponse = [AESHelper decrypt:encryptedString keyHex:hexKey];
                
                if (!decryptedResponse) {
                    [strongSelf showAlert:@"Decryption Failed" message:@"Failed to decrypt server response." completion:nil];
                    return;
                }
                
                NSError *decryptionParseError = nil;
                NSDictionary *decryptedJson = [NSJSONSerialization JSONObjectWithData:[decryptedResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&decryptionParseError];
                
                if (decryptionParseError || ![decryptedJson isKindOfClass:[NSDictionary class]]) {
                    [strongSelf showAlert:@"Response Error" message:@"Failed to parse decrypted data." completion:nil];
                    return;
                }
        
                NSLog(@"user decryptedjson %@", decryptedJson);
                
                NSString *status = decryptedJson[@"status"];
                if ([status isEqualToString:@"success"]) {
//                    NSDictionary *userDetails = decryptedJson[@"data"];
//                    NSLog(@"user details %@", userDetails);
                    NSString *returnedBvn = decryptedJson[@"bvn"];
                    NSLog(@"returned BVn %@", returnedBvn);
                    NSLog(@"trimedBVn %@", trimmedBvn);
                    
                    if ([returnedBvn isEqualToString:trimmedBvn]) { // Use the trimmed BVN for comparison
                        NSLog(@"BVN matches! Proceeding to send BVN details.");
                        [strongSelf sendBVNDetails:decryptedJson];
                    } else {
                        [strongSelf showAlert:@"Validation Failed" message:@"The BVN is not associated with this account." completion:nil];
                    }
                } else {
                    NSString *message = decryptedJson[@"message"] ?: @"Validation failed. Please try again.";
                    [strongSelf showAlert:@"Validation Failed" message:message completion:nil];
                }
            }];
        });
    }];
    [task resume];
}


- (void)sendBVNDetails:(NSDictionary *)details {
    // Show loading alert for sending BVN details
    UIAlertController *loadingAlert = [UIAlertController alertControllerWithTitle:@"Processing"
                                                                           message:@"Sending BVN Details..."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:loadingAlert animated:YES completion:nil];

    NSURL *url = [NSURL URLWithString:@"https://firsttokenapp.firstbanknigeria.com/getBVNDetails.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

    NSString *bvnValue = details[@"bvn"];
    
    if (!self.passedData) {
        self.passedData = [NSMutableDictionary dictionary];
    }
   
        self.passedData[@"bvn"] = details[@"bvn"];
        self.passedData[@"cifid"]= details[@"CifId"];
        self.passedData[@"accountNumber"]=details[@"AccountNumber"];
    
 
    NSDictionary *body = @{
        @"bvn": bvnValue,    };

    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&jsonError];

    if (jsonError || !jsonData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingAlert dismissViewControllerAnimated:YES completion:^{
                NSString *errorMessage = jsonError ? jsonError.localizedDescription : @"Unknown error encoding BVN details.";
                [self showAlert:@"Error" message:[NSString stringWithFormat:@"Failed to encode BVN details: %@", errorMessage] completion:nil];
            }];
        });
        return;
    }

    // Set request body and headers for JSON
    [request setHTTPBody:jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"]; // Set Content-Type to application/json
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];

    // IMPORTANT: Add custom headers for AppKey and AppId as required by your PHP backend
    [request setValue:KBAppKey forHTTPHeaderField:@"AppKey"];
    [request setValue:KBAppID forHTTPHeaderField:@"AppId"];
    
    NSLog(@"POST URL: %@", url);
    NSLog(@"POST Body (JSON Dictionary): %@", body);

    // --- UNCOMMENTED FOR DEBUGGING RAW JSON SENT ---
    NSString *rawJsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"POST Body (Raw JSON String): %@", rawJsonString);
    // -----------------------------------------------

    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;

        // All UI updates must be on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingAlert dismissViewControllerAnimated:YES completion:^{
                if (error) {
                    // Log the network error details
                    NSLog(@"Network Error for getBVNDetails.php: %@", error.localizedDescription);
                    if (error.userInfo) {
                        NSLog(@"Error UserInfo: %@", error.userInfo);
                    }
                    [strongSelf showAlert:@"Submission Error" message:error.localizedDescription completion:nil];
                    return;
                }

                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSLog(@"getBVNDetails.php HTTP Status Code: %ld", (long)httpResponse.statusCode);
                NSLog(@"getBVNDetails.php Content-Type: %@", httpResponse.allHeaderFields[@"Content-Type"]);

                // Check for non-2xx status codes (server-side errors)
                if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
                    NSString *rawResponseString = @"No data";
                    if (data) {
                        rawResponseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    }
                    NSLog(@"getBVNDetails.php Non-2xx Status Code Response: %@", rawResponseString);
                    [strongSelf showAlert:@"Server Error" message:[NSString stringWithFormat:@"Server returned status code %ld. Please try again later.", (long)httpResponse.statusCode] completion:nil];
                    return;
                }

                if (data) {
                    NSString *rawResponseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"getBVNDetails.php Raw Server Response: %@", rawResponseString);
                } else {
                    NSLog(@"getBVNDetails.php Response Data is NIL.");
                }

                NSError *parseError = nil;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                if (parseError || ![json isKindOfClass:[NSDictionary class]]) {
                    // Log parsing error details
                    if (parseError) {
                        NSLog(@"JSON Parsing Error for getBVNDetails.php: %@", parseError.localizedDescription);
                        if (parseError.userInfo) {
                            NSLog(@"Parsing Error UserInfo: %@", parseError.userInfo);
                        }
                    }
                    [strongSelf showAlert:@"Response Error" message:@"Could not parse server response." completion:nil];
                    return;
                }

                NSString *status = json[@"status"];
             
              
                


                if ([status isEqualToString:@"success"]) {
//                    if (!self.passedData) {
//                        self.passedData = [NSMutableDictionary dictionary];
//                    }
                    
                    NSDictionary *jsonDetails = json[@"data"];
                    NSLog(@"info from resp%@", json);
                        
                        self.passedData [@"firstName"] = json[@"firstName"];
                        self.passedData [@"middleName"] = json[@"middleName"];
                        self.passedData [@"lastName"]=json[@"lastName"];
                        self.passedData [@"phoneNumber1"]=jsonDetails[@"phoneNumber1"];
                        self.passedData [@"phoneNumber2"]=jsonDetails[@"phoneNumber2"];
                        self.passedData [@"nationality"]=jsonDetails[@"nationality"];
                        self.passedData [@"base64Image"]=jsonDetails[@"base64Image"];
                    // Instantiate the view controller with storyboard ID
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *bvnDetailsVC = [storyboard instantiateViewControllerWithIdentifier:@"BVNDetailsVC"];
                    
                    // Pass the collected data to the next view controller
                    if (bvnDetailsVC && [bvnDetailsVC respondsToSelector:@selector(setPassedData:)]) {
                        [bvnDetailsVC performSelector:@selector(setPassedData:) withObject:strongSelf.passedData];
//                        [bvnDetailsVC performSelector:@selector(setPassedData:) withObject:strongSelf.fullPassedData];
                    } else {
                        NSLog(@"Warning: BVNDetailsVC does not have a 'passedData' property or could not be instantiated.");
                    }

                    if (strongSelf.navigationController) {
                        [strongSelf.navigationController pushViewController:bvnDetailsVC animated:YES];
                    } else {
                        NSLog(@"Error: Not embedded in a navigation controller for BVNDetailsVC push.");
                        // Handle modal presentation if not in nav controller, or alert user.
                        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:bvnDetailsVC];
                        navController.modalPresentationStyle = UIModalPresentationFullScreen;
                        [strongSelf presentViewController:navController animated:YES completion:nil];
                    }

                } else {
                    NSString *message = json[@"message"] ?: @"An error occurred during submission.";
                    [strongSelf showAlert:@"Error" message:message completion:nil];
                }
            }];
        });
    }];    [task resume];
}



#pragma mark - Helper Methods

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    scanner.scanLocation = ([hexString hasPrefix:@"#"]) ? 1 : 0;

    if (![scanner scanHexInt:&rgbValue]) {
        NSLog(@"Invalid hex string: %@", hexString);
        return UIColor.blackColor;
    }

    return [UIColor colorWithRed:((rgbValue >> 16) & 0xFF) / 255.0
                           green:((rgbValue >> 8) & 0xFF) / 255.0
                            blue:(rgbValue & 0xFF) / 255.0
                           alpha:1.0];
}

// Consolidated showAlert method
- (void)showAlert:(NSString *)title message:(NSString *)message completion:(void (^)(void))completion {
    // Dismiss any existing alert before presenting a new one
    // This is crucial to prevent "Attempt to present ... which is already presenting" errors.
    if (self.presentedViewController && [self.presentedViewController isKindOfClass:[UIAlertController class]]) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        if (completion) completion();
    }];

    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)startSmileIDBiometricKYC {
}

- (void)fetchSmileIDSignatureWithCompletion:(void (^__strong)(NSString *__strong, NSString *__strong, NSError *__strong))completion {
}

@end

