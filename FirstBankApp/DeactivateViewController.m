//
//  DeactivateViewController.m
//  FirstBankApp
//
//  Copyright © 2018 Gedu Technologies. All rights reserved.
//

#import "DeactivateViewController.h"

NSURLConnection *connDeactivateValidateOTP, *connDeactivate;
NSMutableURLRequest *requestDeactivateVerify, *requestDeactivate;
NSString *deactivateUserOtp, *reference, *serialNum, *user;
UIAlertController *alertController;

@interface DeactivateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *deactivateOTP;

@end

@implementation DeactivateViewController
@synthesize ref, responseDataDC, userID, serial, responseCode;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    responseDataDC = [NSMutableData new];
    reference = ref;
    user = userID;
    ETIdentity *et = [SDKUtils loadIdentity];
    serialNum = et.serialNumber;
    
    UIColor *color = [UIColor whiteColor];
    _deactivateOTP.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Enter OTP"
     attributes:@{NSForegroundColorAttributeName:color}];
    
    _deactivateOTP.layer.masksToBounds=YES;
    _deactivateOTP.layer.borderColor = [[DeactivateViewController colorFromHexString:@"#eaab00"] CGColor];
    _deactivateOTP.layer.borderWidth= 2.0f;
    
    self.deactivateOTP.delegate = self;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseDataDC setLength:0];
}


// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
    
    [responseDataDC appendData: data];
    
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    alertController.title = @"Activation Error";
    alertController.message = @"Please check your internet connection and try again";
    
    UIAlertAction* yesIncorrectButton = [UIAlertAction
                                         actionWithTitle:@"Close"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             //Handle your yes please button action here
                                         }];
    [alertController addAction:yesIncorrectButton];
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{

    if (connection ==connDeactivateValidateOTP){
        NSString *responseText = [[NSString alloc] initWithData:responseDataDC encoding:NSUTF8StringEncoding];
        //Parse Response
        NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json objectForKey:@"OTPReferenceNumber"]){
            responseCode = [json valueForKey:@"ResponseCode"];
            if ([responseCode isEqualToString:@"000"]){
                
                alertController.message = @"Deactivating Token...";
                [DeactivateViewController deactivate];
                connDeactivate = [[NSURLConnection alloc] initWithRequest:requestDeactivate delegate:self];
              
            }else{
                
                alertController.title = @"Error validating OTP";
                alertController.message = @"Please try again";
                
                UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                     actionWithTitle:@"Okay"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                     }];
                [alertController addAction:yesIncorrectButton];
                
            }
        }else{
            alertController.title = @"Error Activating App";
            alertController.message = @"Please contact the bank";
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Okay"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                 }];
            [alertController addAction:yesIncorrectButton];
        }
        
    }else if(connection == connDeactivate){
        
    NSString *responseText = [[NSString alloc] initWithData:responseDataDC encoding:NSUTF8StringEncoding];
    //Parse Response
    NSData *dataAccount = [responseText dataUsingEncoding:NSUTF8StringEncoding];
    id jsonAccount = [NSJSONSerialization JSONObjectWithData:dataAccount options:0 error:nil];
        
        if ([jsonAccount objectForKey:@"Status"]){
            BOOL statusRetrieved = [[jsonAccount valueForKey:@"Status"] boolValue];
            if (statusRetrieved){
                [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
                
                alertController.title = @"FirstToken Alert";
                alertController.message = @"Token Successfully Deactivated";
                
                UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                     actionWithTitle:@"Close app"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                         exit(1);
                                                     }];
                [alertController addAction:yesIncorrectButton];
                
            }else{
                
                alertController.title = @"Error Deactivating Token";
                alertController.message = @"Please try again";
                
                UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                     actionWithTitle:@"Okay"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                     }];
                [alertController addAction:yesIncorrectButton];
                
            }
        }else{
            alertController.title = @"Error Activating App";
            alertController.message = @"Please contact the bank";
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Okay"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                 }];
            [alertController addAction:yesIncorrectButton];
        }
    
    
    
    }
}

- (IBAction)submitDeac:(id)sender {
    
    deactivateUserOtp = self.deactivateOTP.text;
    [self.deactivateOTP resignFirstResponder];
    if(deactivateUserOtp.length==6){
        alertController = [UIAlertController
                           alertControllerWithTitle:@"Deactivating App"
                           message:@"Validating OTP..."
                           preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        [DeactivateViewController validateOTP];
        connDeactivateValidateOTP = [[NSURLConnection alloc] initWithRequest:requestDeactivateVerify delegate:self];
        
    }
    
    
    
    
}
- (IBAction)cancelDeac:(id)sender {
    
    CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 2.0f ;
    anim.duration = 0.07f ;
    
    
    
    [self performSegueWithIdentifier:@"finalCancelDeac" sender:self];
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
   
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= 6 || returnKey;
    
}

+ (void) validateOTP {
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&one=%@&ref=%@",@"2",@"f8d66c19-ed29-403e-9cf1-387f6c15b223", deactivateUserOtp,reference ];
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    
    //Create URL Request
    requestDeactivateVerify = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    [requestDeactivateVerify setURL:[NSURL URLWithString:@"https://firsttokenprod.firstbanknigeria.com/FirstTokenmiddleware/validateOTP.php"]];
    
    //set HTTP Method
    [requestDeactivateVerify setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestDeactivateVerify setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestDeactivateVerify setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestDeactivateVerify setHTTPBody:postData];
    
}

+ (void) deactivate {
    
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@&ser=%@",@"7",@"f8d66c19-ed29-403e-9cf1-387f6c15b223", @"FirstToken",user,serialNum];
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    
    //Create URL Request
    requestDeactivate = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    [requestDeactivate setURL:[NSURL URLWithString:@"https://firsttokenprod.firstbanknigeria.com/FirstTokenmiddleware/deleteToken.php"]];
    
    //set HTTP Method
    [requestDeactivate setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestDeactivate setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestDeactivate setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestDeactivate setHTTPBody:postData];
    
    
}

@end
