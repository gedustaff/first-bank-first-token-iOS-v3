//
//  ProfilesViewController.m
//  FirstBankApp
//
//  Created by cbc gedu on 29/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "ProfilesViewController.h"
#import "CompanyProfileCell.h"
#import "EnterPinViewController.h"
#import "CorporateEnrollmentViewController.h"
#import "ProfileManager.h"

@interface ProfilesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *companies;
@end

@implementation ProfilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"My Profiles";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    self.companies = [ProfileManager loadProfiles];
    
    if (self.companies.count == 0) {
            NSLog(@"No profiles found. Displaying empty state.");
            // You might want to display a label or image here for an empty state.
        }

//    self.companies = @[
//        @{@"name": @"Dangote Group Inc", @"id": @"dangote@221100", @"status": @"Active", @"tag": @"FirstDirect"},
//        @{@"name": @"Flour Mills Plc", @"id": @"flour@112233", @"status": @"Active", @"tag": @"FinServe"}
//    ];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CompanyProfileCell class] forCellReuseIdentifier:@"CompanyProfileCell"];
    [self.view addSubview:self.tableView];

    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [addButton setTitle:@"+  Add Another Profile" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    addButton.layer.borderColor = [UIColor colorWithRed:0 green:0.2 blue:0.5 alpha:1].CGColor;
    addButton.layer.borderWidth = 1.0;
    addButton.layer.cornerRadius = 10.0;
    addButton.translatesAutoresizingMaskIntoConstraints = NO;
    [addButton addTarget:self action:@selector(addProfileTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];

    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:addButton.topAnchor constant:-20],

        [addButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:30],
        [addButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-30],
        [addButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-30],
        [addButton.heightAnchor constraintEqualToConstant:50],
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
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *backBtnImage = [[UIImage imageNamed:@"arrow-back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [backButton setImage:backBtnImage forState:UIControlStateNormal];
//    backButton.tintColor = [UIColor whiteColor];
//    backButton.translatesAutoresizingMaskIntoConstraints = NO;
//    backButton.userInteractionEnabled = YES;
//    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];

    // --- Badge Icon (Next to Back Button) ---
    UIImage *badgeImage = [UIImage imageNamed:@"profile-icon"];
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
//    [leftContainerView addSubview:backButton];
    [leftContainerView addSubview:badgeIconView];
    [leftContainerView addSubview:titleLabel];

    // ---  Layout Constraints ---
    [NSLayoutConstraint activateConstraints:@[
        // Back Button
//        [backButton.leadingAnchor constraintEqualToAnchor:leftContainerView.leadingAnchor constant:0],
//        [backButton.centerYAnchor constraintEqualToAnchor:leftContainerView.centerYAnchor],
//        [backButton.widthAnchor constraintEqualToConstant:30],
//        [backButton.heightAnchor constraintEqualToConstant:30],

        // Badge Icon (Right of back button)
        [badgeIconView.leadingAnchor constraintEqualToAnchor:leftContainerView.leadingAnchor constant:0],
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
    UIImage *chatImage = [[UIImage imageNamed:@"plus-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithImage:chatImage
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(supportTapped)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.companies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyProfileCell" forIndexPath:indexPath];
    [cell configureWithCompany:self.companies[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected: %@", self.companies[indexPath.row][@"name"]);
    EnterPinViewController *enterPInVC = [[EnterPinViewController alloc] init];
    [self.navigationController pushViewController:enterPInVC animated:YES];
    
}

- (void)supportTapped {
    CorporateEnrollmentViewController *supportVC = [[CorporateEnrollmentViewController alloc] init];
    [self.navigationController pushViewController:supportVC animated:YES];
}
- (void)addProfileTapped {
    NSLog(@"Add Another Profile tapped!");
    // Push new profile creation screen
    CorporateEnrollmentViewController *supportVC = [[CorporateEnrollmentViewController alloc] init];
    [self.navigationController pushViewController:supportVC animated:YES];
}



@end
