//
//  URLConnection.h
//  FirstBankApp
//
//  Copyright © 2018 Gedu Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLConnection : NSObject{
    NSMutableData *responseData;
}

@property (nonatomic, retain) NSMutableData *responseData;

@end
