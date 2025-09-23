//
//  OptionsOnboardigViewController.h
//  FirstBankApp
//
//  Created by cbc gedu on 02/07/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TermsViewController.h"

NS_ASSUME_NONNULL_BEGIN

// THIS IS THE CRUCIAL LINE:
// Declare that this class conforms to the TermsViewControllerDelegate protocol.
// This tells the compiler that OptionsOnboardigViewController will implement
// the methods defined in TermsViewControllerDelegate, specifically
// 'termsViewControllerDidAcceptTerms:forDestination:'.
@interface OptionsOnboardigViewController : UIViewController <TermsViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UILabel *istructionalLabel;
@property (weak, nonatomic) IBOutlet UIStackView *FacialStack;
@property (weak, nonatomic) IBOutlet UIStackView *DebitCardStack;

- (IBAction)biometricButtonTapped:(id)sender;


- (IBAction)debitCardButtonTapped:(id)sender;







@end

NS_ASSUME_NONNULL_END
