//#import "CompanyProfileCell.h"
//
//@implementation CompanyProfileCell
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        UIView *container = [[UIView alloc] init];
//        container.backgroundColor = [UIColor whiteColor];
//        container.layer.cornerRadius = 12;
//        container.layer.borderWidth = 0.5;
//        container.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        container.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.contentView addSubview:container];
//
//        [NSLayoutConstraint activateConstraints:@[
//            [container.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8],
//            [container.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
//            [container.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
//            [container.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8],
//        ]];
//
//        // Icon
//        self.iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"company-icon"]];
//        self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
//        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
//        [container addSubview:self.iconView];
//
//        // Company Name
//        self.companyNameLabel = [[UILabel alloc] init];
//        self.companyNameLabel.font = [UIFont boldSystemFontOfSize:16];
//        self.companyNameLabel.textColor = [UIColor blackColor];
//        self.companyNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        [container addSubview:self.companyNameLabel];
//
//        // Tag (e.g. “FirstDirect”)
//        self.tagLabel = [[UILabel alloc] init];
//        self.tagLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
//        self.tagLabel.textColor = [UIColor colorWithRed:0 green:0.6 blue:0 alpha:1];
//        self.tagLabel.backgroundColor = [[UIColor colorWithRed:0 green:0.9 blue:0 alpha:0.1] colorWithAlphaComponent:0.15];
//        self.tagLabel.layer.cornerRadius = 6;
//        self.tagLabel.layer.masksToBounds = YES;
//        self.tagLabel.textAlignment = NSTextAlignmentCenter;
//        self.tagLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        [container addSubview:self.tagLabel];
//
//        // Company ID
//        self.companyIdLabel = [[UILabel alloc] init];
//        self.companyIdLabel.font = [UIFont systemFontOfSize:14];
//        self.companyIdLabel.textColor = [UIColor darkGrayColor];
//        self.companyIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        [container addSubview:self.companyIdLabel];
//
//        // Status (e.g. “Active”)
//        self.statusLabel = [[UILabel alloc] init];
//        self.statusLabel.font = [UIFont systemFontOfSize:13];
//        self.statusLabel.textColor = [UIColor systemGreenColor];
//        self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        [container addSubview:self.statusLabel];
//
//        // Arrow
//        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"chevron.right"]];
//        arrow.tintColor = [UIColor lightGrayColor];
//        arrow.translatesAutoresizingMaskIntoConstraints = NO;
//        [container addSubview:arrow];
//
//        // Layout
//        [NSLayoutConstraint activateConstraints:@[
//            [self.iconView.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:12],
//            [self.iconView.centerYAnchor constraintEqualToAnchor:container.centerYAnchor],
//            [self.iconView.widthAnchor constraintEqualToConstant:35],
//            [self.iconView.heightAnchor constraintEqualToConstant:35],
//
//            [self.companyNameLabel.leadingAnchor constraintEqualToAnchor:self.iconView.trailingAnchor constant:10],
//            [self.companyNameLabel.topAnchor constraintEqualToAnchor:container.topAnchor constant:10],
//
//            [self.tagLabel.leadingAnchor constraintEqualToAnchor:self.companyNameLabel.trailingAnchor constant:8],
//            [self.tagLabel.centerYAnchor constraintEqualToAnchor:self.companyNameLabel.centerYAnchor],
//            [self.tagLabel.heightAnchor constraintEqualToConstant:20],
//
//            [self.companyIdLabel.leadingAnchor constraintEqualToAnchor:self.iconView.trailingAnchor constant:10],
//            [self.companyIdLabel.topAnchor constraintEqualToAnchor:self.companyNameLabel.bottomAnchor constant:2],
//
//            [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.iconView.trailingAnchor constant:10],
//            [self.statusLabel.topAnchor constraintEqualToAnchor:self.companyIdLabel.bottomAnchor constant:4],
//            [self.statusLabel.bottomAnchor constraintEqualToAnchor:container.bottomAnchor constant:-10],
//
//            [arrow.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-12],
//            [arrow.centerYAnchor constraintEqualToAnchor:container.centerYAnchor],
//        ]];
//    }
//    return self;
//}
//
//- (void)configureWithCompany:(NSDictionary *)company {
//    self.companyNameLabel.text = company[@"organizationName"];
//    self.companyIdLabel.text = company[@"username"];
//    self.statusLabel.text = company[@"Active"];
//    self.tagLabel.text = company[@"platform"];
//}
//
//@end
//


#import "CompanyProfileCell.h"

// Define the padding constants for clean constraints
static const CGFloat kPadding = 15.0;
static const CGFloat kLabelSpacing = 5.0;

@interface CompanyProfileCell ()

//@property (nonatomic, strong) UIView *cardView;
//@property (nonatomic, strong) UILabel *companyNameLabel;
//@property (nonatomic, strong) UILabel *companyIdLabel;
//@property (nonatomic, strong) UILabel *statusLabel; // Active/Inactive status
//@property (nonatomic, strong) UILabel *tagLabel;    // FirstDirect/FinServe tag
//@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation CompanyProfileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupViews {
    // 1. Card View (Container for the profile)
    self.cardView = [[UIView alloc] init];
    self.cardView.backgroundColor = [UIColor whiteColor];
    self.cardView.layer.cornerRadius = 12.0;
    self.cardView.layer.masksToBounds = NO;
    self.cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardView.layer.shadowOpacity = 0.05;
    self.cardView.layer.shadowOffset = CGSizeMake(0, 2);
    self.cardView.layer.shadowRadius = 4;
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.cardView];

    // 2. Icon View (Placeholder for the organizational icon)
    self.iconView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"building.2.crop.circle.fill"]];
    self.iconView.tintColor = [UIColor colorWithRed:0 green:0.2 blue:0.5 alpha:1]; // Dark Blue
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cardView addSubview:self.iconView];

    // 3. Company Name Label (Top line of text)
    self.companyNameLabel = [[UILabel alloc] init];
    self.companyNameLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    // FIX: Ensure it truncates long names
    self.companyNameLabel.numberOfLines = 1;
    self.companyNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.companyNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cardView addSubview:self.companyNameLabel];

    // 4. Company ID Label (Bottom line of text, e.g., token ID)
    self.companyIdLabel = [[UILabel alloc] init];
    self.companyIdLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    self.companyIdLabel.textColor = [UIColor secondaryLabelColor];
    self.companyIdLabel.numberOfLines = 1;
    self.companyIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cardView addSubview:self.companyIdLabel];

    // 5. Tag Label (Small background tag, e.g., "FirstDirect")
    self.tagLabel = [[UILabel alloc] init];
    self.tagLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    self.tagLabel.textColor = [UIColor colorWithRed:0 green:0.2 blue:0.5 alpha:1];
    self.tagLabel.textAlignment = NSTextAlignmentCenter;
    self.tagLabel.layer.cornerRadius = 4.0;
    self.tagLabel.layer.borderWidth = 1.0;
    self.tagLabel.layer.borderColor = [self.tagLabel.textColor CGColor];
    self.tagLabel.layer.masksToBounds = YES;
    self.tagLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cardView addSubview:self.tagLabel];

    // 6. Status Label (Active status indicator)
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.statusLabel.textColor = [UIColor systemGreenColor];
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cardView addSubview:self.statusLabel];
}

- (void)setupConstraints {
    // Constraints for the main Card View
    [NSLayoutConstraint activateConstraints:@[
        [self.cardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:kLabelSpacing],
        [self.cardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:kPadding],
        [self.cardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-kPadding],
        [self.cardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-kLabelSpacing],
        // Set minimum height for the card view
        [self.cardView.heightAnchor constraintGreaterThanOrEqualToConstant:70]
    ]];

    // Constraints for the Icon View
    [NSLayoutConstraint activateConstraints:@[
        [self.iconView.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:kPadding],
        [self.iconView.centerYAnchor constraintEqualToAnchor:self.cardView.centerYAnchor],
        [self.iconView.widthAnchor constraintEqualToConstant:30],
        [self.iconView.heightAnchor constraintEqualToConstant:30]
    ]];

    // Constraints for the Tag Label (Fixed size, placed top right)
    [NSLayoutConstraint activateConstraints:@[
        [self.tagLabel.topAnchor constraintEqualToAnchor:self.cardView.topAnchor constant:kPadding],
        [self.tagLabel.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-kPadding],
        [self.tagLabel.heightAnchor constraintEqualToConstant:20],
        [self.tagLabel.widthAnchor constraintGreaterThanOrEqualToConstant:60] // Ensure minimum width
    ]];
    
    // Constraints for the Company Name Label (Most critical for shortening)
    [NSLayoutConstraint activateConstraints:@[
        [self.companyNameLabel.topAnchor constraintEqualToAnchor:self.cardView.topAnchor constant:kPadding],
        [self.companyNameLabel.leadingAnchor constraintEqualToAnchor:self.iconView.trailingAnchor constant:kPadding],
        // CRITICAL FIX: Constrain name label to the left of the tag label
        [self.companyNameLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.tagLabel.leadingAnchor constant:-kLabelSpacing],
    ]];

    // Constraints for the Company ID Label
    [NSLayoutConstraint activateConstraints:@[
        [self.companyIdLabel.leadingAnchor constraintEqualToAnchor:self.companyNameLabel.leadingAnchor],
        [self.companyIdLabel.topAnchor constraintEqualToAnchor:self.companyNameLabel.bottomAnchor constant:kLabelSpacing / 2],
        // Constrain ID label to the trailing edge of the card view (since it's a short token ID)
        [self.companyIdLabel.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-kPadding],
    ]];

    // Constraints for the Status Label (Bottom left, below icon)
    [NSLayoutConstraint activateConstraints:@[
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.companyNameLabel.leadingAnchor],
        [self.statusLabel.bottomAnchor constraintEqualToAnchor:self.cardView.bottomAnchor constant:-kPadding],
    ]];
    
    // Ensure the bottom of the card is defined by the status label or id label
    [self.statusLabel.topAnchor constraintGreaterThanOrEqualToAnchor:self.companyIdLabel.bottomAnchor constant:kLabelSpacing].active = YES;
}

// --- Your original method updated for better display ---

- (void)configureWithCompany:(NSDictionary *)company {
    // Assuming the 'company' dictionary now contains the stored token properties:
    // serialNumber, enrollmentId, and possibly custom display keys.
    
    NSString *organizationName = company[@"organizationName"];
    NSString *username = company[@"username"];
    
    // FIX 1: Apply truncation logic for long strings
    NSString *nameToDisplay = organizationName;
    NSString *idToDisplay = username;

    if (nameToDisplay.length > 30) {
        // Shorten very long names for a cleaner look
        nameToDisplay = [NSString stringWithFormat:@"%@...", [nameToDisplay substringToIndex:27]];
    }

    // Assign the text properties
    self.companyNameLabel.text = nameToDisplay;
    self.companyIdLabel.text = idToDisplay;
    
    // Assuming you determine the status and platform tag from the stored data
    self.statusLabel.text = @"Active"; // Set based on token status if available
    
    // Ensure the tag label has padding
    self.tagLabel.text = [NSString stringWithFormat:@"  %@  ", company[@"platform"] ?: @"TOKEN"];
    
    // Invalidate intrinsic content size to re-calculate layout
    [self layoutIfNeeded];
}

// Ensure proper height calculation for the table view
- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
    // For automatic cell height, call super and force layout pass
    [self layoutIfNeeded];
    return [super systemLayoutSizeFittingSize:targetSize withHorizontalFittingPriority:horizontalFittingPriority verticalFittingPriority:verticalFittingPriority];
}

@end
