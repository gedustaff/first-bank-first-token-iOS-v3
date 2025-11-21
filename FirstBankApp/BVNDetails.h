#import <UIKit/UIKit.h>

@interface BVNDetails : UIViewController

@property (nonatomic, strong) NSDictionary *passedData;
@property (nonatomic, strong) NSDictionary *fullPassedData;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


//@property (nonatomic, strong) NSString *userid;
//@property (nonatomic, strong) NSString *regPhoneNumber;
//@property (nonatomic, strong) NSString *regAccount;
//@property (nonatomic, strong) NSString *otpReference;
//
//@property (nonatomic, strong) NSURLConnection *conn1;
//@property (nonatomic, strong) NSURLConnection *conn2;
//@property (nonatomic, strong) NSMutableURLRequest *requested;
//@property (nonatomic, strong) NSMutableURLRequest *requestOTP;
//@property (nonatomic, strong) NSMutableData *responseData;

@end

