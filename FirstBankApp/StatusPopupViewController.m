//
//  ErrorPopupViewController.m
//  FirstBankApp
//
//  Created by cbc gedu on 08/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "StatusPopupViewController.h"

@interface StatusPopupViewController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *dismissButton;

@end

@implementation StatusPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self setupPopupUI];
}

- (void)setupPopupUI {
    // Container
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 16;
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.containerView];
    
    // Icon
    self.iconView = [[UIImageView alloc] init];
    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.iconView];
    
    // Title
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.titleLabel];
    
    // Message
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.font = [UIFont systemFontOfSize:15];
    self.messageLabel.textColor = [UIColor darkGrayColor];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.messageLabel];
    
    // Dismiss button
    self.dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.dismissButton setTitle:@"OK" forState:UIControlStateNormal];
    [self.dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.dismissButton.layer.cornerRadius = 10;
    self.dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dismissButton addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.dismissButton];
    
    // Layout
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.containerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.containerView.widthAnchor constraintEqualToConstant:300],
        
        [self.iconView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:30],
        [self.iconView.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor],
        [self.iconView.widthAnchor constraintEqualToConstant:70],
        [self.iconView.heightAnchor constraintEqualToConstant:70],
        
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.iconView.bottomAnchor constant:15],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:20],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-20],
        
        [self.messageLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:10],
        [self.messageLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:20],
        [self.messageLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-20],
        
        [self.dismissButton.topAnchor constraintEqualToAnchor:self.messageLabel.bottomAnchor constant:20],
        [self.dismissButton.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor constant:-20],
        [self.dismissButton.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor],
        [self.dismissButton.widthAnchor constraintEqualToConstant:100],
        [self.dismissButton.heightAnchor constraintEqualToConstant:40],
    ]];
    
    [self configurePopup];
}

- (void)configurePopup {
    // Default values
    self.titleLabel.text = self.titleText ?: @"";
    self.messageLabel.text = self.messageText ?: @"";
    
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:60 weight:UIImageSymbolWeightBold];
    
    switch (self.popupType) {
        case PopupTypeSuccess:
            self.iconView.image = [UIImage systemImageNamed:@"checkmark.circle.fill" withConfiguration:config];
            self.iconView.tintColor = [UIColor systemGreenColor];
            self.titleLabel.text = self.titleText ?: @"Success";
            self.dismissButton.backgroundColor = [UIColor systemGreenColor];
            break;
            
        case PopupTypeError:
            self.iconView.image = [UIImage systemImageNamed:@"xmark.circle.fill" withConfiguration:config];
            self.iconView.tintColor = [UIColor systemRedColor];
            self.titleLabel.text = self.titleText ?: @"Error";
            self.dismissButton.backgroundColor = [UIColor systemRedColor];
            break;
            
        case PopupTypeWarning:
            self.iconView.image = [UIImage systemImageNamed:@"exclamationmark.triangle.fill" withConfiguration:config];
            self.iconView.tintColor = [UIColor systemYellowColor];
            self.titleLabel.text = self.titleText ?: @"Warning";
            self.dismissButton.backgroundColor = [UIColor systemYellowColor];
            break;
    }
}

- (void)dismissPopup {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
