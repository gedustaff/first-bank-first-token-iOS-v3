//
//  DeactivateTokenVC.m
//  FirstBankApp
//
//  Created by cbc gedu on 04/11/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "DeactivateTokenVC.h"

@interface DeactivateTokenVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation DeactivateTokenVC

- (void)viewDidLoad {
    [super viewDidLoad];
       self.view.backgroundColor = [UIColor systemGray6Color];
       self.title = @"Deactivate Token";
       
       [self setupNavigationBar];
       [self setupScrollView];
       [self setupAccountCard];
       [self setupConfirmationCard];
       [self setupInfoSection];
}


- (void)setupNavigationBar {
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}



#pragma mark - ScrollView
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



#pragma mark - Account Card
- (void)setupAccountCard {
    UIView *card = [self createCard];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"building.2"]];
    icon.tintColor = [UIColor systemYellowColor];
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *name = [self createLabel:@"Dangote@221100" fontSize:16 bold:YES];
    UILabel *bank = [self createLabel:@"FirstDirect" fontSize:13 bold:YES];
    bank.textColor = [UIColor systemGreenColor];
    
    UIView *dot = [[UIView alloc] init];
    dot.backgroundColor = [UIColor systemGreenColor];
    dot.layer.cornerRadius = 4;
    dot.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *status = [self createLabel:@"Active" fontSize:13 bold:NO];
    status.textColor = [UIColor systemGreenColor];
    
    [card addSubview:icon];
    [card addSubview:name];
    [card addSubview:bank];
    [card addSubview:dot];
    [card addSubview:status];
    [self.contentView addSubview:card];
    
    [NSLayoutConstraint activateConstraints:@[
        [card.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20],
        [card.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [card.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        
        [icon.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:15],
        [icon.centerYAnchor constraintEqualToAnchor:card.centerYAnchor],
        [icon.widthAnchor constraintEqualToConstant:30],
        [icon.heightAnchor constraintEqualToConstant:30],
        
        [name.leadingAnchor constraintEqualToAnchor:icon.trailingAnchor constant:10],
        [name.topAnchor constraintEqualToAnchor:card.topAnchor constant:10],
        
        [bank.leadingAnchor constraintEqualToAnchor:name.leadingAnchor],
        [bank.topAnchor constraintEqualToAnchor:name.bottomAnchor constant:4],
        
        [dot.leadingAnchor constraintEqualToAnchor:bank.trailingAnchor constant:6],
        [dot.centerYAnchor constraintEqualToAnchor:bank.centerYAnchor],
        [dot.widthAnchor constraintEqualToConstant:8],
        [dot.heightAnchor constraintEqualToConstant:8],
        
        [status.leadingAnchor constraintEqualToAnchor:dot.trailingAnchor constant:4],
        [status.centerYAnchor constraintEqualToAnchor:bank.centerYAnchor],
        [card.bottomAnchor constraintEqualToAnchor:bank.bottomAnchor constant:10],
    ]];
}





#pragma mark - Confirmation Card
- (void)setupConfirmationCard {
    UIView *card = [self createCard];
    card.layer.borderColor = [UIColor systemRedColor].CGColor;
    card.layer.borderWidth = 1;
    
    UILabel *title = [self createLabel:@"Confirm Deactivation" fontSize:15 bold:YES];
    title.textColor = [UIColor systemRedColor];
    
    UILabel *desc = [self createLabel:@"Are you sure you want to deactivate this soft token? This action will prevent you from generating tokens for this profile." fontSize:14 bold:NO];
    desc.textColor = [UIColor labelColor];
    desc.numberOfLines = 0;
    
    // Warning box
    UIView *warningBox = [self createCard];
    warningBox.backgroundColor = [UIColor systemGray6Color];
    warningBox.layer.borderWidth = 0.5;
    warningBox.layer.borderColor = [UIColor systemGray4Color].CGColor;
    
    UILabel *warning = [self createLabel:@"Warning: Once deactivated, you will not be able to use this profile for transaction authentication until you re-enroll." fontSize:13 bold:NO];
    warning.numberOfLines = 0;
    [warningBox addSubview:warning];
    [NSLayoutConstraint activateConstraints:@[
        [warning.topAnchor constraintEqualToAnchor:warningBox.topAnchor constant:8],
        [warning.leadingAnchor constraintEqualToAnchor:warningBox.leadingAnchor constant:8],
        [warning.trailingAnchor constraintEqualToAnchor:warningBox.trailingAnchor constant:-8],
        [warning.bottomAnchor constraintEqualToAnchor:warningBox.bottomAnchor constant:-8]
    ]];
    
    // Buttons
    UIButton *confirmBtn = [self createButton:@"Yes, Deactivate Token" color:[UIColor systemRedColor] textColor:[UIColor whiteColor]];
    UIButton *cancelBtn = [self createButton:@"Cancel" color:[UIColor systemGray5Color] textColor:[UIColor systemBlueColor]];
    [confirmBtn addTarget:self action:@selector(confirmDeactivate) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[confirmBtn, cancelBtn]];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 10;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    
    [card addSubview:title];
    [card addSubview:desc];
    [card addSubview:warningBox];
    [card addSubview:stack];
    [self.contentView addSubview:card];
    
    [NSLayoutConstraint activateConstraints:@[
        [card.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:160],
        [card.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [card.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        
        [title.topAnchor constraintEqualToAnchor:card.topAnchor constant:15],
        [title.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:15],
        
        [desc.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:8],
        [desc.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:15],
        [desc.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-15],
        
        [warningBox.topAnchor constraintEqualToAnchor:desc.bottomAnchor constant:12],
        [warningBox.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:15],
        [warningBox.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-15],
        
        [stack.topAnchor constraintEqualToAnchor:warningBox.bottomAnchor constant:15],
        [stack.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:15],
        [stack.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-15],
        [stack.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-15],
    ]];
}



#pragma mark - Info Section
- (void)setupInfoSection {
    UIView *info = [self createCard];
    UILabel *title = [self createLabel:@"What happens after deactivation?" fontSize:15 bold:YES];
    
    UILabel *points = [self createLabel:@"• You will no longer be able to generate tokens for this profile\n• All pending transactions using this profile will be blocked\n• You can re-enroll this profile later if needed" fontSize:13 bold:NO];
    points.numberOfLines = 0;
    points.textColor = [UIColor secondaryLabelColor];
    
    [info addSubview:title];
    [info addSubview:points];
    [self.contentView addSubview:info];
    
    [NSLayoutConstraint activateConstraints:@[
        [info.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:500],
        [info.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [info.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [title.topAnchor constraintEqualToAnchor:info.topAnchor constant:15],
        [title.leadingAnchor constraintEqualToAnchor:info.leadingAnchor constant:15],
        [points.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:10],
        [points.leadingAnchor constraintEqualToAnchor:info.leadingAnchor constant:15],
        [points.trailingAnchor constraintEqualToAnchor:info.trailingAnchor constant:-15],
        [points.bottomAnchor constraintEqualToAnchor:info.bottomAnchor constant:-15]
    ]];
}


#pragma mark - Actions
- (void)confirmDeactivate {
    NSLog(@"Deactivate confirmed");
}

- (void)cancelTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helpers
- (UIView *)createCard {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [UIColor systemBackgroundColor];
    card.layer.cornerRadius = 10;
    card.layer.shadowColor = [UIColor blackColor].CGColor;
    card.layer.shadowOpacity = 0.05;
    card.layer.shadowRadius = 2;
    return card;
}



- (UILabel *)createLabel:(NSString *)text fontSize:(CGFloat)size bold:(BOOL)bold {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = bold ? [UIFont boldSystemFontOfSize:size] : [UIFont systemFontOfSize:size];
    return label;
}


- (UIButton *)createButton:(NSString *)title color:(UIColor *)color textColor:(UIColor *)textColor {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = color;
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    btn.layer.cornerRadius = 8;
    [btn.heightAnchor constraintEqualToConstant:45].active = YES;
    return btn;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
