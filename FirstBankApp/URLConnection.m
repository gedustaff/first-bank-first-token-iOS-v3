//
//  URLConnection.m
//  FirstBankApp
//
//  Created by Dapsonco on 23/04/2018.
//  Copyright © 2018 Gedu Technologies. All rights reserved.
//

#import "URLConnection.h"

@implementation URLConnection
@synthesize responseData;

+ (NSString*)sendData:(NSString*)id pan:(NSString*)pan pin:(NSString*)pin{
    
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&pan=%@&pin=%@",id,@"f8d66c19-ed29-403e-9cf1-387f6c15b223", pan, pin];
    NSLog(@"Post Request, %@", post);
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"Final Posted Data , %@", posted);
    NSLog(@"Final Post Data , %@", postData);
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //Create URL Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    //[request setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/checkUser.php"]];
    [request setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/getID.php"]];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //set HTTP Header
    //[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [request setHTTPBody:postData];
    
    NSLog(@"Final Request Structure, %@", request);
    //NSString *postedRequest = [[NSString alloc] initWithData:request encoding:NSUTF8StringEncoding];
    
    NSLog(@"Posted Request, %@", request.HTTPBody);
    
    //Create URLConnection
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
    
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
   // NSString *responseText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
   // NSLog(@"Received Response, %@", responseText);
    
    //NSArray *json = [NSJSONSerialization JSONObjectWithData:[responseText dataUsingEncoding:NSUTF8StringEncoding]
     //                                               options:0 error:NULL];
    
    //NSString *responseCode = [json valueForKey:@"ResponseCode"];
    
    
    
    
}

//compose string to send



@end
