//
//  InstructionCardView.h
//  FirstBankApp
//
//  Created by cbc gedu on 08/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, InstructionListStyle) {
    InstructionListStyleNone,
    InstructionListStyleOrdered,
    InstructionListStyleBulleted
};

@interface InstructionCardView : UIView
- (instancetype)initWithTitle:(NSString *)title
                        items:(NSArray<NSString *> *)items
                        style:(InstructionListStyle)style;
@end

NS_ASSUME_NONNULL_END
