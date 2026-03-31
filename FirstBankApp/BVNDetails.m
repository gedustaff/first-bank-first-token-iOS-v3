#import "BVNDetails.h"
#import <EntrustIGMobile/ETIdentityProvider.h>
#import "EstablishPINViewController.h"
#import "SDKUtils.h"

#import "FirstBankApp-Swift.h"   // SmileIDBridge

@interface BVNDetails ()

// Instance variables turned into properties
@property (nonatomic, strong) NSString *regPhoneNumber;
@property (nonatomic, strong) NSString *regAccount;
@property (nonatomic, strong) NSString *otpReference;

@property (nonatomic, strong) NSURLConnection *conn1;
@property (nonatomic, strong) NSURLConnection *conn2;

@property (nonatomic, strong) NSMutableURLRequest *requested;
@property (nonatomic, strong) NSMutableURLRequest *requestOTP;

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSString *phoneNumber;

@end

@implementation BVNDetails

@synthesize passedData;
@synthesize fullPassedData;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.continueButton.layer.cornerRadius = 8.0;
    self.continueButton.layer.borderWidth = 2.0;
    self.continueButton.layer.borderColor = [UIColor lightGrayColor].CGColor;

    NSLog(@"BVNDetailsVC received passedData: %@", self.passedData);
    NSLog(@"BVNDetailsVC received fullPassedData: %@", self.fullPassedData);

    if (self.passedData) {
        NSString *firstName = self.passedData[@"firstName"] ?: @"";
        NSString *middleName = self.passedData[@"middleName"] ?: @"";
        NSString *lastName  = self.passedData[@"lastName"] ?: @"";
        self.userid      = self.passedData[@"cifid"] ?: @"";
        self.regAccount  = self.passedData[@"accountNumber"] ?: @"";
        NSString *jobId = [NSString stringWithFormat:@"job-id-%@", [[NSUUID UUID] UUIDString]];
        self.jobid=jobId;

        NSMutableString *fullName = [NSMutableString string];
        if (firstName.length > 0) [fullName appendString:firstName];
        if (middleName.length > 0 && ![middleName isEqual:[NSNull null]]) {
            if (fullName.length > 0) [fullName appendString:@" "];
            [fullName appendString:middleName];
        }
        if (lastName.length > 0) {
            if (fullName.length > 0) [fullName appendString:@" "];
            [fullName appendString:lastName];
        }

        self.titleLabel.text = fullName.length > 0 ? fullName : @"User Details";
    } else {
        NSLog(@"Error: passedData is nil in BVNDetailsVC.");
        self.titleLabel.text = @"Error Loading Data";
    }
}

#pragma mark - IBActions
- (IBAction)continueButton:(UIButton *)sender {
    NSLog(@"continueButton tapped, launching SmileID");
    if (!sender.enabled) return; // extra safety

     [self setLoadingState:YES];   // Disable immediately

    [self launchSmileIDWithAllowReEnroll:NO];
}

- (void)launchSmileIDWithAllowReEnroll:(BOOL)allowReEnroll {
    NSLog(@"Launching SmileID | allowReEnroll = %@", allowReEnroll ? @"YES" : @"NO");
    
    [SmileIDBridge presentSelfieEnrollmentFrom:self
                                         jobId:self.jobid
                                        userId:self.userid
                                 allowReEnroll:allowReEnroll
                                    completion:^(NSString *resultJson, NSString *error) {
        
        // Check if we received an error
        if (error || !resultJson.length) {
            // Log the error for debugging
            NSLog(@"Received error: %@", error);
            
            // Check for specific error indicating user already enrolled
//            if ([error containsString:@"2209"] || [error containsString:@"already enrolled"]) {
//                NSLog(@"Detected 2209 or already enrolled error - proceeding to re-enrollment flow");
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // Proceed directly to the re-enrollment flow
//                    [self launchSmileIDWithAllowReEnroll:YES];
////                    [self startAccountAndOTPFlowWithUserId:self.userid];
//                });
//                return; // Prevent showing an alert
//           // Exit here to prevent showing an alert
//            }
            
            // For other errors, show the alert
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Actual system error occurred: %@", error);
                [self showAlert:@"Error" message:error ?: @"Empty SmileID response"];
            });
            return;
        }

        // Parse the resultJson
        NSError *jsonError = nil;
        NSDictionary *parsed = [NSJSONSerialization JSONObjectWithData:[resultJson dataUsingEncoding:NSUTF8StringEncoding]
                                                           options:0
                                                             error:&jsonError];
        
        if (jsonError || !parsed) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Invalid response format: %@", jsonError.localizedDescription);
                [self showAlert:@"Error" message:@"Invalid response format"];
            });
            return;
        }

        NSDictionary *apiResponse = parsed[@"apiResponse"];
        NSString *resultCode = [NSString stringWithFormat:@"%@", apiResponse[@"code"]]; // Ensure string
        NSString *resultStatus = apiResponse[@"status"];

        // CASE 1: SUCCESS (Approved)
        if ([resultCode isEqualToString:@"0840"] || [resultStatus caseInsensitiveCompare:@"approved"] == NSOrderedSame) {
            NSLog(@"SmileID Approved → proceeding");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self startAccountAndOTPFlowWithUserId:self.userid];
            });
            return;
        }

        // Log the result code for further debugging
        NSLog(@"Result code received: %@", resultCode);

        // CASE 2: USER ALREADY EXISTS (2209 or 2215) → PROCEED TO NEXT CALL
        if ([resultCode isEqualToString:@"2209"] || [resultCode isEqualToString:@"2215"]) {
            NSLog(@"User already enrolled (Code %@) → proceeding to next step", resultCode);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self launchSmileIDWithAllowReEnroll:YES];
            });
            return;
        }

        // CASE 3: ACTUAL FAILURE (Other API codes)
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Verification Failed: %@", apiResponse[@"message"]);
            [self showAlert:@"Verification Failed"
                     message:[NSString stringWithFormat:@"Message: %@", apiResponse[@"message"]]];
        });
    }];
}

#pragma mark - Backend Flow
- (void)startAccountAndOTPFlowWithUserId:(NSString *)userId {
    self.userid = userId;
    NSLog(@"account userid %@", self.userid);
    self.phoneNumber = self.regPhoneNumber;
    NSLog(@"registered phonenu", self.phoneNumber);
    NSString *post = [NSString stringWithFormat:
                      @"&id=4&key=%@&app=FirstToken&fid=%@",
                      @"f8d66c19-ed29-403e-9cf1-387f6c15b223",
                      self.userid];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    self.requested = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:
        @"https://firsttokenprod.firstbanknigeria.com/firsttokenmiddleware/getAccount.php"]];
    [self.requested setHTTPMethod:@"POST"];
    [self.requested setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]]
     forHTTPHeaderField:@"Content-Length"];
    [self.requested setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [self.requested setHTTPBody:postData];
    
    self.conn1 = [[NSURLConnection alloc] initWithRequest:self.requested delegate:self];
}

- (void)sendOTPForAccount:(NSString *)account {
    NSString *post = [NSString stringWithFormat:
                      @"&id=1&key=%@&acc=%@",
                      @"f8d66c19-ed29-403e-9cf1-387f6c15b223",
                      account];
    NSLog(@"Json REsp %@", account);
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    self.requestOTP = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:
        @"https://firsttokenprod.firstbanknigeria.com/FirstTokenmiddleware/sendOTP.php"]];
    [self.requestOTP setHTTPMethod:@"POST"];
    [self.requestOTP setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]]
        forHTTPHeaderField:@"Content-Length"];
    [self.requestOTP setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [self.requestOTP setHTTPBody:postData];
    NSLog(@"Json requestOTP %@", self.requestOTP);
    
    self.conn2 = [[NSURLConnection alloc] initWithRequest:self.requestOTP delegate:self];
}

#pragma mark - NSURLConnection Delegates
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.responseData = [[NSMutableData alloc] init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    if (connection == self.conn1) {

        NSDictionary *jsonAccount =
        [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:nil];

        NSLog(@"Json Res Account: %@", jsonAccount);

        if ([jsonAccount[@"Message"] isEqualToString:@"Success"]) {

            self.regAccount = jsonAccount[@"AccountNumbers"][0];
            self.regPhoneNumber = jsonAccount[@"phonelist"][0];

            [self sendOTPForAccount:self.regAccount];

        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlert:@"Error" message:jsonAccount[@"Message"]];
            });
        }

    }
    else if (connection == self.conn2) {

        NSDictionary *jsonOTP =
        [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:nil];

        if ([jsonOTP[@"ResponseCode"] isEqualToString:@"000"]) {

            self.otpReference = jsonOTP[@"OTPReferenceNumber"];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self navigateToOTPScreen];
                
            });

        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlert:@"Error" message:@"Failed to send OTP"];
            });
        }
    }
}

#pragma mark - Loading State

- (void)setLoadingState:(BOOL)isLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.continueButton.enabled = !isLoading;
        self.continueButton.alpha = isLoading ? 0.5 : 1.0;
        
        if (isLoading) {
            UIActivityIndicatorView *spinner =
            [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
            spinner.center = self.continueButton.center;
            spinner.tag = 999;
            [spinner startAnimating];
            [self.view addSubview:spinner];
        } else {
            UIView *spinner = [self.view viewWithTag:999];
            [spinner removeFromSuperview];
        }
    });
}




//- (void)navigateToOTPScreen {
//
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//  
//    EstablishPINViewController *vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([EstablishPINViewController class])];
//
////    EstablishPINViewController *vc =
////        [sb instantiateViewControllerWithIdentifier:@"EstablishPINViewController"];
//    
//
//    vc.otpReference = self.otpReference;
//    vc.userID = self.userid;
//    vc.accountNumber = self.regAccount;
//    vc.phoneNumber = self.regPhoneNumber;
//
//    if (self.navigationController) {
//        [self.navigationController pushViewController:vc animated:YES];
//    } else {
//        [self presentViewController:vc animated:YES completion:nil];
//    }
//}


- (void)navigateToOTPScreen {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EstablishPINViewController *vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([EstablishPINViewController class])];
    NSLog(@"check cifid %@", self.userid);
    // Set properties before the view loads
    vc.otpReference = self.otpReference;
    vc.userID = self.userid;
    vc.accountNumber = self.regAccount;
    vc.phoneNumber = self.regPhoneNumber; // Make sure you have this property

    // Force the view to load so viewDidLoad sets the static variables
    [vc loadViewIfNeeded];

    if (self.navigationController) {
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self presentViewController:vc animated:YES completion:nil];
    }
}



#pragma mark - Helpers
- (void)showAlert:(NSString*)title message:(NSString*)msg {
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
//                                                                   message:msg
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
//    [self presentViewController:alert animated:YES completion:nil];
    
    [self setLoadingState:NO];   //Re-enable on failure
      
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                     message:msg
                                                              preferredStyle:UIAlertControllerStyleAlert];
      [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                style:UIAlertActionStyleDefault
                                              handler:nil]];
      [self presentViewController:alert animated:YES completion:nil];
}



@end

