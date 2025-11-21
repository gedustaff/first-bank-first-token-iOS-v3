//
//  EnrollmentInfoView.m
//  FirstBankApp
//
//  Created by cbc gedu on 08/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "EnrollmentInfoView.h"

@interface EnrollmentInfoView ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@end

@implementation EnrollmentInfoView


- (instancetype)initWithIcon:(UIImage *)icon
                       title:(NSString *)title
                    subtitle:(NSString *)subtitle {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.iconImage = icon;
        self.titleText = title;
        self.subtitleText = subtitle;
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}


- (void)setupView {
    self.translatesAutoresizingMaskIntoConstraints = NO;

    // Icon
    self.iconView = [[UIImageView alloc] initWithImage:self.iconImage];
    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconView];

    // Title
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textColor = UIColor.blackColor;
    self.titleLabel.text = self.titleText ?: @"";
    [self addSubview:self.titleLabel];

    // Subtitle
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.subtitleLabel.font = [UIFont systemFontOfSize:14];
    self.subtitleLabel.textColor = [UIColor darkGrayColor];
    self.subtitleLabel.numberOfLines = 0;
    self.subtitleLabel.text = self.subtitleText ?: @"";
    [self addSubview:self.subtitleLabel];

    // Constraints
    [NSLayoutConstraint activateConstraints:@[
        [self.iconView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.iconView.topAnchor constraintEqualToAnchor:self.topAnchor constant:4],
        [self.iconView.widthAnchor constraintEqualToConstant:20],
        [self.iconView.heightAnchor constraintEqualToConstant:20],

        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.iconView.trailingAnchor constant:8],
        [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.iconView.centerYAnchor],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],

        [self.subtitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:6],
        [self.subtitleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.subtitleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.subtitleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}



#pragma mark - Property Setters

- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    self.iconView.image = iconImage;
}

- (void)setTitleText:(NSString *)titleText {
    _titleText = [titleText copy];
    self.titleLabel.text = titleText;
}

- (void)setSubtitleText:(NSString *)subtitleText {
    _subtitleText = [subtitleText copy];
    self.subtitleLabel.text = subtitleText;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
