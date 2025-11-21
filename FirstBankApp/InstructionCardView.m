//
//  InstructionCardView.m
//  FirstBankApp
//
//  Created by cbc gedu on 08/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "InstructionCardView.h"

@interface InstructionCardView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation InstructionCardView

- (instancetype)initWithTitle:(NSString *)title
                        items:(NSArray<NSString *> *)items
                        style:(InstructionListStyle)style {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
        self.layer.cornerRadius = 10.0;
        self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 4;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        
        // Title
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.text = title;
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
        
        // Content
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = [self formattedListFromItems:items style:style];
        [self addSubview:_contentLabel];
        
        [self setupConstraints];
    }
    return self;
}

- (NSString *)formattedListFromItems:(NSArray<NSString *> *)items
                               style:(InstructionListStyle)style {
    NSMutableString *formattedText = [NSMutableString string];
    
    for (NSInteger i = 0; i < items.count; i++) {
        NSString *item = items[i];
        switch (style) {
            case InstructionListStyleOrdered:
                [formattedText appendFormat:@"%ld. %@\n", (long)(i + 1), item];
                break;
            case InstructionListStyleBulleted:
                [formattedText appendFormat:@"• %@\n", item];
                break;
            case InstructionListStyleNone:
                [formattedText appendFormat:@"%@\n", item];
                break;
        }
    }
    
    return [formattedText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:16],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16],
        
        [self.contentLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:8],
        [self.contentLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
        [self.contentLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16],
        [self.contentLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-16]
    ]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
