//
//  EneterNewPin.m
//  FirstBankApp
//
//  Created by cbc gedu on 03/11/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "EneterNewPin.h"
#import "OTPInputView.h"
#import "InstructionCardView.h"
#import "EneterReconfirmPin.h"

@interface EneterNewPin ()<OTPInputViewDelegate>
@property (nonatomic, strong) OTPInputView *otpInputView;
@property (nonatomic, strong) InstructionCardView *instructionView;
@property(nonatomic, strong) NSString *otpInput;
@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation EneterNewPin

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *titleContainer = [[UIView alloc] init];
    titleContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *titleIconView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge-otp"]];
    titleIconView.translatesAutoresizingMaskIntoConstraints = NO;
    titleIconView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"Enter New Pin";
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [titleContainer addSubview:titleIconView];
    [titleContainer addSubview:_titleLabel];
    
    UILabel *instruction=[[UILabel alloc] init];
    instruction.text=@"Please enter your new 4-digit PIN";
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
    // Add action for tap
    [nextButton addTarget:self action:@selector(nextButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    
    
    
    self.instructionView = [[InstructionCardView alloc]
                            initWithTitle:@"Pin security tips"
                            items:@[
        @"Use a unique 4-digit combination",
        @"Avoid obvious patterns (1234, 1111)",
        @"Don’t share your PIN with anyone",
        @"Memorize your PIN securely"
    ]
                            style:InstructionListStyleBulleted];
    
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
    titleLabel.text = @"Enter New Pin";
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



- (void)otpInputView:(OTPInputView *)otpView didCompleteOTP:(NSString *)otp {
    NSLog(@" Entered OTP: %@", otp);
    _otpInput=otp;
    
    // Example success navigati
    if ([otp isEqualToString:@"1234"]) {
        NSLog(@"Correct OTP!");
        // Push or show success popup
        EneterReconfirmPin *profileVC=[[EneterReconfirmPin  alloc] init];
        [self.navigationController pushViewController:profileVC animated:YES];
    } else {
        NSLog(@"Invalid OTP");
    }
}



- (void)didFinishEnteringPIN:(NSString *)pin {
    NSLog(@"Entered PIN: %@", pin);
    // You can now validate or navigate
    EneterReconfirmPin  *profileVC=[[EneterReconfirmPin  alloc] init];
    [self.navigationController pushViewController:profileVC animated:YES];
    
}



- (void)nextButtonTapped {
    NSString *enteredPIN = self.otpInputView.enteredOTP;
    NSLog(@"Next button tapped with PIN: %@", enteredPIN);
    
    if (_otpInput.length == 4 ) {
        // Navigate or verify PIN
        EneterNewPin *profileVC = [[EneterNewPin alloc] init];
        [self.navigationController pushViewController:profileVC animated:YES];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid PIN"
                                                                       message:@"Please enter a valid 4 or 6 digit PIN."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


-(void)supportTapped {
    NSLog(@"Support button tapped");
}


@end
