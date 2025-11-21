//
//  CompanyProfileCell.h
//  FirstBankApp
//
//  Created by cbc gedu on 29/10/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CompanyProfileCell : UITableViewCell

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UILabel *companyNameLabel;
@property (nonatomic, strong) UILabel *companyIdLabel;
@property (nonatomic, strong) UILabel *statusLabel; // Active/Inactive status
@property (nonatomic, strong) UILabel *tagLabel;    // FirstDirect/FinServe tag
@property (nonatomic, strong) UIImageView *iconView;

- (void)configureWithCompany:(NSDictionary *)company;

@end

NS_ASSUME_NONNULL_END
