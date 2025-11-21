//
//  InfoCardView.m
//  FirstBankApp
//
//  Created by cbc gedu on 08/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "InfoCardView.h"

@implementation InfoCardView
- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title subtitle:(NSString *)subtitle {
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.layer.cornerRadius = 12;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        self.backgroundColor = [UIColor whiteColor];

        _iconView = [[UIImageView alloc] initWithImage:icon];
        _iconView.translatesAutoresizingMaskIntoConstraints = NO;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.text = title;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:14];
        _subtitleLabel.textColor = [UIColor darkGrayColor];
        _subtitleLabel.text = subtitle;
        _subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:_iconView];
        [self addSubview:_titleLabel];
        [self addSubview:_subtitleLabel];
        
        [NSLayoutConstraint activateConstraints:@[
            [_iconView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:12],
            [_iconView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [_iconView.widthAnchor constraintEqualToConstant:20],
            [_iconView.heightAnchor constraintEqualToConstant:20],
            
            [_titleLabel.leadingAnchor constraintEqualToAnchor:_iconView.trailingAnchor constant:10],
            [_titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:8],
            
            [_subtitleLabel.leadingAnchor constraintEqualToAnchor:_titleLabel.leadingAnchor],
            [_subtitleLabel.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor constant:2],
            [_subtitleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-12],
            [_subtitleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8]
        ]];
    }
    return self;
}
@end
