//
//  SettingsViewController.h
//  FirstBankApp
//
//  Created by Gedu Technologies on 4/13/15.
//  Copyright (c) 2015 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETIdentity.h"

@interface SettingsViewController : UIViewController{
ETIdentity *setIdentity;


}
@property (nonatomic, strong, readwrite) ETIdentity *setIdentity;

@end
