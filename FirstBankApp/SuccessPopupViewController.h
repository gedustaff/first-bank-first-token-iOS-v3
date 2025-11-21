//
//  SuccessPopupViewController.h
//  FirstBankApp
//
//  Created by cbc gedu on 27/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuccessPopupViewController : UIViewController

@property (nonatomic, strong) NSString *successTitleText;
@property (nonatomic, strong) NSString *successMessageText;
@property (nonatomic, strong) NSString *buttonTitleText;


@property (nonatomic, copy) void (^onContinueTapped)(void);
@property (nonatomic, copy) void (^onCancelTapped)(void);

@property (nonatomic, strong) NSString *cancelButtonText;

@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, copy) void (^onContinue)(void);

@end

