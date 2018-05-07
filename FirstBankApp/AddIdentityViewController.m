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
@property (weak, nonatomic) IBOutlet UILabel *one;
@property (weak, nonatomic) IBOutlet UILabel *two;
@property (weak, nonatomic) IBOutlet UILabel *three;
@property (weak, nonatomic) IBOutlet UILabel *four;

@end


@implementation AddIdentityViewController
@synthesize identity;
- (IBAction)sendIntro:(id)sender {
    
    [self performSegueWithIdentifier:@"introToCard" sender:self];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *border = [UIView new];
    border.backgroundColor = [AddIdentityViewController colorFromHexString:@"#eaab00"];
    [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border.frame = CGRectMake(0, _one.frame.size.height - 1.0f, _one.frame.size.width, 1.0f);
    [_one addSubview:border];
    
    UIView *border1 = [UIView new];
    border1.backgroundColor = [AddIdentityViewController colorFromHexString:@"#eaab00"];
    [border1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border1.frame = CGRectMake(0, _two.frame.size.height - 1.0f, _two.frame.size.width, 1.0f);
    [_two addSubview:border1];
    
    UIView *border2 = [UIView new];
    border2.backgroundColor = [AddIdentityViewController colorFromHexString:@"#eaab00"];
    [border2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border2.frame = CGRectMake(0, _three.frame.size.height - 1.0f, _three.frame.size.width, 1.0f);
    [_three addSubview:border2];
    
    UIView *border3 = [UIView new];
    border3.backgroundColor = [AddIdentityViewController colorFromHexString:@"#eaab00"];
    [border3 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border3.frame = CGRectMake(0, _four.frame.size.height - 1.0f, _four.frame.size.width, 1.0f);
    [_four addSubview:border3];
    
    
    
    
    if (![ETSoftTokenSDK isDeviceSecure]) {
        // Display a waring or error message to user.
        // Possibly quit the application.
        
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Application Login Error"
                                     message:@"Your device is rooted \nIt is recommended that you do not continue \n Do you?"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                    actionWithTitle:@"No"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        exit(1);
                                    }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        [self presentViewController:alert animated:YES completion:nil];
        
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
