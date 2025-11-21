//
//  ErrorPopupViewController.h
//  FirstBankApp
//
//  Created by cbc gedu on 08/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PopupType) {
    PopupTypeSuccess,
    PopupTypeError,
    PopupTypeWarning
};

@interface StatusPopupViewController : UIViewController

@property (nonatomic, assign) PopupType popupType;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *messageText;

@end

NS_ASSUME_NONNULL_END
