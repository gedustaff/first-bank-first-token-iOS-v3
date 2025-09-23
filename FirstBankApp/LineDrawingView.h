//
//  LineDrawingView.h
//  FirstBankApp
//
//  Created by cbc gedu on 22/07/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LineDrawingView : UIView

// You can add properties to customize the line if needed
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;


@end

NS_ASSUME_NONNULL_END
