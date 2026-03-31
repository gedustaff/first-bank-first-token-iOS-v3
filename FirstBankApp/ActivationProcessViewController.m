//
//  ActivationProcessViewController.m
//  FirstBankApp
//
//  Created by cbc gedu on 21/07/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "ActivationProcessViewController.h"
#import "LineDrawingView.h"

@interface ActivationProcessViewController ()

@end

@implementation ActivationProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;

    [self configureLineDrawingView];
    
    self.nextButton.layer.cornerRadius = 8.0;
    self.nextButton.layer.borderWidth =2.0;
    self.nextButton.clipsToBounds=YES;

}

#pragma mark - UI Setup

- (void)configureLineDrawingView {
    LineDrawingView *myLineView = [[LineDrawingView alloc] initWithFrame:CGRectZero];
    myLineView.lineColor = [UIColor yellowColor];
    myLineView.lineWidth = 3.0;
    myLineView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:myLineView];

    // Ensure instructionsStackView exists
    if (self.instructionsStackView) {
        [NSLayoutConstraint activateConstraints:@[
            [myLineView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
            [myLineView.topAnchor constraintEqualToAnchor:self.instructionsStackView.bottomAnchor constant:30],
            [myLineView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.8],
            [myLineView.heightAnchor constraintEqualToConstant:20]
        ]];
    } else {
        NSLog(@"instructionsStackView is nil. Line view will not be positioned correctly.");
    }
}

#pragma mark - Actions

- (IBAction)nextButton:(id)sender {
    // Instantiate the view controller with storyboard ID
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *accountValidationVC = [storyboard instantiateViewControllerWithIdentifier:@"AccountValidationVCID"];
    
    if (accountValidationVC) {
        [self.navigationController pushViewController:accountValidationVC animated:YES];
    } else {
        NSLog(@" Could not find view controller with identifier 'AccountValidationVCID'");
    }
}

@end

