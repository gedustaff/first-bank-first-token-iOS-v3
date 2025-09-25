#import <UIKit/UIKit.h>

@interface BVNDetails : UIViewController

@property (nonatomic, strong) NSDictionary *passedData;
@property (nonatomic, strong) NSDictionary *fullPassedData;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

