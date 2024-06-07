//
//  TermsViewController.h
//  FirstBankApp
//
//  Created by Aliyu Olateju on 02/03/2024.
//  Copyright © 2024 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TermsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *termsTextView;
- (IBAction)acceptButtonTapped:(UIButton *)sender;
- (IBAction)declineButtonTapped:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
