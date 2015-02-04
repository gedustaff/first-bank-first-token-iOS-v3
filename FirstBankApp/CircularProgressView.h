//
//  CircularProgressView.h
//  FirstBankApp
//
//  Created by Gedu Technologies on 1/16/15.
//  Copyright (c) 2015 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularProgressView : UIView{
    CGFloat startAngle;
    CGFloat endAngle;
}
@property (nonatomic) double percent;
@end
