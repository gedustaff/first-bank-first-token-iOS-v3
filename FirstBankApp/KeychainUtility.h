

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static const int kPBKDF2Iterations = 100000;
// Salt size (128 bits)
static const size_t kPBKDF2SaltLength = 16;
// Derived key size (256 bits)
static const size_t kPBKDF2KeyLength = 32;

@interface KeychainUtility : NSObject

extern NSString *const kPinAccessKey;



/**
 * Stores a string value securely in the iOS Keychain.
 * @param value The string (PIN) to store.
 * @param key The unique key used for retrieval (e.g., @"UserPIN").
 * @return YES on success, NO on failure.
 *
 
 */

+ (BOOL)verifyPin:(NSString *)inputPin storedHash:(NSString *)storedHashAndSalt;
+ (BOOL)addValue:(NSString *)value forKey:(NSString *)key;



+ (BOOL)updateValue:(NSString *)value forKey:(NSString *)key;


+ (NSString *)retrieveValueForKey:(NSString *)key;

/**
 * Retrieves a string value from the iOS Keychain.
 * @param key The unique key used for retrieval.
 * @return The stored string value, or nil if not found.
 */

+ (BOOL)deleteValueForKey:(NSString *)key;

+ (nullable NSString *)hashString:(NSString *)pin;



@end

NS_ASSUME_NONNULL_END
