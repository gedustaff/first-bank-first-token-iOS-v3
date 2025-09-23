//
//  AESHelper.h
//  FirstBankApp
//
//  Created by cbc gedu on 20/08/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AESHelper : NSObject

+ (NSString *)decrypt:(NSString *)encryptedBase64 keyHex:(NSString *)keyHex;

@end
