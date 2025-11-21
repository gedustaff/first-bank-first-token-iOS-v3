//
//  CorporateEnrollmentViewController.m
//  FirstBankApp
//
//  Created by cbc gedu on 06/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "CorporateEnrollmentViewController.h"
#import "OTPVerificationVCViewController.h"
#import "EnrollmentInfoView.h"
#import "EntrustUtilityVC.h"
#import "InstructionCardView.h"

@interface CorporateEnrollmentViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel; // The "Corporate Enrollment" title
@property (nonatomic, strong) UITextField *enrollmentIdTextField;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UILabel *instructionsLabel; // The "How to get Enrollment ID" list
@property (nonatomic, strong) EnrollmentInfoView *infoView;
@property (nonatomic, strong) InstructionCardView *instructionView;

@end

@implementation CorporateEnrollmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Corporate Enrollment";

    [self setupNavigationBar];
    [self setupSubviews];
    [self setupConstraints];
  
}


#pragma mark - Navigation Bar Setup
- (void)setupNavigationBar {
    // Left Icon
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
        target:nil action:nil];
    negativeSpacer.width = -16.0;

    UIImage *buildingImage = [UIImage imageNamed:@"Vector"];
    UIBarButtonItem *leftIcon = [[UIBarButtonItem alloc]
        initWithImage:buildingImage
        style:UIBarButtonItemStylePlain
        target:nil
        action:nil];
    leftIcon.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftIcon];

    // Right Icon
    UIImage *chatImage = [UIImage imageNamed:@"Support"];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
        initWithImage:chatImage
        style:UIBarButtonItemStylePlain
        target:nil
        action:nil];
    rightButton.tintColor = [UIColor whiteColor];
    UIBarButtonItem *negativeRightSpacer = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
        target:nil action:nil];
    negativeRightSpacer.width = -10.0;
    self.navigationItem.rightBarButtonItems = @[negativeRightSpacer, rightButton];
}


- (void)setupSubviews {
    // Info Section
    UIImage *mailIcon = [UIImage systemImageNamed:@"envelope.fill"];
    self.infoView = [[EnrollmentInfoView alloc]
        initWithIcon:mailIcon
        title:@"Enter Enrollment ID"
        subtitle:@"Enter the enrollment ID you received in your registered email from FirstOnline or FirstDirect."];
    self.infoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoView.tintColor = [UIColor systemYellowColor];
    [self.view addSubview:self.infoView];
    
    // Enrollment ID Text Field
    self.enrollmentIdTextField = [[UITextField alloc] init];
    self.enrollmentIdTextField.placeholder = @"Enter your enrollment ID";
    self.enrollmentIdTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.enrollmentIdTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.enrollmentIdTextField];

    // Confirm Button
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [self.confirmButton setBackgroundColor:[UIColor colorWithRed:28/255.0 green:52/255.0 blue:82/255.0 alpha:1.0]];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmButton.layer.cornerRadius = 8;
    [self.confirmButton addTarget:self
                           action:@selector(confirmButtonTapped:)
                 forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.confirmButton];
    
    // Instructional Card
       self.instructionView = [[InstructionCardView alloc]
           initWithTitle:@"How to get Enrollment ID:"
           items:@[
               @"Log into FirstOnline or FirstDirect",
               @"Navigate to Token Management",
               @"Request Soft Token Enrollment",
               @"Check your registered email"
           ]
           style:InstructionListStyleOrdered];
       [self.view addSubview:self.instructionView];
    
//    // Instructions Label
//    NSString *instructionsText = @"How to get Enrollment ID:\n1. Log into FirstOnline.\n2. Go to Profile Settings.\n3. Select Enrollment ID.\n4. Check your registered email.";
//    self.instructionsLabel = [[UILabel alloc] init];
//    self.instructionsLabel.text = instructionsText;
//    self.instructionsLabel.numberOfLines = 0;
//    self.instructionsLabel.font = [UIFont systemFontOfSize:14];
//    self.instructionsLabel.textColor = [UIColor darkGrayColor];
//    self.instructionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:self.instructionsLabel];
}


#pragma mark - Layout Constraints
- (void)setupConstraints {
    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;

    [NSLayoutConstraint activateConstraints:@[
        // Info view (top)
        [self.infoView.topAnchor constraintEqualToAnchor:safeArea.topAnchor constant:20],
        [self.infoView.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:20],
        [self.infoView.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor constant:-20],

        // Text Field
        [self.enrollmentIdTextField.topAnchor constraintEqualToAnchor:self.infoView.bottomAnchor constant:25],
        [self.enrollmentIdTextField.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:20],
        [self.enrollmentIdTextField.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor constant:-20],
        [self.enrollmentIdTextField.heightAnchor constraintEqualToConstant:44],

        // Confirm Button
        [self.confirmButton.topAnchor constraintEqualToAnchor:self.enrollmentIdTextField.bottomAnchor constant:30],
        [self.confirmButton.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:20],
        [self.confirmButton.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor constant:-20],
        [self.confirmButton.heightAnchor constraintEqualToConstant:50],

        // Instructions Label
        [self.instructionView.topAnchor constraintEqualToAnchor:self.confirmButton.bottomAnchor constant:30],
        [self.instructionView.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:20],
        [self.instructionView.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor constant:-20]    ]];
}





// CorporateEnrollmentViewController.m

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // The dark blue color from your design
    UIColor *darkBlue = [UIColor colorWithRed:28/255.0 green:52/255.0 blue:82/255.0 alpha:1.0];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        
        // 1. Set the Background Color
        appearance.backgroundColor = darkBlue;
        
        // 2. Set the Title Color
        appearance.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor]
        };
        
        navBar.standardAppearance = appearance;
        navBar.scrollEdgeAppearance = appearance;

    } else {
        // Fallback for older iOS versions
        navBar.barTintColor = darkBlue;
        navBar.tintColor = [UIColor whiteColor];
        navBar.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor]
        };
        navBar.translucent = NO;
    }
}




#pragma mark - Networking
- (void)sendEnrolmentId:(NSString *)enrolmentID {
    UIAlertController *loadingAlert = [UIAlertController alertControllerWithTitle:@"Validating"
                                                                           message:@"Sending otp via email..."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:loadingAlert animated:YES completion:nil];

    NSURL *url = [NSURL URLWithString:@"https://firsttokenapp.firstbanknigeria.com/validate-enrolment-id.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

   
    if (!enrolmentID|| [enrolmentID length] == 0) {
        [loadingAlert dismissViewControllerAnimated:YES completion:^{
            [self showAlert:@"Error" message:@"Enrollment ID is missing."];
        }];
        return;
    }
    NSString *trimmedENROLMENTID= [enrolmentID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSDictionary *body = @{@"enrolmentID":trimmedENROLMENTID};
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&jsonError];

    if (jsonError) {
        [loadingAlert dismissViewControllerAnimated:YES completion:^{
            [self showAlert:@"Error" message:@"Failed to encode request."];
        }];
        return;
    }
    
    NSLog(@"to send %@", body);

    [request setHTTPBody:jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"tijJDpd+yN9rMXTYLFbC8HHQZsIiD7HG6MsZauAHzTEN/EOqoIgPW6t8DbWo1kN2" forHTTPHeaderField:@"AppKey"];
    [request setValue:@"DxvjTUHIaqCcepTj3f9rWMi0x48+//3UC+HwwcwoEcs=" forHTTPHeaderField:@"AppId"];

    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
        dataTaskWithRequest:request
          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
              __strong typeof(weakSelf) strongSelf = weakSelf;
              dispatch_async(dispatch_get_main_queue(), ^{
                  [loadingAlert dismissViewControllerAnimated:YES completion:^{
                      if (error) {
                          [strongSelf showAlert:@"Network Error" message:error.localizedDescription];
                          return;
                      }

                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                      if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
                          [strongSelf showAlert:@"Server Error" message:@"Unexpected server response."];
                          return;
                      }

                      NSError *parseError = nil;
                      NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                      if (parseError) {
                          [strongSelf showAlert:@"Error" message:@"Invalid response format."];
                          return;
                      }

                      NSString *status = json[@"status"];
                      NSDictionary *data = json[@"data"];
                      NSNumber *httpStatus = data[@"httpStatusCode"];
                      NSString *resData= data[@"data"];


                      if ([status isEqualToString:@"success"] && [httpStatus intValue] == 200) {
                          [self validateEnrolmentIDViaEmail:resData];
//                          }
                      } else {
                          NSString *message = json[@"message"] ?: @"An error occurred during submission.";
                          [strongSelf showAlert:@"Error" message:message];
                      }
                  }];
              });
          }];
    [task resume];
}

-(void)validateEnrolmentIDViaEmail:(NSString *) enrolmentId{
    
    UIAlertController *loadingAlert = [UIAlertController alertControllerWithTitle:@"Processing"
                                                                           message:@"Validating Enrolment..."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:loadingAlert animated:YES completion:nil];

    NSURL *url = [NSURL URLWithString:@"https://firsttokenapp.firstbanknigeria.com/generate-and-send-otp-via-email.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

   
    if (!enrolmentId|| [enrolmentId length] == 0) {
        [loadingAlert dismissViewControllerAnimated:YES completion:^{
            [self showAlert:@"Error" message:@"Enrollment ID is missing."];
        }];
        return;
    }
    NSString *trimmedENROLMENTID= [enrolmentId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSDictionary *body = @{@"enrolmentID":trimmedENROLMENTID};
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&jsonError];

    if (jsonError) {
        [loadingAlert dismissViewControllerAnimated:YES completion:^{
            [self showAlert:@"Error" message:@"Failed to encode request."];
        }];
        return;
    }
    
    NSLog(@"to send %@", body);

    [request setHTTPBody:jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"tijJDpd+yN9rMXTYLFbC8HHQZsIiD7HG6MsZauAHzTEN/EOqoIgPW6t8DbWo1kN2" forHTTPHeaderField:@"AppKey"];
    [request setValue:@"DxvjTUHIaqCcepTj3f9rWMi0x48+//3UC+HwwcwoEcs=" forHTTPHeaderField:@"AppId"];

    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
        dataTaskWithRequest:request
          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
              __strong typeof(weakSelf) strongSelf = weakSelf;
              dispatch_async(dispatch_get_main_queue(), ^{
                  [loadingAlert dismissViewControllerAnimated:YES completion:^{
                      if (error) {
                          [strongSelf showAlert:@"Network Error" message:error.localizedDescription];
                          return;
                      }

                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                      if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
                          [strongSelf showAlert:@"Server Error" message:@"Unexpected server response."];
                          return;
                      }

                      NSError *parseError = nil;
                      NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                      if (parseError) {
                          [strongSelf showAlert:@"Error" message:@"Invalid response format."];
                          return;
                      }
                      
//                      NSLog(@"second res %@", json);

                      NSDictionary *outerData = json[@"data"];
                      NSDictionary *innerData = outerData[@"data"];

                      NSString *status = json[@"status"];
                      NSNumber *httpStatus = outerData[@"httpStatusCode"];
                      NSString *message = outerData[@"message"];

                      NSString *email = innerData[@"emailAddress"];
                      NSString *enrollmentID = innerData[@"enrolmentID"];
                      NSString *referenceNumber = [NSString stringWithFormat:@"%@", innerData[@"referenceNumber"]];



                      if ([status.lowercaseString isEqualToString:@"success"] && [httpStatus intValue] == 200) {
                          NSLog(@"Enrollment Verified Successfully");
                          NSLog(@"Email: %@", email);
                          NSLog(@"Enrollment ID: %@", enrollmentID);
                          NSLog(@"Reference: %@", referenceNumber);
                          
                          if (!self.enrollmentData) {
                              self.enrollmentData = [NSMutableDictionary dictionary];
                          }

                          self.enrollmentData[@"email"] = email ?: @"";
                          self.enrollmentData[@"enrolmentID"] = enrollmentID ?: @"";
                          self.enrollmentData[@"referenceNumber"] = referenceNumber ?: @"";
                        
                          
                          // Example: persist in EntrustUtility
                            [[EntrustUtilityVC sharedInstance] saveEnrollmentDataWithEmail:email
                                                                           enrollmentId:enrollmentID
                                                                        referenceNumber:referenceNumber];
                            
                        
                    
                          ////      // Create and navigate to OTP screen
                                OTPVerificationVCViewController *otpVC = [[OTPVerificationVCViewController alloc] init];
                          
                                [self.navigationController pushViewController:otpVC animated:YES];
                       
                          
                   

                      } else {
                          NSString *message = json[@"message"] ?: @"An error occurred during submission.";
                          [strongSelf showAlert:@"Error" message:message];
                      }
                  }];
              });
          }];
    [task resume];
    
}


- (void)showAlert:(NSString*)title message:(NSString*)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark - Confirm Button Action
- (void)confirmButtonTapped:(UIButton *)sender {
    NSString *enrollmentId = self.enrollmentIdTextField.text;
    if (enrollmentId.length == 0) {
        [self showAlert:@"Error" message:@"Please enter your enrollment ID before continuing."];
        return;
    }

//    NSDictionary *enrolment = @{@"enrolmentId": enrollmentId};
    [self sendEnrolmentId:enrollmentId];
}

//- (void)confirmButtonTapped:(UIButton *)sender {
//    NSString *enrollmentId = self.enrollmentIdTextField.text;
//      
//      // Basic validation
//      if (enrollmentId.length == 0) {
//          NSLog(@"Enrollment ID required.");
////          [self showErrorPopupWithMessage:@"Please enter your enrollment ID before continuing."];
//          return;
//      }
//
//      // Simulate a successful enrollment lookup (you’ll replace this with API call)
//      NSLog(@"Enrollment ID entered: %@", enrollmentId);
//    
//    NSDictionary * enrolment= [[NSDictionary alloc]init];
//    enrolment=[@"enrolment": enrollmentId];
//        
//    [self sendEnrolmentId:enrolment];
//
////      // Create and navigate to OTP screen
////      OTPVerificationVCViewController *otpVC = [[OTPVerificationVCViewController alloc] init];
//////
////      [self.navigationController pushViewController:otpVC animated:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
