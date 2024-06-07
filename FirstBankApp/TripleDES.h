//
//  TripleDES.h
//  FirstBankApp
//
//  Copyright © 2018 Gedu Technologies. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import <Foundation/Foundation.h>

@interface TripleDES : NSObject

+ (NSData*)transformData:(NSData*)inputData operation:(CCOperation)operation withPassword:(NSString*)password;

@end
