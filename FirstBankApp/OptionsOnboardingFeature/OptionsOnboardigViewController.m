//
//  OptionsOnboardigViewController.m
//  FirstBankApp
//

#import "TermsViewController.h"
#import "RegistrationCodeViewController.h"
#import "OptionsOnboardigViewController.h"
#import "ActivationProcessViewController.h"

@interface OptionsOnboardigViewController ()

@end

@implementation OptionsOnboardigViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Style UI
    [self setupUI];
}

#pragma mark - UI Setup

- (void)setupUI {
    [self styleOptionView:self.FacialStack];
    [self styleOptionView:self.DebitCardStack];

    [self addTapEffect:self.FacialStack];
    [self addTapEffect:self.DebitCardStack];

    // Titles
    self.facialTitleLabel.text = @"Biometric";
    self.debitCardTitleLabel.text = @"Debit Card";

    self.facialTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.debitCardTitleLabel.font = [UIFont boldSystemFontOfSize:16];

    self.facialTitleLabel.textColor = [UIColor darkTextColor];
    self.debitCardTitleLabel.textColor = [UIColor darkTextColor];
}

- (void)styleOptionView:(UIView *)view {
    view.layer.cornerRadius = 12.0;
    view.layer.borderWidth = 1.5;
    view.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;

    // Shadow for modern card look
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.1;
    view.layer.shadowOffset = CGSizeMake(0, 2);
    view.layer.shadowRadius = 4;

    view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Tap Handling

- (void)addTapEffect:(UIView *)view {
    view.userInteractionEnabled = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionTapped:)];
    [view addGestureRecognizer:tap];
}

- (void)optionTapped:(UITapGestureRecognizer *)gesture {
    UIView *view = gesture.view;

    [self animateSelection:view];

    if (view == self.FacialStack) {
        [self handleSelectionForDestination:TermsAcceptanceDestinationBiometric];
    } else if (view == self.DebitCardStack) {
        [self handleSelectionForDestination:TermsAcceptanceDestinationDebitCard];
    }
}

- (void)animateSelection:(UIView *)view {
    [UIView animateWithDuration:0.15 animations:^{
        view.transform = CGAffineTransformMakeScale(0.96, 0.96);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            view.transform = CGAffineTransformIdentity;
        }];
    }];
}

#pragma mark - Selection Logic

- (void)handleSelectionForDestination:(TermsAcceptanceDestination)destination {
    BOOL termsAccepted = [[NSUserDefaults standardUserDefaults] boolForKey:@"termsAccepted"];

    if (termsAccepted) {
        [self proceedToDestination:destination];
    } else {
        [self presentTermsForDestination:destination];
    }
}

- (void)proceedToDestination:(TermsAcceptanceDestination)destination {
    if (destination == TermsAcceptanceDestinationBiometric) {
        NSLog(@"Navigating to Biometric Flow");
        [self navigateToViewControllerWithIdentifier:@"ActivationProcessVC"];
    } else {
        NSLog(@"Navigating to Debit Card Flow");
        [self navigateToViewControllerWithIdentifier:@"cardNum"];
    }
}

- (void)presentTermsForDestination:(TermsAcceptanceDestination)destination {
    NSLog(@"Presenting Terms & Conditions");

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    TermsViewController *termsVC = [storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
    termsVC.delegate = self;
    termsVC.destinationType = destination;

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:termsVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;

    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Navigation Helper

- (void)navigateToViewControllerWithIdentifier:(NSString *)identifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *destinationVC = [storyboard instantiateViewControllerWithIdentifier:identifier];

    if (self.navigationController) {
        [self.navigationController pushViewController:destinationVC animated:YES];
    } else {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:destinationVC];
        navController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:navController animated:YES completion:nil];
    }
}

#pragma mark - IBActions (Optional fallback if still connected)

- (IBAction)biometricButtonTapped:(id)sender {
    [self handleSelectionForDestination:TermsAcceptanceDestinationBiometric];
}

- (IBAction)debitCardButtonTapped:(id)sender {
    [self handleSelectionForDestination:TermsAcceptanceDestinationDebitCard];
}

#pragma mark - TermsViewControllerDelegate

- (void)termViewVCDidAcceptTerms:(TermsViewController *)termsVC
                 forDestination:(TermsAcceptanceDestination)destination {

    NSLog(@"Terms accepted. Proceeding...");

    // Save acceptance
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"termsAccepted"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self proceedToDestination:destination];
}

@end


////
////  OptionsOnboardigViewController.m
////  FirstBankApp
////
////  Created by cbc gedu on 02/07/2025.
////  Copyright © 2025 Gedu Technologies. All rights reserved.
////
//
//#import "TermsViewController.h"
//#import "RegistrationCodeViewController.h"
//#import "OptionsOnboardigViewController.h"
//#import "ActivationProcessViewController.h"
//// #import "AddIdentityViewController.h" // Removed this import as it's not used in the provided logic
//
//@interface OptionsOnboardigViewController ()
//
//@end
//
//@implementation OptionsOnboardigViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//
//    // Apply styling to the UIStackViews
//    self.FacialStack.layer.cornerRadius = 8.0;
//    self.FacialStack.layer.borderWidth=2.0;
//    self.FacialStack.layer.borderColor= [UIColor lightGrayColor].CGColor;
//
//    self.DebitCardStack.layer.cornerRadius=8.0;
//    self.DebitCardStack.layer.borderWidth=2.0;
//    self.DebitCardStack.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    
//    // Stack Styling
//       self.FacialStack.layer.cornerRadius = 8.0;
//       self.FacialStack.layer.borderWidth = 2.0;
//       self.FacialStack.layer.borderColor = [UIColor lightGrayColor].CGColor;
//
//       self.DebitCardStack.layer.cornerRadius = 8.0;
//       self.DebitCardStack.layer.borderWidth = 2.0;
//       self.DebitCardStack.layer.borderColor = [UIColor lightGrayColor].CGColor;
//
//       // ✅ FIX: Ensure titles are set
//       self.facialTitleLabel.text = @"Biometric";
//       self.debitCardTitleLabel.text = @"Debit Card";
//
//       // Make sure text is visible
//       self.facialTitleLabel.textColor = [UIColor blackColor];
//       self.debitCardTitleLabel.textColor = [UIColor blackColor];
//
//    // --- RESPONSIVENESS HINT ---
//    // For these UIStackViews (FacialStack and DebitCardStack) to be responsive
//    // across different device sizes and orientations, ensure they have proper
//    // Auto Layout constraints set in your Storyboard:
//    // 1. Position constraints (e.g., center horizontally, top/bottom spacing to safe area or other elements).
//    // 2. Size constraints (e.g., fixed width/height, or proportional width/height to the superview,
//    //    or intrinsic content size if content drives size).
//    // 3. For UIStackViews, also consider their 'distribution' (e.g., .fillEqually, .fillProportionally)
//    //    and 'alignment' properties in the Attributes Inspector to control how their
//    //    arranged subviews behave within the stack.
//    // --------------------------
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//// This method is typically used for passing data before a segue performs.
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//
//// Helper method to navigate to a specific view controller
//// This method handles both pushing onto a navigation stack or presenting modally.
//- (void)navigateToViewControllerWithIdentifier:(NSString *)identifier {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *destinationVC = [storyboard instantiateViewControllerWithIdentifier:identifier];
//
//    // Check if the current view controller is embedded in a navigation controller.
//    if (self.navigationController) {
//        // If yes, push the destination view controller onto the navigation stack.
//        [self.navigationController pushViewController:destinationVC animated:YES];
//    } else {
//        // If no, present the destination view controller modally.
//        // It's often good practice to embed modally presented VCs in a UINavigationController
//        // if they need a navigation bar (e.g., for a "Done" or "Cancel" button).
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:destinationVC];
//        navController.modalPresentationStyle = UIModalPresentationFullScreen; // Ensure full screen presentation
//        [self presentViewController:navController animated:YES completion:nil];
//    }
//}
//
//
//// This method is called when the "Debit Card" button is tapped.
//- (IBAction)debitCardButtonTapped:(id)sender {
//    // Check if terms and conditions have already been accepted
//    BOOL termsAccepted = [[NSUserDefaults standardUserDefaults] boolForKey:@"termsAccepted"];
//
//    if (termsAccepted) {
//        // If terms are accepted, navigate directly to the RegistrationCodeViewController
//        NSLog(@"Terms already accepted for Debit Card flow. Navigating directly to Card Detail Registration.");
//        [self navigateToViewControllerWithIdentifier:@"cardNum"]; // Use your actual Storyboard ID for RegistrationCodeViewController
//    } else {
//        // If terms are not accepted, present the Terms and Conditions view controller
//        NSLog(@"Terms not accepted for Debit Card flow. Presenting TermsViewController.");
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        TermsViewController *termsVC = [storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"]; // Use your actual Storyboard ID for TermsViewController
//
//        // Set this view controller as the delegate for TermsViewController
//        termsVC.delegate = self;
//        // Pass the intended destination type so TermsViewController knows where to navigate after acceptance
//        termsVC.destinationType = TermsAcceptanceDestinationDebitCard;
//
//        // Present TermsViewController modally, embedded in a UINavigationController
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:termsVC];
//        navController.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:navController animated:YES completion:nil];
//    }
//}
//
//
//
//// This method is called when the "Biometric" button is tapped.
//- (IBAction)biometricButtonTapped:(id)sender {
//    // Check if terms and conditions have already been accepted
//    BOOL termsAccepted = [[NSUserDefaults standardUserDefaults] boolForKey:@"termsAccepted"];
//
//    if (termsAccepted) {
//        // If terms are accepted, navigate directly to the BiometricViewController
//        NSLog(@"Terms already accepted for Biometric flow. Navigating directly to ActivationProcessVC.");
//        [self navigateToViewControllerWithIdentifier:@"ActivationProcessVC"]; // Use your actual Storyboard ID for ActivationProcessVC (Biometric)
//    } else {
//        // If terms are not accepted, present the Terms and Conditions view controller
//        NSLog(@"Terms not accepted for Biometric flow. Presenting TermsViewController.");
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        TermsViewController *termsVC = [storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"]; // Use your actual Storyboard ID for TermsViewController
//
//        // Set this view controller as the delegate for TermsViewController
//        termsVC.delegate = self;
//        // Pass the intended destination type so TermsViewController knows where to navigate after acceptance
//        termsVC.destinationType = TermsAcceptanceDestinationBiometric;
//
//        // Present TermsViewController modally, embedded in a UINavigationController
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:termsVC];
//        navController.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:navController animated:YES completion:nil];
//    }
//}
//
//
//#pragma mark - TermsViewControllerDelegate
//
//// This delegate method is called when the user accepts terms in TermsViewController
//// The method name here MUST EXACTLY MATCH the protocol definition in TermsViewController.h
//- (void)termViewVCDidAcceptTerms:(TermsViewController *)termsVC forDestination:(TermsAcceptanceDestination)destination {
//    NSLog(@"Terms accepted from TermsViewController. Continuing to original destination.");
//
//    // Now, based on the destinationType passed back, navigate to the correct final screen
//    if (destination == TermsAcceptanceDestinationBiometric) {
//        [self navigateToViewControllerWithIdentifier:@"ActivationProcessVC"]; // Navigate to Biometric setup
//    } else if (destination == TermsAcceptanceDestinationDebitCard) {
//        [self navigateToViewControllerWithIdentifier:@"cardNum"]; // Navigate to Registration (Debit Card)
//    }
//}
//@end
//
