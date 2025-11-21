//
//  SettingsVC.m
//  FirstBankApp
//
//  Created by cbc gedu on 03/11/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "SettingsVC.h"
#import "EneterOldPin.h"
#import "DeactivateTokenVC.h"
#import "ResetPinVC.h"

@interface SettingsVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *accountCardView;
@property (nonatomic, strong) UIImageView *accountIcon;
@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UILabel *bankLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UIView *quickSettingsCard;
@property (nonatomic, strong) UIButton *changePinButton;
@property (nonatomic, strong) UIButton *resetPinButton;
@property (nonatomic, strong) UIButton *deactivateButton;

@property (nonatomic, strong) UIView *infoCard;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UILabel *profileStatusLabel;

@property (nonatomic, strong) UIView *securityNoticeCard;
@property (nonatomic, strong) UILabel *noticeLabel;
@end



@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Settings";
        self.view.backgroundColor = [UIColor systemGray6Color];
        
        [self setupScrollView];
        [self setupAccountCard];
        [self setupQuickSettingsCard];
        [self setupInfoCard];
        [self setupSecurityNoticeCard];
    [self setupNavigationBar];
    [self.changePinButton addTarget:self action:@selector(tappedChangePin) forControlEvents:UIControlEventTouchUpInside];
    
    [self.resetPinButton addTarget:self action:@selector(tappedResetPin) forControlEvents:UIControlEventTouchUpInside];
    [self.deactivateButton addTarget:self action:@selector(tappedDeactivatePin) forControlEvents:UIControlEventTouchUpInside];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.contentView];
    
    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:safe.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:safe.bottomAnchor],
        
        [self.contentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [self.contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
        [self.contentView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor],
    ]];
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
    UIImage *badgeImage = [UIImage imageNamed:@"badge-otp"];
    UIImageView *badgeIconView = [[UIImageView alloc] initWithImage:badgeImage];
    badgeIconView.contentMode = UIViewContentModeScaleAspectFit;
    badgeIconView.translatesAutoresizingMaskIntoConstraints = NO;
    badgeIconView.tintColor = [UIColor whiteColor];

    // --- Title Label ---
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Token";
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

#pragma mark - Account Card
- (void)setupAccountCard {
    self.accountCardView = [self createCard];
    
    self.accountIcon = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"building.2"]];
    self.accountIcon.tintColor = [UIColor systemYellowColor];
    self.accountIcon.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.accountLabel = [self createLabel:@"Dangote@221100" fontSize:16 bold:YES];
    self.bankLabel = [self createLabel:@"FirstDirect" fontSize:14 bold:NO];
    self.bankLabel.textColor = [UIColor systemGreenColor];
    self.statusLabel = [self createLabel:@"Active" fontSize:13 bold:NO];
    self.statusLabel.textColor = [UIColor systemGreenColor];
    
    [self.accountCardView addSubview:self.accountIcon];
    [self.accountCardView addSubview:self.accountLabel];
    [self.accountCardView addSubview:self.bankLabel];
    [self.accountCardView addSubview:self.statusLabel];
    [self.contentView addSubview:self.accountCardView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.accountCardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20],
        [self.accountCardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.accountCardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        
        [self.accountIcon.leadingAnchor constraintEqualToAnchor:self.accountCardView.leadingAnchor constant:15],
        [self.accountIcon.centerYAnchor constraintEqualToAnchor:self.accountCardView.centerYAnchor],
        [self.accountIcon.widthAnchor constraintEqualToConstant:30],
        [self.accountIcon.heightAnchor constraintEqualToConstant:30],
        
        [self.accountLabel.leadingAnchor constraintEqualToAnchor:self.accountIcon.trailingAnchor constant:10],
        [self.accountLabel.topAnchor constraintEqualToAnchor:self.accountCardView.topAnchor constant:15],
        
        [self.bankLabel.leadingAnchor constraintEqualToAnchor:self.accountLabel.trailingAnchor constant:8],
        [self.bankLabel.centerYAnchor constraintEqualToAnchor:self.accountLabel.centerYAnchor],
        
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.accountLabel.leadingAnchor],
        [self.statusLabel.topAnchor constraintEqualToAnchor:self.accountLabel.bottomAnchor constant:6],
        [self.accountCardView.bottomAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:15],
    ]];
}

#pragma mark - Quick Settings Card
- (void)setupQuickSettingsCard {
    self.quickSettingsCard = [self createCard];
    
    UILabel *title = [self createLabel:@"Quick Settings" fontSize:16 bold:YES];
    UILabel *subtitle = [self createLabel:@"Manage your PIN and token settings" fontSize:13 bold:NO];
    subtitle.textColor = [UIColor systemGrayColor];
    subtitle.numberOfLines = 0;
    
    self.changePinButton = [self createButton:@"Change PIN" color:[UIColor systemBackgroundColor] textColor:[UIColor labelColor] icon:@"key"];
    self.resetPinButton = [self createButton:@"Reset PIN" color:[UIColor systemBackgroundColor] textColor:[UIColor labelColor] icon:@"arrow.clockwise"];
    self.deactivateButton = [self createButton:@"Deactivate Token" color:[UIColor systemRedColor] textColor:[UIColor whiteColor] icon:@"trash"];
    
    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[self.changePinButton, self.resetPinButton, self.deactivateButton]];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 10;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.quickSettingsCard addSubview:title];
    [self.quickSettingsCard addSubview:subtitle];
    [self.quickSettingsCard addSubview:stack];
    [self.contentView addSubview:self.quickSettingsCard];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.quickSettingsCard.topAnchor constraintEqualToAnchor:self.accountCardView.bottomAnchor constant:20],
        [self.quickSettingsCard.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.quickSettingsCard.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        
        [title.topAnchor constraintEqualToAnchor:self.quickSettingsCard.topAnchor constant:15],
        [title.leadingAnchor constraintEqualToAnchor:self.quickSettingsCard.leadingAnchor constant:15],
        
        [subtitle.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:4],
        [subtitle.leadingAnchor constraintEqualToAnchor:self.quickSettingsCard.leadingAnchor constant:15],
        [subtitle.trailingAnchor constraintEqualToAnchor:self.quickSettingsCard.trailingAnchor constant:-15],
        
        [stack.topAnchor constraintEqualToAnchor:subtitle.bottomAnchor constant:15],
        [stack.leadingAnchor constraintEqualToAnchor:self.quickSettingsCard.leadingAnchor constant:15],
        [stack.trailingAnchor constraintEqualToAnchor:self.quickSettingsCard.trailingAnchor constant:-15],
        [stack.bottomAnchor constraintEqualToAnchor:self.quickSettingsCard.bottomAnchor constant:-15],
    ]];
}

#pragma mark - Info Card
- (void)setupInfoCard {
    self.infoCard = [self createCard];
    
    UILabel *infoTitle = [self createLabel:@"Information" fontSize:16 bold:YES];
    self.versionLabel = [self createLabel:@"Version 1.0.0" fontSize:14 bold:NO];
    self.profileStatusLabel = [self createLabel:@"Profile Status: Active" fontSize:14 bold:NO];
    self.profileStatusLabel.textColor = [UIColor systemGreenColor];
    
    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[self.versionLabel, self.profileStatusLabel]];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 5;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.infoCard addSubview:infoTitle];
    [self.infoCard addSubview:stack];
    [self.contentView addSubview:self.infoCard];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.infoCard.topAnchor constraintEqualToAnchor:self.quickSettingsCard.bottomAnchor constant:20],
        [self.infoCard.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.infoCard.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        
        [infoTitle.topAnchor constraintEqualToAnchor:self.infoCard.topAnchor constant:15],
        [infoTitle.leadingAnchor constraintEqualToAnchor:self.infoCard.leadingAnchor constant:15],
        
        [stack.topAnchor constraintEqualToAnchor:infoTitle.bottomAnchor constant:10],
        [stack.leadingAnchor constraintEqualToAnchor:self.infoCard.leadingAnchor constant:15],
        [stack.trailingAnchor constraintEqualToAnchor:self.infoCard.trailingAnchor constant:-15],
        [stack.bottomAnchor constraintEqualToAnchor:self.infoCard.bottomAnchor constant:-15],
    ]];
}


-(void)tappedChangePin{
    if(self.changePinButton){
        ResetPinVC *oldVc=[[ResetPinVC alloc] init];
        [self.navigationController pushViewController:oldVc animated:YES];
    }
}


-(void)tappedResetPin{
    if(self.changePinButton){
        ResetPinVC *oldVc=[[ResetPinVC alloc] init];
        [self.navigationController pushViewController:oldVc animated:YES];
    }
}


-(void)tappedDeactivatePin{
    if(self.changePinButton){
        DeactivateTokenVC *oldVc=[[DeactivateTokenVC alloc] init];
        [self.navigationController pushViewController:oldVc animated:YES];
    }
}



#pragma mark - Security Notice
- (void)setupSecurityNoticeCard {
    self.securityNoticeCard = [self createCard];
    
    self.noticeLabel = [self createLabel:@"All PIN changes and token operations require authentication. Keep your PIN secure and never share it with anyone."
                                fontSize:13
                                   bold:NO];
    self.noticeLabel.textColor = [UIColor systemGrayColor];
    self.noticeLabel.numberOfLines = 0;
    
    [self.securityNoticeCard addSubview:self.noticeLabel];
    [self.contentView addSubview:self.securityNoticeCard];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.securityNoticeCard.topAnchor constraintEqualToAnchor:self.infoCard.bottomAnchor constant:20],
        [self.securityNoticeCard.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.securityNoticeCard.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.securityNoticeCard.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-40],
        
        [self.noticeLabel.topAnchor constraintEqualToAnchor:self.securityNoticeCard.topAnchor constant:15],
        [self.noticeLabel.leadingAnchor constraintEqualToAnchor:self.securityNoticeCard.leadingAnchor constant:15],
        [self.noticeLabel.trailingAnchor constraintEqualToAnchor:self.securityNoticeCard.trailingAnchor constant:-15],
        [self.noticeLabel.bottomAnchor constraintEqualToAnchor:self.securityNoticeCard.bottomAnchor constant:-15],
    ]];
}

-(void)supportTapped {
    NSLog(@"Support button tapped");
}

#pragma mark - Helper Methods
- (UIView *)createCard {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [UIColor systemBackgroundColor];
    card.layer.cornerRadius = 12;
    card.layer.shadowColor = [UIColor blackColor].CGColor;
    card.layer.shadowOpacity = 0.05;
    card.layer.shadowRadius = 3;
    return card;
}

- (UILabel *)createLabel:(NSString *)text fontSize:(CGFloat)size bold:(BOOL)bold {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = bold ? [UIFont boldSystemFontOfSize:size] : [UIFont systemFontOfSize:size];
    return label;
}

- (UIButton *)createButton:(NSString *)title color:(UIColor *)color textColor:(UIColor *)textColor icon:(NSString *)systemIcon {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = color;
    button.tintColor = textColor;
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.cornerRadius = 8;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor systemGray5Color].CGColor;
    button.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [button.heightAnchor constraintEqualToConstant:45].active = YES;
    return button;
}

@end
