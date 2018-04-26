//
//  URLConnection.h
//  FirstBankApp
//
//  Created by Dapsonco on 23/04/2018.
//  Copyright © 2018 Gedu Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLConnection : NSObject{
    NSMutableData *responseData;
}

@property (nonatomic, retain) NSMutableData *responseData;

@end
