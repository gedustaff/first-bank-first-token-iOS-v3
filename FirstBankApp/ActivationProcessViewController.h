//
//  ActivationProcessViewController.h
//  FirstBankApp
//
//  Created by cbc gedu on 21/07/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivationProcessViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIStackView *instructionsStackView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


- (IBAction)nextButton:(id)sender;


@end

NS_ASSUME_NONNULL_END
