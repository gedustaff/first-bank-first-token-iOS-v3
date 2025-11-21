#import "SoftTokenViewController.h"
#import "SDKUtils.h"
#import "TempGetOtp.h"
#import <EntrustIGMobile/ETIdentity.h>
#import "InstructionCardView.h"
#import "SettingsVC.h"

@interface SoftTokenViewController ()

// UI Outlets
@property (nonatomic, strong) UIView *tokenContainer;
@property (nonatomic, strong) UILabel *tokenHeaderLabel;
@property (nonatomic, strong) UILabel *tokenCodeLabel;
@property (nonatomic, strong) UILabel *expiresLabel;
@property (nonatomic, strong) UIButton *CopyButton;
@property (nonatomic, strong) UIButton *generateButton;
@property (nonatomic, strong) UIImageView *securityIcon;
@property (nonatomic, strong) NSTimer *tokenTimer;
@property (nonatomic, assign) NSInteger remainingSeconds;
@property (nonatomic, strong) InstructionCardView *instructionView;

// Account Info
@property (nonatomic, strong) UIView *accountCardView;
@property (nonatomic, strong) UIImageView *accountIcon;
@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UILabel *bankLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end


@implementation SoftTokenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];

    [self setupBackButton];
    [self setupSoftTokenView];
    [self setupConstraints];
    [self setupNavigationBar];
    
}

#pragma mark - Setup UI

- (void)setupSoftTokenView {
    // --- Account Card ---
    self.accountCardView = [[UIView alloc] init];
    self.accountCardView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    self.accountCardView.layer.cornerRadius = 8;
    self.accountCardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.accountCardView];

    self.accountIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Vector"]];
    self.accountIcon.translatesAutoresizingMaskIntoConstraints = NO;
    self.accountIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.accountCardView addSubview:self.accountIcon];

    self.accountLabel = [[UILabel alloc] init];
    self.accountLabel.text = @"Dangote@221100";
    self.accountLabel.font = [UIFont boldSystemFontOfSize:16];
    self.accountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.accountCardView addSubview:self.accountLabel];

    self.bankLabel = [[UILabel alloc] init];
    self.bankLabel.text = @"FirstDirect";
    self.bankLabel.font = [UIFont systemFontOfSize:13];
    self.bankLabel.textColor = [UIColor systemGreenColor];
    self.bankLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.accountCardView addSubview:self.bankLabel];

    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.text = @"Active";
    self.statusLabel.font = [UIFont systemFontOfSize:13];
    self.statusLabel.textColor = [UIColor systemGreenColor];
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.accountCardView addSubview:self.statusLabel];

    // --- Token Container ---
    self.tokenContainer = [[UIView alloc] init];
    self.tokenContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.tokenContainer.backgroundColor = [UIColor whiteColor];
    self.tokenContainer.layer.cornerRadius = 10;
    self.tokenContainer.layer.shadowColor = [UIColor grayColor].CGColor;
    self.tokenContainer.layer.shadowOpacity = 0.1;
    self.tokenContainer.layer.shadowOffset = CGSizeMake(0, 2);
    [self.view addSubview:self.tokenContainer];

    // --- Icon & Header ---
    self.securityIcon = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"lock.shield"]];
    self.securityIcon.translatesAutoresizingMaskIntoConstraints = NO;
    self.securityIcon.tintColor = [UIColor colorWithRed:0.2 green:0.7 blue:0.3 alpha:1.0];
    [self.tokenContainer addSubview:self.securityIcon];

    self.tokenHeaderLabel = [[UILabel alloc] init];
    self.tokenHeaderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.tokenHeaderLabel.text = @"Your Soft Token";
    self.tokenHeaderLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    self.tokenHeaderLabel.textColor = [UIColor darkGrayColor];
    [self.tokenContainer addSubview:self.tokenHeaderLabel];

    // --- Token Code ---
    self.tokenCodeLabel = [[UILabel alloc] init];
    self.tokenCodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.tokenCodeLabel.text = @"1265 8694";
    self.tokenCodeLabel.font = [UIFont systemFontOfSize:45 weight:UIFontWeightHeavy];
    self.tokenCodeLabel.textColor = [UIColor systemBlueColor];
    self.tokenCodeLabel.textAlignment = NSTextAlignmentCenter;
    [self.tokenContainer addSubview:self.tokenCodeLabel];

    // --- Expires Label ---
    self.expiresLabel = [[UILabel alloc] init];
    self.expiresLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.expiresLabel.text = @"Expires in 30s";
    self.expiresLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.expiresLabel.textColor = [UIColor orangeColor];
    self.expiresLabel.textAlignment = NSTextAlignmentCenter;
    [self.tokenContainer addSubview:self.expiresLabel];

    // --- Buttons ---
    self.CopyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.CopyButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.CopyButton setTitle:@"Copy" forState:UIControlStateNormal];
    self.CopyButton.layer.cornerRadius = 5;
    self.CopyButton.layer.borderWidth = 1.0;
    self.CopyButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.CopyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.CopyButton addTarget:self action:@selector(copyTokenToClipboard) forControlEvents:UIControlEventTouchUpInside];
    [self.tokenContainer addSubview:self.CopyButton];

    self.generateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.generateButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.generateButton setTitle:@"Generate new" forState:UIControlStateNormal];
    [self.generateButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.generateButton addTarget:self action:@selector(generateNewToken) forControlEvents:UIControlEventTouchUpInside];
    [self.tokenContainer addSubview:self.generateButton];
    
    
    self.instructionView = [[InstructionCardView alloc]
        initWithTitle:@"Security Note"
        items:@[
            @"This token is valid for 30 seconds. Use it immediately for your transaction authentication. The app will automatically log out when the token expires."
        ]
        style:InstructionListStyleNone];

    [self.view addSubview:self.instructionView];
}

#pragma mark - Layout Constraints

- (void)setupConstraints {
    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;

    [NSLayoutConstraint activateConstraints:@[
        // --- Account Card ---
        [self.accountCardView.topAnchor constraintEqualToAnchor:safe.topAnchor constant:20],
        [self.accountCardView.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:20],
        [self.accountCardView.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-20],
        [self.accountCardView.heightAnchor constraintEqualToConstant:80],

        // Icon
        [self.accountIcon.leadingAnchor constraintEqualToAnchor:self.accountCardView.leadingAnchor constant:15],
        [self.accountIcon.centerYAnchor constraintEqualToAnchor:self.accountCardView.centerYAnchor],
        [self.accountIcon.widthAnchor constraintEqualToConstant:30],
        [self.accountIcon.heightAnchor constraintEqualToConstant:30],

        // Account Label
        [self.accountLabel.leadingAnchor constraintEqualToAnchor:self.accountIcon.trailingAnchor constant:10],
        [self.accountLabel.topAnchor constraintEqualToAnchor:self.accountCardView.topAnchor constant:15],

        // Bank Label
        [self.bankLabel.leadingAnchor constraintEqualToAnchor:self.accountLabel.trailingAnchor constant:8],
        [self.bankLabel.centerYAnchor constraintEqualToAnchor:self.accountLabel.centerYAnchor],

        // Status Label
        
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.accountLabel.leadingAnchor],
     
        
        [self.statusLabel.topAnchor constraintEqualToAnchor:self.accountLabel.bottomAnchor constant:8],
    ]];

    // --- Token Container ---
    [NSLayoutConstraint activateConstraints:@[
        [self.tokenContainer.topAnchor constraintEqualToAnchor:self.accountCardView.bottomAnchor constant:30],
        [self.tokenContainer.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:20],
        [self.tokenContainer.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-20],
        [self.tokenContainer.bottomAnchor constraintLessThanOrEqualToAnchor:safe.bottomAnchor constant:-20]
    ]];

    // Icon & Header
    [NSLayoutConstraint activateConstraints:@[
        [self.securityIcon.topAnchor constraintEqualToAnchor:self.tokenContainer.topAnchor constant:25],
        [self.securityIcon.centerXAnchor constraintEqualToAnchor:self.tokenContainer.centerXAnchor],
        [self.securityIcon.widthAnchor constraintEqualToConstant:40],
        [self.securityIcon.heightAnchor constraintEqualToConstant:40],

        [self.tokenHeaderLabel.topAnchor constraintEqualToAnchor:self.securityIcon.bottomAnchor constant:10],
        [self.tokenHeaderLabel.centerXAnchor constraintEqualToAnchor:self.tokenContainer.centerXAnchor],
    ]];

    // Token Code
    [NSLayoutConstraint activateConstraints:@[
        [self.tokenCodeLabel.topAnchor constraintEqualToAnchor:self.tokenHeaderLabel.bottomAnchor constant:20],
        [self.tokenCodeLabel.leadingAnchor constraintEqualToAnchor:self.tokenContainer.leadingAnchor constant:20],
        [self.tokenCodeLabel.trailingAnchor constraintEqualToAnchor:self.tokenContainer.trailingAnchor constant:-20],
    ]];

    // Expires Label
    [NSLayoutConstraint activateConstraints:@[
        [self.expiresLabel.topAnchor constraintEqualToAnchor:self.tokenCodeLabel.bottomAnchor constant:10],
        [self.expiresLabel.centerXAnchor constraintEqualToAnchor:self.tokenContainer.centerXAnchor],
    ]];

    // Buttons
    [NSLayoutConstraint activateConstraints:@[
        [self.CopyButton.topAnchor constraintEqualToAnchor:self.expiresLabel.bottomAnchor constant:25],
        [self.CopyButton.leadingAnchor constraintEqualToAnchor:self.tokenContainer.leadingAnchor constant:25],
        [self.CopyButton.heightAnchor constraintEqualToConstant:44],
        [self.CopyButton.widthAnchor constraintEqualToAnchor:self.tokenContainer.widthAnchor multiplier:0.4],

        [self.generateButton.topAnchor constraintEqualToAnchor:self.expiresLabel.bottomAnchor constant:25],
        [self.generateButton.trailingAnchor constraintEqualToAnchor:self.tokenContainer.trailingAnchor constant:-25],
        [self.generateButton.heightAnchor constraintEqualToConstant:44],
        [self.generateButton.widthAnchor constraintEqualToAnchor:self.CopyButton.widthAnchor],
        
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.instructionView.topAnchor constraintEqualToAnchor:self.CopyButton.bottomAnchor constant:30],
        [self.instructionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.instructionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20]
    ]
     
     ];
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
    UIImage *chatImage = [[UIImage imageNamed:@"setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
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

#pragma mark - Navigation
- (void)setupBackButton {
    if (self.navigationController) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"chevron.left"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(backButtonTapped)];
        backItem.tintColor = [UIColor systemBlueColor];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

//- (void)backButtonTapped {
//    if (self.navigationController) {
//        [self.navigationController popViewControllerAnimated:YES];
//    } else {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//}


-(void)supportTapped{
    
    SettingsVC *setting=[[SettingsVC alloc]init];
    [self.navigationController pushViewController:setting animated:YES];
    
}

#pragma mark - Token Logic
- (void)startTokenTimer {
    self.remainingSeconds = 30;
    [self updateExpiresLabel];

    self.tokenTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(decrementTimer)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void)decrementTimer {
    self.remainingSeconds--;
    [self updateExpiresLabel];

    if (self.remainingSeconds <= 0) {
        [self.tokenTimer invalidate];
        self.tokenTimer = nil;
        self.expiresLabel.text = @"Expired";
    }
}

- (void)updateExpiresLabel {
    self.expiresLabel.text = [NSString stringWithFormat:@"Expires in %lds", (long)self.remainingSeconds];
}

- (void)generateNewToken {
    [self.tokenTimer invalidate];
    self.tokenTimer = nil;

    NSString *newToken = [self generateMockToken];
    self.tokenCodeLabel.text = newToken;
    [self startTokenTimer];
    [self animateTokenRefresh];
}

- (NSString *)generateMockToken {
    int group1 = arc4random_uniform(10000);
    int group2 = arc4random_uniform(10000);
    return [NSString stringWithFormat:@"%04d %04d", group1, group2];
}

#pragma mark - Copy
- (void)copyTokenToClipboard {
    NSString *token = [self.tokenCodeLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[UIPasteboard generalPasteboard] setString:token];
    [self showCopySuccessAlert];
    [self animateCopyButtonSuccess];
}

- (void)showCopySuccessAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Copied!"
                                                                   message:@"Token copied to clipboard."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)animateCopyButtonSuccess {
    UIColor *originalColor = self.CopyButton.backgroundColor;
    [UIView animateWithDuration:0.2 animations:^{
        self.CopyButton.backgroundColor = [UIColor systemGreenColor];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0.3 options:0 animations:^{
            self.CopyButton.backgroundColor = originalColor;
        } completion:nil];
    }];
}

- (void)animateTokenRefresh {
    self.tokenCodeLabel.alpha = 0.0;
    self.expiresLabel.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.tokenCodeLabel.alpha = 1.0;
        self.expiresLabel.alpha = 1.0;
    }];
}

@end

