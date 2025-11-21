//
//  SuccessPopupViewController.m
//  FirstBankApp
//
//  Created by cbc gedu on 27/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "SuccessPopupViewController.h"
#import "AccountConfirmationVCViewController.h"

@interface SuccessPopupViewController ()
@property (nonatomic, strong) UIView *popupView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@end
@implementation SuccessPopupViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self setupPopup];
}

- (void)setupPopup {
    self.popupView = [[UIView alloc] init];
    self.popupView.backgroundColor = [UIColor whiteColor];
    self.popupView.layer.cornerRadius = 12;
    self.popupView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.popupView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.successTitleText ?: @"Success!";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.text = self.successMessageText ?: @"Your operation was completed successfully.";
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.textColor = [UIColor darkGrayColor];
    self.messageLabel.font = [UIFont systemFontOfSize:15];
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.continueButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.continueButton setTitle:(self.buttonTitleText ?: @"Continue") forState:UIControlStateNormal];
    [self.continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.continueButton.backgroundColor = [UIColor colorWithRed:0.03 green:0.2 blue:0.4 alpha:1];
    self.continueButton.layer.cornerRadius = 8;
    self.continueButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.continueButton addTarget:self action:@selector(continueTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.popupView addSubview:self.titleLabel];
    [self.popupView addSubview:self.messageLabel];
    [self.popupView addSubview:self.continueButton];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
       [self.cancelButton setTitle:self.cancelButtonText ?: @"Cancel" forState:UIControlStateNormal];
       [self.cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
       [self.cancelButton addTarget:self action:@selector(handleCancelTapped) forControlEvents:UIControlEventTouchUpInside];
       self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
       [self.popupView addSubview:self.cancelButton];
    
    // Layout
    [NSLayoutConstraint activateConstraints:@[
        // Popup positioning
        [self.popupView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.popupView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.popupView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.8],

        // Title
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.popupView.topAnchor constant:20],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.popupView.leadingAnchor constant:16],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.popupView.trailingAnchor constant:-16],

        // Message
        [self.messageLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:12],
        [self.messageLabel.leadingAnchor constraintEqualToAnchor:self.popupView.leadingAnchor constant:16],
        [self.messageLabel.trailingAnchor constraintEqualToAnchor:self.popupView.trailingAnchor constant:-16],

        // Continue Button
        [self.continueButton.topAnchor constraintEqualToAnchor:self.messageLabel.bottomAnchor constant:20],
        [self.continueButton.leadingAnchor constraintEqualToAnchor:self.popupView.leadingAnchor constant:30],
        [self.continueButton.trailingAnchor constraintEqualToAnchor:self.popupView.trailingAnchor constant:-30],
        [self.continueButton.heightAnchor constraintEqualToConstant:44],

        // Cancel Button (below Continue)
        [self.cancelButton.topAnchor constraintEqualToAnchor:self.continueButton.bottomAnchor constant:10],
        [self.cancelButton.centerXAnchor constraintEqualToAnchor:self.popupView.centerXAnchor],
        [self.cancelButton.bottomAnchor constraintEqualToAnchor:self.popupView.bottomAnchor constant:-20]
    ]];
}

- (void)continueTapped {
    NSLog(@"Continue button tapped");

        if (self.onContinue) {
            // Ensure callback runs fully before dismissing
            __weak typeof(self) weakSelf = self;
            self.continueButton.enabled = NO; // prevent double taps

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                self.onContinue();

                // Dismiss on main thread *after* the callback completes
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    weakSelf.continueButton.enabled = YES;
                });
            });
        } else {
//            [self dismissViewControllerAnimated:YES completion:nil];
        }
}


- (void)handleCancelTapped {
    if (self.onCancelTapped) self.onCancelTapped();
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
