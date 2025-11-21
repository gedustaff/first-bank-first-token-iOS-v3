//
//  EnrollmentInfoView.h
//  FirstBankApp
//
//  Created by cbc gedu on 08/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnrollmentInfoView : UIView
@property (nonatomic, strong)UIImage *iconImage;
@property (nonatomic, copy)NSString *titleText;
@property (nonatomic, copy)NSString *subtitleText;

// Convenience initializer
- (instancetype)initWithIcon:(UIImage *)icon
                       title:(NSString *)title
                    subtitle:(NSString *)subtitle;

@end

NS_ASSUME_NONNULL_END
