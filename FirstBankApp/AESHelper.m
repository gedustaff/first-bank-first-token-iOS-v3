#import "AESHelper.h"
#import "FirstBankApp-Swift.h"

@implementation AESHelper

+ (NSString *)decrypt:(NSString *)encryptedBase64 keyHex:(NSString *)keyHex {
    return [AESHelperSwift decryptWithBase64Cipher:encryptedBase64 hexKey:keyHex];
}

@end
