//
//  EnterPinViewController.m
//  FirstBankApp
//
//  Created by cbc gedu on 29/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "EnterPinViewController.h"
#import "SoftTokenViewController.h"
#import "ProfileManager.h"
#import "KeychainUtility.h"

@interface EnterPinViewController ()

@property (nonatomic, strong) UIView *accountCardView;
@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UILabel *bankLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) OTPInputView *otpInputView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *forgotPinButton;
@property (nonatomic, strong) UIView *infoCardView;
@property(nonatomic, strong) NSString *otpInput;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subtitleLabel;

@end


@implementation EnterPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    [self setupNavigationBar];
    [self setupUI];
}

#pragma mark - Navigation Bar



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
    titleLabel.text = @"Enter Pin";
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

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UI Setup

- (void)setupUI {
    // --- Account Card ---
    self.accountCardView = [[UIView alloc] init];
    self.accountCardView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    self.accountCardView.layer.cornerRadius = 8;
    self.accountCardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.accountCardView];
    
    UIImageView *accountIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Vector"]];
    accountIcon.translatesAutoresizingMaskIntoConstraints = NO;
    accountIcon.contentMode = UIViewContentModeScaleAspectFit;
    
    self.accountLabel = [[UILabel alloc] init];
    self.accountLabel.text = @"Dangote@221100";
    self.accountLabel.font = [UIFont boldSystemFontOfSize:16];
    self.accountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.bankLabel = [[UILabel alloc] init];
    self.bankLabel.text = @"FirstDirect";
    self.bankLabel.font = [UIFont systemFontOfSize:13];
    self.bankLabel.textColor = [UIColor systemGreenColor];
    self.bankLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.text = @"Active";
    self.statusLabel.font = [UIFont systemFontOfSize:13];
    self.statusLabel.textColor = [UIColor systemGreenColor];
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.accountCardView addSubview:accountIcon];
    [self.accountCardView addSubview:self.accountLabel];
    [self.accountCardView addSubview:self.bankLabel];
    [self.accountCardView addSubview:self.statusLabel];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"Enter your 4-digit PIN";
    self.titleLabel.font=[UIFont systemFontOfSize:16];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints=NO;
    
    self.subtitleLabel=[[UILabel alloc] init];
    self.subtitleLabel.text=@"Enter your PIN to generate a soft token for transaction authentication.";
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints=NO;
    self.subtitleLabel.numberOfLines = 0; // allow unlimited lines
    self.subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping; // wrap
    self.subtitleLabel.font=[UIFont systemFontOfSize:13];
    
    
    UIView *containerView=[[UIView alloc] init];
    containerView.translatesAutoresizingMaskIntoConstraints=NO;
    
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.subtitleLabel];
    
    [self.view addSubview:containerView];
    
    [containerView addSubview:self.titleLabel];
    [containerView addSubview:self.subtitleLabel];
    
    // --- OTP Input ---
    self.otpInputView = [[OTPInputView alloc] initWithDigits:4];
    self.otpInputView.delegate = self;
    self.otpInputView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.otpInputView];
    
    // --- Submit Button ---
    self.submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    self.submitButton.backgroundColor = [UIColor colorWithRed:0.03 green:0.2 blue:0.4 alpha:1];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.layer.cornerRadius = 8;
    self.submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.submitButton addTarget:self action:@selector(submitTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
    
    // --- Forgot PIN ---
    self.forgotPinButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.forgotPinButton setTitle:@"Forgot PIN?" forState:UIControlStateNormal];
    [self.forgotPinButton setTitleColor:[UIColor colorWithRed:0.03 green:0.2 blue:0.4 alpha:1] forState:UIControlStateNormal];
    self.forgotPinButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.forgotPinButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.forgotPinButton];
    
    // --- Information Card ---
    self.infoCardView = [[UIView alloc] init];
    self.infoCardView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    self.infoCardView.layer.cornerRadius = 8;
    self.infoCardView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *infoTitle = [[UILabel alloc] init];
    infoTitle.text = @"Information";
    infoTitle.font = [UIFont boldSystemFontOfSize:16];
    infoTitle.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *infoDetails = [[UILabel alloc] init];
    infoDetails.numberOfLines = 0;
    infoDetails.font = [UIFont systemFontOfSize:14];
    infoDetails.text = @"1. To deactivate your soft token, click on the settings icon and follow the prompt.\n\n2. To change your PIN, click on the settings icon on the top right of your screen and follow the prompt.";
    infoDetails.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.infoCardView addSubview:infoTitle];
    [self.infoCardView addSubview:infoDetails];
    [self.view addSubview:self.infoCardView];
    
    // --- Constraints ---
    [NSLayoutConstraint activateConstraints:@[
        [self.accountCardView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [self.accountCardView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.accountCardView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.accountCardView.heightAnchor constraintEqualToConstant:80],
        
        [accountIcon.leadingAnchor constraintEqualToAnchor:self.accountCardView.leadingAnchor constant:15],
        [accountIcon.centerYAnchor constraintEqualToAnchor:self.accountCardView.centerYAnchor],
        [accountIcon.widthAnchor constraintEqualToConstant:30],
        [accountIcon.heightAnchor constraintEqualToConstant:30],
        
        [self.accountLabel.leadingAnchor constraintEqualToAnchor:accountIcon.trailingAnchor constant:10],
        [self.accountLabel.topAnchor constraintEqualToAnchor:self.accountCardView.topAnchor constant:15],
        
        [self.bankLabel.leadingAnchor constraintEqualToAnchor:self.accountLabel.trailingAnchor constant:8],
        [self.bankLabel.centerYAnchor constraintEqualToAnchor:self.accountLabel.centerYAnchor],
        
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.accountLabel.leadingAnchor],
     
        
        [self.statusLabel.topAnchor constraintEqualToAnchor:self.accountLabel.bottomAnchor constant:8],
        
        [containerView.topAnchor constraintEqualToAnchor:self.accountCardView.bottomAnchor constant:40],
        [containerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [containerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:20],
        
        // Title Label
        [self.titleLabel.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:16],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        // Subtitle Label
        [self.subtitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:8],
        [self.subtitleLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [self.subtitleLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        [self.subtitleLabel.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-16],
        
        [self.otpInputView.topAnchor constraintEqualToAnchor:self.subtitleLabel.bottomAnchor constant:40],
        [self.otpInputView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        
        [self.submitButton.topAnchor constraintEqualToAnchor:self.otpInputView.bottomAnchor constant:25],
        [self.submitButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.submitButton.widthAnchor constraintEqualToConstant:250],
        [self.submitButton.heightAnchor constraintEqualToConstant:50],
        
        [self.forgotPinButton.topAnchor constraintEqualToAnchor:self.submitButton.bottomAnchor constant:15],
        [self.forgotPinButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        
        [self.infoCardView.topAnchor constraintEqualToAnchor:self.forgotPinButton.bottomAnchor constant:30],
        [self.infoCardView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.infoCardView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [infoTitle.topAnchor constraintEqualToAnchor:self.infoCardView.topAnchor constant:15],
        [infoTitle.leadingAnchor constraintEqualToAnchor:self.infoCardView.leadingAnchor constant:15],
        
        [infoDetails.topAnchor constraintEqualToAnchor:infoTitle.bottomAnchor constant:10],
        [infoDetails.leadingAnchor constraintEqualToAnchor:self.infoCardView.leadingAnchor constant:15],
        [infoDetails.trailingAnchor constraintEqualToAnchor:self.infoCardView.trailingAnchor constant:-15],
        [infoDetails.bottomAnchor constraintEqualToAnchor:self.infoCardView.bottomAnchor constant:-15]
    ]];
}


#pragma mark - OTPInputViewDelegate
- (void)otpInputView:(OTPInputView *)otpView didCompleteOTP:(NSString *)otp {
    NSLog(@" Entered OTP: %@", otp);
    _otpInput=otp;
    
    // Example success navigati
    if ([otp isEqualToString:@"1234"]) {
        NSLog(@"Correct OTP!");
        // Push or show success popup
    } else {
        NSLog(@"Invalid OTP");
    }
}






#pragma mark - Button Action
- (void)submitTapped {
    NSString *enteredPIN = self.otpInputView.enteredOTP;
    
    NSString *storedHash = [KeychainUtility retrieveValueForKey:kPinAccessKey];

    if (!storedHash) {
              [self showPinAlertWithTitle:@"Invalid PIN"
                                              message:@"The PIN you entered is incorrect. Please try again or use the 'Forgot PIN?' option."];
        return;
    }
    
    if(_otpInput.length== 4){
        BOOL isValid = [ProfileManager verifyPin:enteredPIN withStoredHash:storedHash];

        if (isValid) {
            NSLog(@"✅ Correct PIN");
            SoftTokenViewController *softTokenVC = [[SoftTokenViewController alloc] init];
            [self.navigationController pushViewController:softTokenVC animated:YES];
        } else {
            NSLog(@"Incorrect PIN");
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid PIN"
                                                                                  message:@"Please enter your correct 4-digit PIN."
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                   [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                   [self presentViewController:alert animated:YES completion:nil];
        }
        
    }

  

    
//    if (_otpInput.length == 4) {
//        NSLog(@"PIN Submitted: %@", _otpInput);
//        // Continue to next flow
//        if ([ProfileManager verifyPin: enteredPIN]) {
//       NSLog(@"PIN Verification Successful. Navigating to Soft Token.");
//       
//       SoftTokenViewController *softPInVC = [[SoftTokenViewController alloc] init];
//    [self.navigationController pushViewController:softPInVC animated:YES];
//       } else {
//           
//       [self showPinAlertWithTitle:@"Invalid PIN"
//                                       message:@"The PIN you entered is incorrect. Please try again or use the 'Forgot PIN?' option."];
///*[self.otpInputView clearInput];*/ // Clear input for security/retry
//    }
//        
//
//    } else {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid PIN"
//                                                                       message:@"Please enter your 4-digit PIN."
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
}


- (void)showPinAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}





@end
