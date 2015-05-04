//
//  SettingsViewController.m
//  FirstBankApp
//
//  Created by Gedu Technologies on 4/13/15.
//  Copyright (c) 2015 Gedu Technologies. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblSerial;
@property (weak, nonatomic) IBOutlet UILabel *lblVersionNum;

@end

@implementation SettingsViewController
@synthesize setIdentity;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *serial = setIdentity.serialNumber;
    [_lblSerial setText: serial];
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [_lblVersionNum setText:appVersionString];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
    }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeSettings:(id)sender {
    
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
