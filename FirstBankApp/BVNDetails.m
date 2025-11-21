#import "BVNDetails.h"
#import <EntrustIGMobile/ETIdentityProvider.h>
#import "EstablishPINViewController.h"
#import "SDKUtils.h"

#import "FirstBankApp-Swift.h"   // SmileIDBridge

@interface BVNDetails ()

// Instance variables turned into properties
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *regPhoneNumber;
@property (nonatomic, strong) NSString *regAccount;
@property (nonatomic, strong) NSString *otpReference;

@property (nonatomic, strong) NSURLConnection *conn1;
@property (nonatomic, strong) NSURLConnection *conn2;

@property (nonatomic, strong) NSMutableURLRequest *requested;
@property (nonatomic, strong) NSMutableURLRequest *requestOTP;

@property (nonatomic, strong) NSMutableData *responseData;

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
    NSLog(@"➡️ continueButton tapped, launching SmileID");

    [SmileIDBridge presentSelfieEnrollmentFrom:self completion:^(NSString *resultJson, NSString *error) {
        if (resultJson) {
            NSData *data = [resultJson dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonError;
            NSDictionary *parsed = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

            if (!jsonError && parsed) {
                NSString *resultCode = parsed[@"resultCode"];
                if ([resultCode isEqualToString:@"1012"]) {
                    NSLog(@"✅ SmileID success, now fetching account/OTP");

                    // Use cifid or userId from SmileID response
                    NSString *smileUserId = parsed[@"cifid"] ?: self.userid;
                    [self startAccountAndOTPFlowWithUserId:smileUserId];
                } else {
                    [self showAlert:@"Verification Failed"
                             message:[NSString stringWithFormat:@"SmileID returned code: %@", resultCode]];
                }
            }
        } else {
            [self showAlert:@"Error" message:error ?: @"User cancelled"];
        }
    }];
}

#pragma mark - Backend Flow
- (void)startAccountAndOTPFlowWithUserId:(NSString *)userId {
    self.userid = userId;
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
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    self.requestOTP = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:
        @"https://firsttokenprod.firstbanknigeria.com/FirstTokenmiddleware/sendOTP.php"]];
    [self.requestOTP setHTTPMethod:@"POST"];
    [self.requestOTP setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]]
        forHTTPHeaderField:@"Content-Length"];
    [self.requestOTP setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [self.requestOTP setHTTPBody:postData];
    
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
    NSString *responseText = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    if (connection == self.conn1) {
        NSDictionary *jsonAccount = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:nil];
        if ([jsonAccount[@"Message"] isEqualToString:@"Success"]) {
            self.regAccount = jsonAccount[@"AccountNumbers"][0];
            self.regPhoneNumber = jsonAccount[@"phonelist"][0];
            [self sendOTPForAccount:self.regAccount];
        } else {
            [self showAlert:@"Error" message:@"Account fetch failed"];
        }
    }
    else if (connection == self.conn2) {
        NSDictionary *jsonOTP = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:nil];
        if ([jsonOTP[@"ResponseCode"] isEqualToString:@"000"]) {
            self.otpReference = jsonOTP[@"OTPReferenceNumber"];
            [self performSegueWithIdentifier:@"panTootp" sender:self];
        } else {
            [self showAlert:@"Error" message:@"Failed to send OTP"];
        }
    }
}

#pragma mark - Helpers
- (void)showAlert:(NSString*)title message:(NSString*)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"panTootp"]) {
        EstablishPINViewController *vcSett = [segue destinationViewController];
        vcSett.otpReference = self.otpReference;
        vcSett.userID = self.userid;
        vcSett.accountNumber = self.regAccount;
        vcSett.phoneNumber = self.regPhoneNumber;
    }
}

@end

