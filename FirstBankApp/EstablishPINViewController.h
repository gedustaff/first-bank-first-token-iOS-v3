//
//  EstablishPINViewController.h
//  FirstBankApp
//
//  Created by Gedu Technologies on 12/16/14.
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETIdentity.h"

@interface EstablishPINViewController : UIViewController<UITextFieldDelegate>{
    NSString *pinValue;
    ETIdentity *idPIN;
    
    
}

@property (nonatomic, strong, readwrite) NSString *pinValue;
@property (nonatomic, strong, readwrite) ETIdentity *idPIN;

@end
