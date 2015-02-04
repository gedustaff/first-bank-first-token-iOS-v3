//
//  ResetPINViewController.h
//  FirstBankApp
//
//  Created by Gedu Technologies on 1/15/15.
//  Copyright (c) 2015 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDKUtils.h"
#import "ETIdentity.h"


@interface ResetPINViewController : UIViewController<UITextFieldDelegate>{
    
    ETIdentity *resetID;
    
}

@property (nonatomic, strong, readwrite) ETIdentity *resetID;

@end
