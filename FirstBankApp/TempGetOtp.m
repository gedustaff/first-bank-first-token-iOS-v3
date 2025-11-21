//
//  TempGetOtp.m
//  FirstBankApp
//
//  Created by cbc gedu on 29/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "TempGetOtp.h"

@interface TempGetOtp ()

@end

@implementation TempGetOtp

- (NSString *)getOTP:(NSDate *)date {
    // Temporary mock OTP generator for testing
    int otp = arc4random_uniform(900000) + 100000;
    return [NSString stringWithFormat:@"%06d", otp];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
