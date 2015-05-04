//
//  SecurityCodeViewController.h
//  FirstBankApp
//
//  Created by Gedu Technologies on 12/16/14.
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETIdentity.h"

#import "SettingsViewController.h"

@interface SecurityCodeViewController : UIViewController{
    ETIdentity *getIdentity;
    NSString *OTP;
    
}
@property (nonatomic, strong, readwrite) ETIdentity *getIdentity;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) NSTimer *timeout;
@property (nonatomic, weak) NSTimer *idleTimer;
@end
