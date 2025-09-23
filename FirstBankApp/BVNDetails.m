//
//  BVNDetails.m
//  FirstBankApp
//
//  Created by cbc gedu on 25/07/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "BVNDetails.h"
//#import <SmileID/SmileID-Swift.h> 
//#import "FirstBankApp-Swift.h"


//@import SmileID;



@interface BVNDetails ()

@end

@implementation BVNDetails

@synthesize passedData; // Synthesize the passedData property
@synthesize fullPassedData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialize the viewModel and link back to the controller
 

    self.continueButton.layer.cornerRadius=8.0;
    self.continueButton.layer.borderWidth=2.0;
    self.continueButton.layer.borderColor=[UIColor lightGrayColor].CGColor;

    // Log the received passedData for debugging
    NSLog(@"BVNDetailsVC received passedData: %@", self.passedData);
    NSLog(@"BVNDETAILVC, receive fullPassedData: %@", self.fullPassedData);

    // Populate labels with data from passedData
    if (self.passedData) {
        NSString *firstName = self.passedData[@"firstName"] ?: @"";
        NSString *middleName = self.passedData[@"middleName"] ?: @"";
        NSString *lastName = self.passedData[@"lastName"] ?: @"";

        // Construct the full name
        NSMutableString *fullName = [NSMutableString string];
        if (firstName.length > 0) {
            [fullName appendString:firstName];
        }
        if (middleName.length > 0 && ![middleName isEqual:[NSNull null]]) { // Check for NSNull and length
            if (fullName.length > 0) {
                [fullName appendString:@" "]; // Add space if first name exists
            }
            [fullName appendString:middleName];
        }
        if (lastName.length > 0) {
            if (fullName.length > 0) {
                [fullName appendString:@" "]; // Add space if first/middle name exists
            }
            [fullName appendString:lastName];
        }

        // Set the combined full name to the titleLabel
        self.titleLabel.text = fullName.length > 0 ? fullName : @"User Details"; // Default if no name parts
        
        // Clear or hide individual name labels if they are not meant for separate display
     

        // You can also set other details if you have labels for them
        // self.accountNumberLabel.text = self.passedData[@"accountNumber"] ?: @"N/A";
        // self.bvnLabel.text = self.passedData[@"bvn"] ?: @"N/A";
        // etc.

    } else {
        NSLog(@"Error: passedData is nil in BVNDetailsVC. Cannot populate details.");
        // Set default error text or hide labels if data is missing
        self.titleLabel.text = @"Error Loading Data";
//        self.firstNameLabel.text = @"";
//        self.middleNameLabel.hidden = YES;
//        self.lastNameLabel.text = @"";
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// --- IMPORTANT: Hide the navigation bar when this view controller appears ---
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

// --- IMPORTANT: Show the navigation bar again when this view controller disappears ---
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

#pragma mark - IBActions
//


- (void)showSmartSelfieCapture {
    SelfieCaptureViewController *selfieVC = [[SelfieCaptureViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selfieVC];
    [navController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:navController animated:YES completion:nil];
}


- (IBAction)continueButtonTapped:(UIButton *)sender {
    // Call the static helper method from Swift
//     UIViewController *selfieVC = [SmileIDUIHelper makeSelfieCaptureViewController];
//     
//     UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selfieVC];
//     [navController setModalPresentationStyle:UIModalPresentationFullScreen];
//     [self presentViewController:navController animated:YES completion:nil];
    UIViewController *vc = [SmileIDUIHelper makeSmartSelfieControllerWithDelegate:self];
       UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
       nav.modalPresentationStyle = UIModalPresentationFullScreen;
       [self presentViewController:nav animated:YES completion:nil];
    
    // Logic to proceed from BVNDetailsVC
    // e.g., [self performSegueWithIdentifier:@"ShowNextScreenFromBVN" sender:self];
}

#pragma mark - Helper Methods (Copy from AccountValidationViewController.m)

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];

    if ([hexString hasPrefix:@"#"]) {
        scanner.scanLocation = 1; // bypass '#' character
    } else {
        scanner.scanLocation = 0; // start from beginning if no '#'
    }

    [scanner scanHexInt:&rgbValue];

    return [UIColor colorWithRed:((rgbValue >> 16) & 0xFF) / 255.0
                           green:((rgbValue >> 8) & 0xFF) / 255.0
                            blue:(rgbValue & 0xFF) / 255.0
                           alpha:1.0];
}

@end

