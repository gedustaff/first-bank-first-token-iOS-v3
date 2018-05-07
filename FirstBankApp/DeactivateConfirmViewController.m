//
//  DeactivateConfirmViewController.m
//  FirstBankApp
//
//  Created by Dapsonco on 30/04/2018.
//  Copyright © 2018 Gedu Technologies. All rights reserved.
//

#import "DeactivateConfirmViewController.h"

@interface DeactivateConfirmViewController ()

@end

@implementation DeactivateConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)yesButton:(id)sender {
    [self performSegueWithIdentifier:@"deacTocard" sender:self];
}
- (IBAction)noButton:(id)sender {
    [self performSegueWithIdentifier:@"deactTopin" sender:self];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"deacTocard"]) {
        RegistrationCodeViewController *regVC = [segue destinationViewController];
        regVC.codeReuse = @"deactivate";
    }
}


@end
