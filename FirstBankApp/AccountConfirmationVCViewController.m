//
//  AccountConfirmationVCViewController.m
//  FirstBankApp
//
//  Created by cbc gedu on 08/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "AccountConfirmationVCViewController.h"
#import "InfoCardView.h"
#import "InstructionCardView.h"
#import "PinSetUp.h"
#import "EntrustUtilityVC.h"

@interface AccountConfirmationVCViewController ()
@property (nonatomic, strong) UILabel *instructionsLabel; // The "How to get Enrollment ID" list
@property (nonatomic, strong) InstructionCardView *instructionView;

@end

@implementation AccountConfirmationVCViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Account Confirmation";
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    EntrustUtilityVC *entrust = [EntrustUtilityVC sharedInstance];
    
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 16;
    
    
    // Create container for icon + label
    UIView *titleContainer = [[UIView alloc] init];
    titleContainer.translatesAutoresizingMaskIntoConstraints = NO;

    
    
    UIImageView *titleIconView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account-icon"]];
    titleIconView.translatesAutoresizingMaskIntoConstraints = NO;
    titleIconView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *sectionTitle = [[UILabel alloc] init];
    sectionTitle.text =nil;
    sectionTitle.font = [UIFont boldSystemFontOfSize:17];
    sectionTitle.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Add both to container
    [titleContainer addSubview:titleIconView];
    [titleContainer addSubview:sectionTitle];
    
    UILabel *sectionDesc = [[UILabel alloc] init];
    sectionDesc.text = @"Please verify that the following account details are correct before proceeding.";
    sectionDesc.font = [UIFont systemFontOfSize:14];
    sectionDesc.textColor = [UIColor darkGrayColor];
    sectionDesc.numberOfLines = 0;
    sectionDesc.translatesAutoresizingMaskIntoConstraints = NO;
    
    InfoCardView *orgName = [[InfoCardView alloc] initWithIcon:[UIImage imageNamed:@"org-icon"]
                                                         title:@"Organisation Name"
                                                      subtitle:entrust.organizationName];
    InfoCardView *email = [[InfoCardView alloc] initWithIcon:[UIImage imageNamed:@"mail-icon"]
                                                      title:@"Email Address"
                                                   subtitle:entrust.email];
    InfoCardView *platform = [[InfoCardView alloc] initWithIcon:[UIImage imageNamed:@"platfrm-icon"]
                                                         title:@"Platform"
                                                      subtitle:entrust.platform];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.translatesAutoresizingMaskIntoConstraints = NO;
    nextBtn.backgroundColor = [UIColor colorWithRed:0.03 green:0.2 blue:0.4 alpha:1];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 8;
    [nextBtn setTitle:@"Next" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UITextView *noteLabel = [[UITextView alloc] init];
    noteLabel.translatesAutoresizingMaskIntoConstraints = NO;
    noteLabel.text = @"Important\nPlease ensure the account details shown above are correct.";
    noteLabel.font = [UIFont systemFontOfSize:13];
    noteLabel.textColor = [UIColor darkGrayColor];
    noteLabel.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    noteLabel.layer.cornerRadius = 12;
    noteLabel.layer.masksToBounds = YES;
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.textContainerInset = UIEdgeInsetsMake(8, 12, 8, 12);
  
    
    [self.view addSubview:card];
    [card addSubview:titleContainer];
    [card addSubview:sectionDesc];
    [card addSubview:orgName];
    [card addSubview:email];
    [card addSubview:platform];
    [card addSubview:nextBtn];
    [self.view addSubview:noteLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [card.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [card.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [card.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [titleIconView.topAnchor constraintEqualToAnchor:titleContainer.topAnchor constant:12],
          [titleIconView.leadingAnchor constraintEqualToAnchor:titleContainer.leadingAnchor constant:12],
          [titleIconView.widthAnchor constraintEqualToConstant:16],
          [titleIconView.heightAnchor constraintEqualToConstant:16],

          [sectionTitle.leadingAnchor constraintEqualToAnchor:titleIconView.trailingAnchor constant:10],
          [sectionTitle.centerYAnchor constraintEqualToAnchor:titleIconView.centerYAnchor],

          [titleContainer.topAnchor constraintEqualToAnchor:card.topAnchor constant:12],
          [titleContainer.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:12],
          [titleContainer.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-12],

        
        [sectionDesc.topAnchor constraintEqualToAnchor:sectionTitle.bottomAnchor constant:4],
        [sectionDesc.leadingAnchor constraintEqualToAnchor:sectionTitle.leadingAnchor],
        [sectionDesc.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:12],
        
        [orgName.topAnchor constraintEqualToAnchor:sectionDesc.bottomAnchor constant:16],
        [orgName.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16],
        [orgName.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-16],
        
        [email.topAnchor constraintEqualToAnchor:orgName.bottomAnchor constant:8],
        [email.leadingAnchor constraintEqualToAnchor:orgName.leadingAnchor],
        [email.trailingAnchor constraintEqualToAnchor:orgName.trailingAnchor],
        
        [platform.topAnchor constraintEqualToAnchor:email.bottomAnchor constant:8],
        [platform.leadingAnchor constraintEqualToAnchor:orgName.leadingAnchor],
        [platform.trailingAnchor constraintEqualToAnchor:orgName.trailingAnchor],
        
        [nextBtn.topAnchor constraintEqualToAnchor:platform.bottomAnchor constant:16],
        [nextBtn.leadingAnchor constraintEqualToAnchor:orgName.leadingAnchor],
        [nextBtn.trailingAnchor constraintEqualToAnchor:orgName.trailingAnchor],
        [nextBtn.heightAnchor constraintEqualToConstant:48],
        [nextBtn.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-16],
        
        [noteLabel.topAnchor constraintEqualToAnchor:card.bottomAnchor constant:12],
        [noteLabel.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [noteLabel.trailingAnchor constraintEqualToAnchor:card.trailingAnchor]
    ]];
    
    
    self.instructionView = [[InstructionCardView alloc]
        initWithTitle:@"Important"
        items:@[
            @"Please ensure the account details shown above are correct,If any information is incorrect, contact customer support before proceeding."
        ]
        style:InstructionListStyleNone];

    [self.view addSubview:self.instructionView];

    [NSLayoutConstraint activateConstraints:@[
        [self.instructionView.topAnchor constraintEqualToAnchor:noteLabel.bottomAnchor constant:16],
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
    UIImage *badgeImage = [UIImage imageNamed:@"otp-icon"];
    UIImageView *badgeIconView = [[UIImageView alloc] initWithImage:badgeImage];
    badgeIconView.contentMode = UIViewContentModeScaleAspectFit;
    badgeIconView.translatesAutoresizingMaskIntoConstraints = NO;
    badgeIconView.tintColor = [UIColor whiteColor];

    // --- Title Label ---
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Account Confirmation";
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
    NSLog(@"Back button tapped ");
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)supportTapped {
    NSLog(@"Support button tapped");
    // Future: open support screen
}

- (void)nextTapped {
    NSLog(@"Next tapped → navigate to OTP screen");
    PinSetUp *pinVC=[[PinSetUp alloc] init];
    [self.navigationController pushViewController:pinVC animated:YES];
    
}
@end
