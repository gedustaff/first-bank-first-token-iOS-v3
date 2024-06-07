//
//  TermsViewController.m
//  FirstBankApp
//
//  Created by Aliyu Olateju on 02/03/2024.
//  Copyright © 2024 Gedu Technologies. All rights reserved.
//

#import "TermsViewController.h"
#import "RegistrationCodeViewController.h"

@interface TermsViewController () <UIAdaptivePresentationControllerDelegate>

@end

@implementation TermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *htmlTerms = @"<strong><span style= 'text-align:center'>DATA PROCESSING CONSENT</span><br/><br/>Data Processing Consent</strong><br/><br/> FirstBank is committed to respecting your privacy and being transparent about the processing of your personal and financial information. In order to provide you with our products and services, including FirstToken, we require your consent to collect, record, use, share and store your personal and financial information. Our use of your information is governed by applicable laws and regulations including the Nigerian Data Protection Act, 2023 (NDPA) (as may be amended, replaced, or re-enacted from time to time), and we, FIRST BANK OF NIGERIA LIMITED is the Data Controller in respect of such information. <br/><br/> FirstBank will process your information including personal data and sensitive personal data on the terms detailed below:<br/><br/><ol type='i'><li> We will use your information to provide our products and services, for assessment and analysis purposes (including credit and behavioral scoring and market/product analysis), to comply with AML/CFT regulations and any other relevant regulatory authority.</li><li> By providing personal and financial information relating to others (e.g., dependents, employees, third parties or joint account holders) for the purpose of using our products and services, you confirm that you have their consent for us to use in accordance with the terms set out herein.</li><li> We may share your information with other companies in the FBN Holdings Plc Group, service providers, debt collection agencies and our approved third-party partners to provide our products and services to you or as required by law and/or regulation. We will only share the minimum amount of information necessary to achieve such purposes.</li><li> We may also collect information about you from 3rd parties as required to provide you with our products and services.</li><li> If we transfer your information to a person, branch or organization located in another country, we will take steps to obtain their agreement to apply the same levels of protection as we are required to apply to your information.</li><li> We will retain information about you after the closure of your account, if the banking business relationship has terminated, if you withdraw your consent, or if your application is declined for as long as permitted for legal, regulatory, fraud prevention and legitimate business purposes.</li><li> You may request for access and/or update to your personal information, withdraw your consent to data processing or execute any of your privacy rights as found in our privacy policy. You can find our detailed Privacy Policy at https://www.firstbanknigeria.com/home/legal/privacy- policy/</li><li> If you have concerns relating to the processing of your personal information, you may do so at any time by contacting the Data Protection Officer on: <br/><br/> Telephone: 0700 FIRSTCONTACT (0700 34778 2668228) <br/> Email:firstcontact.complaints@firstbankgroup.com or dataprotectionoffice@firstbankgroup.com<br/>We will respond to your concerns within 30 days of receiving your notice. <br/><br/> You also have the right to lodge a complaint directly with the supervisory authority, Nigeria Data Protection Commission (NDPC) where you suspect any misconduct or violations of the above listed rights in section. Email: info@ndpc.gov.ng </li><li> You will be considered to have given your consent to us for the processing of your Personal and Sensitive Personal Data when you agree to the stated terms on these FirstToken Terms and Conditions.</li> ";
    
    NSData *htmlData = [htmlTerms dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
    NSError *error = nil;
    NSAttributedString *attributedTerms =[[NSAttributedString alloc] initWithData:htmlData options:options documentAttributes:nil error:&error];
    if (error) {
        //Hanle any errors
        NSLog(@"Error converting HTML to NSAttributedString: %@", error.localizedDescription);
    } else {
        //set the attributed string to the UITextView
        self.termsTextView.attributedText = attributedTerms;
        self.termsTextView.font = [UIFont systemFontOfSize:14];
        self.termsTextView.textColor = [UIColor blackColor];
        self.view.backgroundColor = [UIColor whiteColor];
        self.termsTextView.backgroundColor = [UIColor whiteColor];
        self.termsTextView.scrollEnabled = YES;
        self.termsTextView.textContainerInset = UIEdgeInsetsMake(20, 10, 20, 10);
        self.termsTextView.editable = NO;
        self.termsTextView.selectable = YES;
    }
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.presentationController.delegate = self;
}

- (IBAction)declineButtonTapped:(UIButton *)sender {
   [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)acceptButtonTapped:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegistrationCodeViewController *cardDetailsVC = [storyboard instantiateViewControllerWithIdentifier:@"cardNum"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:cardDetailsVC];
    cardDetailsVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navController animated:YES completion:nil];
}


-(BOOL) presentationControllerShouldDismiss:(UIPresentationController *)presentationController {
    return NO;
}


@end
