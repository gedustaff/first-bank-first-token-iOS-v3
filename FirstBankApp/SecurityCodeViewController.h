//
//  SecurityCodeViewController.h
//  FirstBankApp
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EntrustIGMobile/ETIdentity.h>
#import "SDKUtils.h"
#import "SettingsViewController.h"

@interface SecurityCodeViewController : UIViewController<UITextFieldDelegate>{
    ETIdentity *getIdentity;
    NSString *OTP;
    
}
@property (nonatomic, strong, readwrite) ETIdentity *getIdentity;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) NSTimer *timeout;
@property (nonatomic, weak) NSTimer *idleTimer;
@end
