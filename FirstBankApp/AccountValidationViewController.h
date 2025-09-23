//
//  AccountValidationViewController.h
//  FirstBankApp
//
//  Created by [Your Name] on 23/07/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccountValidationViewController : UIViewController

// IBOutlets for UI elements (connect these in Storyboard)
@property (weak, nonatomic) IBOutlet UITextField *bvnTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) NSMutableDictionary *passedData;
@property(nonatomic, strong) NSMutableDictionary *fullPassedData;


// IBAction for the Submit button (connect this in Storyboard)
- (IBAction)submitButtonTapped:(id)sender;

// Helper method to convert hex string to UIColor
+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END

