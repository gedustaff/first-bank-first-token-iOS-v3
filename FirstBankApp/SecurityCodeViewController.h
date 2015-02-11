//
//  SecurityCodeViewController.h
//  FirstBankApp
//
//  Created by Gedu Technologies on 12/16/14.
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETIdentity.h"
#import "CircularProgressView.h"

@interface SecurityCodeViewController : UIViewController{
    ETIdentity *getIdentity;
    NSTimer *timer, *idleTimer;
    NSString *OTP;
    CircularProgressView *cpw;
}
@property (nonatomic, strong, readwrite) ETIdentity *getIdentity;
@end
