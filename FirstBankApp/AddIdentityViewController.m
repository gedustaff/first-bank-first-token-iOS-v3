//
//  AddIdentityViewController.m
//  FirstBankApp
//
//  Created by Gedu Technologies on 12/16/14.
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import "AddIdentityViewController.h"

NSString *serialNumber;
NSString *activationCode;

#define MAXLENGTH1 10
#define MAXLENGTH2 16

@interface AddIdentityViewController ()
@property (nonatomic, assign) BOOL checkSerial;

@end


@implementation AddIdentityViewController
@synthesize identity;
- (IBAction)sendIntro:(id)sender {
    
    [self performSegueWithIdentifier:@"introToCard" sender:self];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![ETSoftTokenSDK isDeviceSecure]) {
        // Display a waring or error message to user.
        // Possibly quit the application.
        
        UIAlertView *pinAlert = [[UIAlertView alloc] initWithTitle:@"Application Login Error " message:@"Your device is rooted \nIt is recommended that you do not continue \n Do you?" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [pinAlert show];
        
        
    }
    
    // Do any additional setup after loading the view.
    UIColor *mycolor = [AddIdentityViewController colorFromHexString:@"#01214C"];
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:15.0], NSFontAttributeName, mycolor, NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = size;
    
    //Custom Keyboard
    
    //[super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}





- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}









+ (BOOL) checkSerialNumber{
    
    
    BOOL checkSerialNum = NO;
    
    
    @try {
        
        [ETIdentityProvider
         validateSerialNumber:serialNumber];
        checkSerialNum = YES;
    }
    @catch (NSException * e) {
        checkSerialNum = NO;
        UIAlertView *serialAlert = [[UIAlertView alloc] initWithTitle:@"Application Activation Error " message:@"The serial number was entered incorrectly. Check the number and try again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [serialAlert show];
    }
    
    return checkSerialNum;
}


+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (BOOL) checkActivationNumber{
    
    BOOL checkAccNum = NO;
    
    
    @try {
        
        [ETIdentityProvider
         validateActivationCode:activationCode];
        checkAccNum = YES;
    }
    @catch (NSException * e) {
        checkAccNum = NO;
        UIAlertView *activationAlert = [[UIAlertView alloc] initWithTitle:@"Application Activation Error " message:@"The activation number was entered incorrectly. Check the number and try again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [activationAlert show];
    }
    
    return checkAccNum;
}






#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
  
}


@end
