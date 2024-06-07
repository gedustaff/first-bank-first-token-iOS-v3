/*
 
 ETConfigurationFile.h
 Entrust IdentityGuard Mobile SDK
 
 Copyright (c) 2014 Entrust, Inc. All rights reserved.
 Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
 
 */


#import <Foundation/Foundation.h>

/// The various sizes of logos available.

typedef enum ETLogoSize {
    
    /// The recommended size for this logo size is 112x32px.
    
    ETLogoSizeSmall,
    
    /// The recommended size for this logo size is 240x68px.
    
    ETLogoSizeMedium,
    
    /// The recommended size for this logo size is 336x96px.
    
    ETLogoSizeLarge,
    
    /// The recommended size for this logo size is 420x96px.
    
    ETLogoSizeExtraLarge
} ETLogoSize;



/// This class stores the data retrieved from the identity provider
/// soft token configuration file.

@interface ETConfigurationFile : NSObject <NSSecureCoding> {
    
    
    /// The dictionary of localized identity provider names where the locale is the key into the dictionary.
    /// The key 'default' is populated with the value that should be used if your locale is not present.
    /// It's recommended that you use the localizedLabelString property instead.
    
    NSDictionary *localizedLabels;
    
    
    /// The dictionary of localized logos where the locale is the key into the dictionary.
    /// The key 'default' is populated with the value that should be used if your locale is not present.
    /// It's recommended that you use the logoPathWithMaxSize method instead.
    
    NSDictionary *localizedLogos;
    
    
    /// The identity provider transaction component URL.
    
    NSString *transactionUrl;
    
    
    /// The identity provider brand color as a hex digits.
    
    NSString *color;
}

@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *transactionUrl;
@property (nonatomic, strong) NSDictionary *localizedLabels;
@property (nonatomic, strong) NSDictionary *localizedLogos;


/// Returns the identity provider name for the current locale.

@property (nonatomic, readonly, strong) NSString *localizedLabelString;


/// Returns the path (url) to the small logo for the current locale.

@property (nonatomic, readonly, strong) NSString *localizedSmallLogoPath;


/// Returns the path (url) to the medium logo for the current locale.

@property (nonatomic, readonly, strong) NSString *localizedMediumLogoPath;


/// Returns the path (url) to the large logo for the current locale.

@property (nonatomic, readonly, strong) NSString *localizedLargeLogoPath;


/// Returns the path (url) to the extra large logo for the current locale.

@property (nonatomic, readonly, strong) NSString *localizedXLargeLogoPath;


/// Returns the largest available logo that doesn't exceed the maxLogoSize for the current locale.

///  - Parameter maxLogoSize: The maximum logo size that you want.
///  - Returns:  The path (url) to the logo.

- (NSString *)logoPathWithMaxSize:(ETLogoSize)maxLogoSize;

@end
