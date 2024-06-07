//
//  URLConnection.m
//  FirstBankApp
//
//  Copyright © 2018 Gedu Technologies. All rights reserved.
//

#import "URLConnection.h"

@implementation URLConnection
@synthesize responseData;

+ (NSString*)sendData:(NSString*)id pan:(NSString*)pan pin:(NSString*)pin{
    
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&pan=%@&pin=%@",id,@"f8d66c19-ed29-403e-9cf1-387f6c15b223", pan, pin];

    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    //Create URL Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    [request setURL:[NSURL URLWithString:@"https://firsttokenprod.firstbanknigeria.com/FirstTokenmiddleware/getID.php"]];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //set Body
    [request setHTTPBody:postData];
    
    NSLog(@"Final Request Structure, %@", request);
    
    NSLog(@"Posted Request, %@", request.HTTPBody);
    
    //Create URLConnection
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    return @"";
    
    
    
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
   // [responseData setLength:0];
}


// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
    
   // [responseData appendData: data];
    NSLog(@"recieved data @push %@", data);
    
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"error message: %@", error);
    
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{

}


@end
