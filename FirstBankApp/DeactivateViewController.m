//
//  DeactivateViewController.m
//  FirstBankApp
//
//  Created by Dapsonco on 30/04/2018.
//  Copyright © 2018 Gedu Technologies. All rights reserved.
//

#import "DeactivateViewController.h"

NSURLConnection *connValidateOTP, *connDeactivate;
NSMutableURLRequest *requestVerify, *requestDeactivate;
NSString *otp, *reference, *serialNum, *user;
UIAlertController *alertController;

@interface DeactivateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *deactivateOTP;

@end

@implementation DeactivateViewController
@synthesize ref, responseDataDC, userID, serial, responseCode;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    user = userID;
    ETIdentity *et = [SDKUtils loadIdentity];
    serialNum = et.serialNumber;
    
    self.deactivateOTP.delegate = self;
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
    NSLog(@"recieved data @push %@", data);
    
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"error message: %@", error);
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
    
    NSLog(@"Finished Loading");

    if (connection ==connValidateOTP){
        NSString *responseText = [[NSString alloc] initWithData:responseDataDC encoding:NSUTF8StringEncoding];
        NSLog(@"Received Response Conn, %@", responseText);
        //Parse Response
        NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json objectForKey:@"OTPReferenceNumber"]){
            responseCode = [json valueForKey:@"ResponseCode"];
            NSLog(@"Received Code, %@", responseCode);
            //if ([responseCode isEqualToString:@"000"]){
            if ([responseCode isEqualToString:@"111"]){
                
                alertController.message = @"Deactivating Token...";
                [DeactivateViewController deactivate];
                connDeactivate = [[NSURLConnection alloc] initWithRequest:requestDeactivate delegate:self];
                if(connDeactivate) {
                    NSLog(@"Connection Successful");
                } else {
                    NSLog(@"Connection could not be made");
                }
                
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
    NSLog(@"Received Response Conn1, %@", responseText);
    //Parse Response
    NSData *dataAccount = [responseText dataUsingEncoding:NSUTF8StringEncoding];
    id jsonAccount = [NSJSONSerialization JSONObjectWithData:dataAccount options:0 error:nil];
        
        if ([jsonAccount objectForKey:@"Status"]){
            BOOL statusRetrieved = [[jsonAccount valueForKey:@"Status"] boolValue];
            NSLog(@"Received Code, %@", responseCode);
            //if ([responseCode isEqualToString:@"000"]){
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
    
    otp = self.deactivateOTP.text;
    [self.deactivateOTP resignFirstResponder];
    if(otp.length==6){
        alertController = [UIAlertController
                           alertControllerWithTitle:@"Deactivating App"
                           message:@"Validating OTP..."
                           preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        [DeactivateViewController validateOTP];
        connValidateOTP = [[NSURLConnection alloc] initWithRequest:requestVerify delegate:self];
        
        if(connValidateOTP) {
            NSLog(@"Connection Successful");
        } else {
            NSLog(@"Connection could not be made");
        }
        
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
    
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&one=%@&ref=%@",@"2",@"f8d66c19-ed29-403e-9cf1-387f6c15b223", otp,reference ];
    NSLog(@"Post Request, %@", post);
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"Final Posted Data , %@", posted);
    NSLog(@"Final Post Data , %@", postData);
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //Create URL Request
    requestVerify = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    //[request setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/checkUser.php"]];
    [requestVerify setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/validateOTP.php"]];
    
    //set HTTP Method
    [requestVerify setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestVerify setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestVerify setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestVerify setHTTPBody:postData];
    
    NSLog(@"Final Request Structure, %@", requestVerify);
    //NSString *postedRequest = [[NSString alloc] initWithData:request encoding:NSUTF8StringEncoding];
    
    NSLog(@"Posted Request, %@", requestVerify.HTTPBody);
    
}

+ (void) deactivate {
    
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@&ser=%@",@"7",@"f8d66c19-ed29-403e-9cf1-387f6c15b223", @"FirstToken",user,serialNum];
    NSLog(@"Post Request, %@", post);
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"Final Posted Data , %@", posted);
    NSLog(@"Final Post Data , %@", postData);
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //Create URL Request
    requestDeactivate = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    //[request setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/checkUser.php"]];
    [requestDeactivate setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/validateOTP.php"]];
    
    //set HTTP Method
    [requestDeactivate setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestDeactivate setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestDeactivate setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestDeactivate setHTTPBody:postData];
    
    NSLog(@"Final Request Structure, %@", requestDeactivate);
    //NSString *postedRequest = [[NSString alloc] initWithData:request encoding:NSUTF8StringEncoding];
    
    NSLog(@"Posted Request, %@", requestDeactivate.HTTPBody);
    
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
