//
//  OTPVerificationVCViewController.m
//  FirstBankApp
//
//  Created by cbc gedu on 08/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "OTPVerificationVCViewController.h"
#import "OTPInputView.h"
#import "StatusPopupViewController.h"
#import "SuccessPopupViewController.h"
#import "AccountConfirmationVCViewController.h"
#import "EntrustUtilityVC.h"


@interface OTPVerificationVCViewController ()<OTPInputViewDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) OTPInputView *otpInputView;
@property (nonatomic, strong) UIButton *verifyButton;

@property (nonatomic, strong) UILabel *resendLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger secondsRemaining;
@property (nonatomic, strong) UILabel *errorLabel;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *otpRef;
@property(nonatomic, strong) NSString *enrolmentId;
@property (nonatomic, strong) UIButton *continueButton;

@end

@implementation OTPVerificationVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = nil;
       self.view.backgroundColor = [UIColor systemBackgroundColor];
    EntrustUtilityVC *entrust = [EntrustUtilityVC sharedInstance];
    UIView *titleContainer = [[UIView alloc] init];
    titleContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    _email = entrust.email;
        _enrolmentId = entrust.enrollmentId;
        _otpRef= entrust.referenceNumber;
        
        NSLog(@"Email: %@", _email);
        NSLog(@"Enrollment ID: %@", _enrolmentId);
        NSLog(@"Reference Number: %@", _otpRef);
    
    
    UIImageView *titleIconView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge-otp"]];
    titleIconView.translatesAutoresizingMaskIntoConstraints = NO;
    titleIconView.contentMode = UIViewContentModeScaleAspectFit;
    

       _titleLabel = [[UILabel alloc] init];
       _titleLabel.text = @"Enter OTP";
       _titleLabel.font = [UIFont boldSystemFontOfSize:18];
       _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [titleContainer addSubview:titleIconView];
    [titleContainer addSubview:_titleLabel];
       
       _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.text = [NSString stringWithFormat:@"We’ve sent a 6-digit verification code to %@", _email ?: @"your email"];
       _subtitleLabel.font = [UIFont systemFontOfSize:14];
       _subtitleLabel.textColor = [UIColor darkGrayColor];
       _subtitleLabel.numberOfLines = 0;
       _subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
       
     
    self.otpInputView = [[OTPInputView alloc] initWithDigits:6];
    self.otpInputView.delegate = self;
       
       _verifyButton = [UIButton buttonWithType:UIButtonTypeSystem];
       _verifyButton.translatesAutoresizingMaskIntoConstraints = NO;
       [_verifyButton setTitle:@"Verify OTP" forState:UIControlStateNormal];
       _verifyButton.backgroundColor = [UIColor colorWithRed:0.03 green:0.2 blue:0.4 alpha:1];
       [_verifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       _verifyButton.layer.cornerRadius = 10;
       [_verifyButton addTarget:self action:@selector(verifyTapped) forControlEvents:UIControlEventTouchUpInside];
       
       _resendLabel = [[UILabel alloc] init];
       _resendLabel.font = [UIFont systemFontOfSize:13];
       _resendLabel.textColor = [UIColor grayColor];
       _resendLabel.translatesAutoresizingMaskIntoConstraints = NO;
       
       [self.view addSubview:titleContainer];
       [self.view addSubview:_subtitleLabel];
       [self.view addSubview:self.otpInputView];
       [self.view addSubview:_verifyButton];
       [self.view addSubview:_resendLabel];
       
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
           
           [_subtitleLabel.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor constant:30],
           [_subtitleLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:30],
           [_subtitleLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-12],
           
           [self.otpInputView.topAnchor constraintEqualToAnchor:_subtitleLabel.bottomAnchor constant:24],
           [self.otpInputView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
           
           [_verifyButton.topAnchor constraintEqualToAnchor:self.otpInputView.bottomAnchor constant:30],
           [_verifyButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:40],
           [_verifyButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-40],
           [_verifyButton.heightAnchor constraintEqualToConstant:50],
           
           [_resendLabel.topAnchor constraintEqualToAnchor:_verifyButton.bottomAnchor constant:10],
           [_resendLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
       ]];
    
    // Example: add red text below fields
    // You can extend this to show alerts or inline messages
    self.errorLabel = [[UILabel alloc] init];
    self.errorLabel.textColor = [UIColor redColor];
    self.errorLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    self.errorLabel.text = @"Incorrect OTP. You have 3 attempts remaining.";
    self.errorLabel.numberOfLines = 0;
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    self.errorLabel.hidden = YES; // Hide by default
    
    self.errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.errorLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.errorLabel.topAnchor constraintEqualToAnchor:self.verifyButton.bottomAnchor constant:10],
        [self.errorLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.errorLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20]
    ]];
    

    [self setupNavigationBar];
       
       [self startTimer];
}

- (void)setupNavigationBar {
    

    self.title = nil;
    self.navigationItem.titleView = nil;
    
    // Set the overall tint color for buttons/icons
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // --- 2. Build the Custom Left View (Arrow + Title + Badge Icon) ---
    
    // Create a container view to hold all left elements
    UIView *leftContainerView = [[UIView alloc] init];
    leftContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 2a. Back Arrow Button
       UIImage *backBtnImage = [UIImage imageNamed:@"arrow-back"];
       UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
       [backButton setImage:backBtnImage forState:UIControlStateNormal];
       [backButton setTintColor:[UIColor whiteColor]];
       
       // FIX: Assign the target (self) and the action (@selector(backButtonTapped))
       [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
       
       backButton.translatesAutoresizingMaskIntoConstraints = NO;
       [leftContainerView addSubview:backButton];
    
    // 2b. Badge Icon (The Building Icon)
    UIImage *badgeImage = [UIImage imageNamed:@"badge-otp"]; // Using 'otp-icon' as a placeholder for your badge
    UIImageView *badgeIconView = [[UIImageView alloc] initWithImage:badgeImage];
    badgeIconView.tintColor = [UIColor whiteColor]; // White tint for the icon
    badgeIconView.translatesAutoresizingMaskIntoConstraints = NO;
    [leftContainerView addSubview:badgeIconView];
    
    // 2c. Title Label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"OTP Verification";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17]; // Adjust size as needed
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [leftContainerView addSubview:titleLabel];
    
 

    // --- 3. Constraints for the Custom Left View ---
    
    // Use constraints to position and space all elements inside leftContainerView
    [NSLayoutConstraint activateConstraints:@[
        // Back Button: Align to the far left of the container
        [backButton.leadingAnchor constraintEqualToAnchor:leftContainerView.leadingAnchor constant:-10], // Negative value shifts it left from default padding
        [backButton.centerYAnchor constraintEqualToAnchor:leftContainerView.centerYAnchor],
        [backButton.widthAnchor constraintEqualToConstant:30],
        [backButton.heightAnchor constraintEqualToConstant:30],
        
        // Title Label: Position right of the back button
        [titleLabel.leadingAnchor constraintEqualToAnchor:badgeIconView.trailingAnchor constant:4], // Place immediately next to the button
        [titleLabel.centerYAnchor constraintEqualToAnchor:leftContainerView.centerYAnchor],
        
        // Badge Icon: Position immediately right of the title text
        [badgeIconView.leadingAnchor constraintEqualToAnchor:backButton.trailingAnchor constant:4], // 4 points separation
        [badgeIconView.centerYAnchor constraintEqualToAnchor:leftContainerView.centerYAnchor],
        [badgeIconView.widthAnchor constraintEqualToConstant:20],
        [badgeIconView.heightAnchor constraintEqualToConstant:20],
        
        // Container Width: The right edge is defined by the badge icon's right edge
        [leftContainerView.trailingAnchor constraintEqualToAnchor:titleLabel.trailingAnchor constant:4] // Add slight trailing padding
    ]];
    
    // 4. Set the custom view as the Left Bar Button Item
    UIBarButtonItem *customLeftItem = [[UIBarButtonItem alloc] initWithCustomView:leftContainerView];
    self.navigationItem.leftBarButtonItem = customLeftItem;


    // --- 5. RIGHT ICON (Support) ---
    
    UIImage *chatImage = [UIImage imageNamed:@"Support"];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                   initWithImage:chatImage
                                   style:UIBarButtonItemStylePlain
                                   target:nil action:nil];
    
    rightButton.tintColor = [UIColor whiteColor];
    
    // Add negative spacer to shift the right icon right
    UIBarButtonItem *negativeRightSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    negativeRightSpacer.width = -10.0;
    
    self.navigationItem.rightBarButtonItems = @[negativeRightSpacer, rightButton];
    
    
}


- (void)backButtonTapped {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}




- (void)validateOTP:(NSDictionary *)details {
    // Show a loading alert
    UIAlertController *loadingAlert = [UIAlertController alertControllerWithTitle:@"Processing"
                                                                          message:@"Validating OTP..."
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:loadingAlert animated:YES completion:nil];
    
    // Prepare URL and request
    NSURL *url = [NSURL URLWithString:@"https://firsttokenapp.firstbanknigeria.com/validate-otp.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:details options:0 error:&jsonError];
    if (jsonError) {
        [loadingAlert dismissViewControllerAnimated:YES completion:^{
            [self showAlert:@"Error" message:@"Failed to encode request."];
        }];
        return;
    }
    
    NSLog(@"Sending payload: %@", details);
    
    [request setHTTPBody:jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"tijJDpd+yN9rMXTYLFbC8HHQZsIiD7HG6MsZauAHzTEN/EOqoIgPW6t8DbWo1kN2" forHTTPHeaderField:@"AppKey"];
    [request setValue:@"DxvjTUHIaqCcepTj3f9rWMi0x48+//3UC+HwwcwoEcs=" forHTTPHeaderField:@"AppId"];
    
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
        dataTaskWithRequest:request
          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
              
              __strong typeof(weakSelf) strongSelf = weakSelf;
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  [loadingAlert dismissViewControllerAnimated:YES completion:^{
                      
                      // Handle network errors
                      if (error) {
                          [strongSelf showAlert:@"Network Error" message:error.localizedDescription];
                          return;
                      }
                      
                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                      if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
                          [strongSelf showAlert:@"Server Error" message:@"Unexpected server response."];
                          return;
                      }
                      
                      NSError *parseError = nil;
                      NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                      if (parseError || ![json isKindOfClass:[NSDictionary class]]) {
                          [strongSelf showAlert:@"Error" message:@"Invalid response format."];
                          return;
                      }
                      
                      NSLog(@" Response JSON: %@", json);
                      
                      NSDictionary *outerData = json[@"data"];
                      NSDictionary *innerData = outerData[@"data"];
//                      NSString *enrolmentID=innerData[@"data"];
                      NSString *status = [json[@"status"] lowercaseString];
                      NSNumber *httpStatus = outerData[@"httpStatusCode"];
                      NSString *message = outerData[@"message"];
                      
                      if ([status isEqualToString:@"success"] && [httpStatus intValue] == 200) {
                          
                          NSLog(@" Valid response payload: %@", innerData);
                          
                          // Handle specific message case
                          if ([message isEqualToString:@"You have an active token. Do you want to deactivate it and proceed with soft token activation?"]) {
                              
                              SuccessPopupViewController *popup = [[SuccessPopupViewController alloc] init];
                              popup.modalPresentationStyle = UIModalPresentationOverFullScreen;
                              popup.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                              
                              popup.successTitleText = @"Token Deactivation!";
                              popup.successMessageText = @"You have an active token. Do you want to deactivate it and proceed with soft token activation?";
                              popup.buttonTitleText = @"Continue";
                              
                              popup.onContinue = ^{
                                  NSLog(@"Continue tapped, deactivating token...");
                                  [self deactivateTokenOTP:self.enrolmentId];
                              };
                              
                              popup.onCancelTapped = ^{
                                  NSLog(@"User canceled deactivation");
                                  // Optionally perform a different action here
                              };
                              
                              [strongSelf presentViewController:popup animated:YES completion:nil];
                              
                              
                            
                          } else {
                             
                              NSDictionary *details=innerData[@"details"];
                              NSString *organizationName=details[@"organizationName"];
                              NSString *platform=details[@"platform"];
                              NSString *username=details[@"username"];
                              
                              EntrustUtilityVC *entrust = [EntrustUtilityVC sharedInstance];
                              entrust.username=username;
                              entrust.platform=platform;
                              entrust.organizationName=organizationName;
                              
                              //                              // Proceed to next screen (e.g., OTPVC)
                              //                              OTPViewController *otpVC = [[OTPViewController alloc] init];
                              //                              [strongSelf.navigationController pushViewController:otpVC animated:YES];

                                                            AccountConfirmationVCViewController *otpVC = [[AccountConfirmationVCViewController alloc] init];
                              
                                                                    [self.navigationController pushViewController:otpVC animated:YES];
                          }
                          
                      } else {
                          // Failure case
                          NSString *errorMsg = message ?: @"Failed to validate OTP. Please try again.";
                          [strongSelf showAlert:@"Validation Failed" message:errorMsg];
                      }
                  }];
              });
          }];
    
    [task resume];
}






- (void)showAlert:(NSString*)title message:(NSString*)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}



-(void)deactivateTokenOTP:(NSString *) enrolmentId{

    UIAlertController *loadingAlert = [UIAlertController alertControllerWithTitle:@"Processing"
                                                                           message:@"Deactivating  Token..."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:loadingAlert animated:YES completion:nil];

    NSURL *url = [NSURL URLWithString:@"https://firsttokenapp.firstbanknigeria.com/deactivate-token.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";




    NSDictionary *body = @{@"enrolmentID": enrolmentId};
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&jsonError];

    if (jsonError) {
        [loadingAlert dismissViewControllerAnimated:YES completion:^{
            [self showAlert:@"Error" message:@"Failed to encode request."];
        }];
        return;
    }

    NSLog(@"to send %@", body);

    [request setHTTPBody:jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"tijJDpd+yN9rMXTYLFbC8HHQZsIiD7HG6MsZauAHzTEN/EOqoIgPW6t8DbWo1kN2" forHTTPHeaderField:@"AppKey"];
    [request setValue:@"DxvjTUHIaqCcepTj3f9rWMi0x48+//3UC+HwwcwoEcs=" forHTTPHeaderField:@"AppId"];

    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
        dataTaskWithRequest:request
          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
              __strong typeof(weakSelf) strongSelf = weakSelf;
              dispatch_async(dispatch_get_main_queue(), ^{
                  [loadingAlert dismissViewControllerAnimated:YES completion:^{
                      if (error) {
                          [strongSelf showAlert:@"Network Error" message:error.localizedDescription];
                          return;
                      }

                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                      if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
                          [strongSelf showAlert:@"Server Error" message:@"Unexpected server response."];
                          return;
                      }

                      NSError *parseError = nil;
                      NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                      if (parseError) {
                          [strongSelf showAlert:@"Error" message:@"Invalid response format."];
                          return;
                      }

//                      NSLog(@"second res %@", json);

                      NSDictionary *outerData = json[@"details"];
                      NSDictionary *innerData = outerData[@"data"];
                      
                      NSLog(@"trying to deactivate token %@", json);

                      NSLog(@"second res %@", innerData);
//
                      NSString *status = json[@"status"];
                      NSNumber *httpStatus = outerData[@"httpStatusCode"];


                      if ([status.lowercaseString isEqualToString:@"success"] && [httpStatus intValue] == 200) {
                          
                          NSLog(@"resp %@", outerData);
                          NSString *organizationName=innerData[@"organizationName"];
                          NSString *platform=innerData[@"platform"];
                          NSString *username=innerData[@"username"];
                          
                          EntrustUtilityVC *entrust = [EntrustUtilityVC sharedInstance];
                          entrust.username=username;
                          entrust.platform=platform;
                          entrust.organizationName=organizationName;
                         
                        

//
//
//
//                          ////      // Create and navigate to OTP screen
                        AccountConfirmationVCViewController *otpVC = [[AccountConfirmationVCViewController alloc] init];

                                [self.navigationController pushViewController:otpVC animated:YES];



                      } else {
                          NSString *message = json[@"message"] ?: @"An error occurred during submission.";
                          [strongSelf showAlert:@"Error" message:message];
                      }
                  }];
              });
          }];
    [task resume];

}


- (void)verifyTapped {
    NSString *otp = [self.otpInputView getOTP];
    
    if (otp.length < 6) {
        [self showError:@"Please enter all 6 digits"];
        return;
    }
    
    [self showError:nil];
    [self.view endEditing:YES];
    
    NSDictionary *details = @{@"otp": otp, @"enrolmentID":_enrolmentId, @"referenceNumber":_otpRef};
    
//    BOOL isVerified = [otp isEqualToString:@"123456"];
    
    [self validateOTP: details];
}



- (void)startTimer {
    self.secondsRemaining = 30;
    self.resendLabel.text = [NSString stringWithFormat:@"Resend in %lds", (long)self.secondsRemaining];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}


- (void)updateTimer {
    self.secondsRemaining--;
    if (self.secondsRemaining <= 0) {
        [self.timer invalidate];
        self.resendLabel.textColor = [UIColor systemBlueColor];
        self.resendLabel.text = @"Resend OTP";
        self.resendLabel.userInteractionEnabled = YES;
    } else {
        self.resendLabel.text = [NSString stringWithFormat:@"Resend in %lds", (long)self.secondsRemaining];
    }
}

- (void)showError:(NSString *)message {
    if (message) {
           self.errorLabel.text = message;
           self.errorLabel.hidden = NO;
           
           // optional shake animation
           [UIView animateWithDuration:0.05 animations:^{
               self.errorLabel.transform = CGAffineTransformMakeTranslation(5, 0);
           } completion:^(BOOL finished) {
               [UIView animateWithDuration:0.05 animations:^{
                   self.errorLabel.transform = CGAffineTransformIdentity;
               }];
           }];
       } else {
           self.errorLabel.hidden = YES;
       }}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
