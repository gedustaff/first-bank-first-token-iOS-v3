//
//  OTPInputView.h
//  FirstBankApp
//
//  Created by cbc gedu on 08/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTPInputView;

@protocol OTPInputViewDelegate <NSObject>
- (void)otpInputView:(OTPInputView *)otpView didCompleteOTP:(NSString *)otp;
@end

@interface OTPInputView : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id<OTPInputViewDelegate> delegate;
@property (nonatomic, assign) NSInteger numberOfDigits; // default = 6
@property (nonatomic, strong) NSMutableArray<UITextField *> *textFields;
@property (nonatomic, strong, readonly) NSString *enteredOTP;


- (instancetype)initWithDigits:(NSInteger)digits;
- (NSString *)getOTP;

@end

