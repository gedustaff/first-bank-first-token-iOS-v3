/*
 
 ETNotificationParams.h
 Entrust IdentityGuard Mobile SDK
 
 Copyright (c) 2014 Entrust, Inc. All rights reserved.
 Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
 
 */

#import <Foundation/Foundation.h>


/// The base notification parameters object.

@interface ETNotificationParams : NSObject

@end



/// The notification parameters from a new transaction notification.

@interface ETTransactionNotificationParams : ETNotificationParams
{
@private
    
    
    /// The transaction identifer.
    
    NSString *transactionId;
    
    
    /// The soft token identity identifier.
    
    NSString *identityId;
}
@property (nonatomic, strong) NSString *transactionId;
@property (nonatomic, strong) NSString *identityId;

@end
