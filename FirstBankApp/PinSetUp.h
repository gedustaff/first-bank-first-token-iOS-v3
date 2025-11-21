//
//  PinSetUp.h
//  FirstBankApp
//
//  Created by cbc gedu on 28/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PinSetUp : UIViewController
@property (nonatomic, assign) NSInteger pinLength; // 4 or 6
@property (nonatomic, copy) void (^onPinComplete)(NSString *pin);

@end

NS_ASSUME_NONNULL_END
