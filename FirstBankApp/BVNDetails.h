//
//  BVNDetails.h
//  FirstBankApp
//
//  Created by cbc gedu on 25/07/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

//#import <UIKit/UIKit.h>
//#import "FirstBankApp-Bridging-Header.h"
//
//NS_ASSUME_NONNULL_BEGIN
//
//@interface BiometricKYCViewController : UIViewController <SmartSelfieResultDelegate>
//
//@interface BVNDetails : UIViewController
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//@property (weak, nonatomic) IBOutlet UIButton *continueButton;
//
//// Property to receive data from the previous view controller
//@property (nonatomic, strong) NSMutableDictionary *passedData;
//@property(nonatomic, strong) NSMutableDictionary *fullPassedData;
//
//@end
//
//NS_ASSUME_NONNULL_END



#import <UIKit/UIKit.h>
#import "FirstBankApp-Bridging-Header.h" // Replace with your project's bridging header name

@interface BVNDetails : UIViewController <SmartSelfieResultDelegate> // Add the delegate protocol
@property (nonatomic, strong) NSDictionary *passedData;
@property (nonatomic, strong) NSDictionary *fullPassedData;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
