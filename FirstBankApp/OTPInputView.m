//
//  OTPInputView.m
//  FirstBankApp
//
//  Created by cbc gedu on 08/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "OTPInputView.h"

@implementation OTPInputView

- (instancetype)initWithDigits:(NSInteger)digits {
    self = [super init];
    if (self) {
        _numberOfDigits = digits > 0 ? digits : 6;
        _textFields = [NSMutableArray array];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.distribution = UIStackViewDistributionEqualSpacing;
    stack.spacing = 12;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:stack];
    
    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:self.topAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]
    ]];
    
    for (NSInteger i = 0; i < self.numberOfDigits; i++) {
        UITextField *field = [[UITextField alloc] init];
        field.translatesAutoresizingMaskIntoConstraints = NO;
        field.borderStyle = UITextBorderStyleRoundedRect;
        field.textAlignment = NSTextAlignmentCenter;
        field.keyboardType = UIKeyboardTypeNumberPad;
        field.font = [UIFont boldSystemFontOfSize:20];
        field.delegate = self;
        field.tag = i;
        field.layer.cornerRadius = 8;
        field.layer.borderColor = [UIColor lightGrayColor].CGColor;
        field.layer.borderWidth = 1.0;
        field.textContentType = UITextContentTypeOneTimeCode;
        
        [field.widthAnchor constraintEqualToConstant:45].active = YES;
        [field.heightAnchor constraintEqualToConstant:50].active = YES;
        
        [stack addArrangedSubview:field];
        [self.textFields addObject:field];
        
        [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length > 1) {
        textField.text = [textField.text substringToIndex:1];
    }

    if (textField.text.length == 1) {
        NSInteger nextIndex = textField.tag + 1;
        if (nextIndex < self.textFields.count) {
            UITextField *nextField = self.textFields[nextIndex];
            [nextField becomeFirstResponder];
        } else {
            [textField resignFirstResponder];
            if ([self.delegate respondsToSelector:@selector(otpInputView:didCompleteOTP:)]) {
                [self.delegate otpInputView:self didCompleteOTP:[self getOTP]];
            }
        }
    } else if (textField.text.length == 0 && textField.tag > 0) {
        NSInteger prevIndex = textField.tag - 1;
        UITextField *prevField = self.textFields[prevIndex];
        [prevField becomeFirstResponder];
    }
}

- (NSString *)getOTP {
    NSMutableString *otp = [NSMutableString string];
    for (UITextField *field in self.textFields) {
        [otp appendString:field.text ?: @""];
    }
    return otp;
}

@end
