//
//  TermsViewController.h
//  FirstBankApp
//
//  Created by Aliyu Olateju on 02/03/2024.
//  Copyright © 2024 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, TermsAcceptanceDestination) {
    TermsAcceptanceDestinationBiometric,
    TermsAcceptanceDestinationDebitCard
};



// Declare the delegate protocol
@class TermsViewController; // Forward declaration to avoid circular import
@protocol TermsViewControllerDelegate <NSObject>

@required
// Method to notify the delegate that terms were accepted
- (void)termViewVCDidAcceptTerms:(TermsViewController *)termVC forDestination:(TermsAcceptanceDestination)destination;
@end



@interface TermsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *termsTextView;

// Property to hold the delegate
@property (weak, nonatomic) id<TermsViewControllerDelegate> delegate;

// Property to know the original intended destination
@property (nonatomic, assign) TermsAcceptanceDestination destinationType;

- (IBAction)acceptButtonTapped:(UIButton *)sender;
- (IBAction)declineButtonTapped:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
