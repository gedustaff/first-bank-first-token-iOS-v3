//
//  RegistrationCodeViewController.h
//  FirstBankApp
//
//  Created by Gedu Technologies on 12/16/14.
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETIdentity.h"

@interface RegistrationCodeViewController : UIViewController <UIAlertViewDelegate>{
    ETIdentity *strIdentity;
    NSString *strPIN;
    
}
@property (nonatomic, strong, readwrite) ETIdentity *strIdentity;
@property (nonatomic, strong, readwrite) NSString *strPIN;
@end
