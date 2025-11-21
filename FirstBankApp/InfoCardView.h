//
//  InfoCardView.h
//  FirstBankApp
//
//  Created by cbc gedu on 08/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfoCardView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *iconView;
- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title subtitle:(NSString *)subtitle;

@end

NS_ASSUME_NONNULL_END
