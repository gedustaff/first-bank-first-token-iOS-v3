//
//  ResetPinVC.m
//  FirstBankApp
//
//  Created by cbc gedu on 04/11/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "ResetPinVC.h"
#import "OTPInputView.h"
#import "StatusPopupViewController.h"
#import "SuccessPopupViewController.h"
#import "AccountConfirmationVCViewController.h"

@interface ResetPinVC ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) OTPInputView *otpInputView;
@property (nonatomic, strong) UIButton *verifyButton;
@property (nonatomic, strong) UILabel *resendLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger secondsRemaining;
@property (nonatomic, strong) UILabel *errorLabel;


@end

@implementation ResetPinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Do any additional setup after loading the view.
    self.title = nil;
       self.view.backgroundColor = [UIColor systemBackgroundColor];
    UIView *titleContainer = [[UIView alloc] init];
    titleContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    
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
       _subtitleLabel.text = @"We’ve sent a 6-digit verification code to Dangote@firstdirect.com";
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



- (void)verifyTapped {
    NSString *otp = [self.otpInputView getOTP];
    
    if (otp.length < 6) {
        [self showError:@"Please enter all 6 digits"];
        return;
    }
    
    [self showError:nil];
    [self.view endEditing:YES];
    
    BOOL isVerified = [otp isEqualToString:@"123456"];
    if (isVerified) {
        // Show reusable success popup
        SuccessPopupViewController *popup = [[SuccessPopupViewController alloc] init];
        popup.modalPresentationStyle = UIModalPresentationOverFullScreen;
        popup.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        popup.successTitleText = @"Success!";
        popup.successMessageText = @"OTP verified successfully. Continue to your account confirmation.";
        popup.buttonTitleText = @"Continue";

        __weak typeof(self) weakSelf = self;
        popup.onContinue = ^{
            // Navigate to account confirmation
            AccountConfirmationVCViewController *nextVC = [[AccountConfirmationVCViewController alloc] init];
            [weakSelf.navigationController pushViewController:nextVC animated:YES];
        };

        [self presentViewController:popup animated:YES completion:nil];
    } else {
        [self showError:@"Incorrect OTP. Please try again."];
    }
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
