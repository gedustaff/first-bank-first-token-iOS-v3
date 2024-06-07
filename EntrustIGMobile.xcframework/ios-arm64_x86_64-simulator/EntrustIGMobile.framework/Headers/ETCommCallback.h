/*
 
 ETCommCallback.h
 Entrust IdentityGuard Mobile SDK
 
 Copyright (c) 2014 Entrust, Inc. All rights reserved.
 Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
 
 */
#import <Foundation/Foundation.h>


/// The ETCommRequest class defines the input values passed to a communication
/// request.

@interface ETCommRequest : NSObject
{
@private
    /// the URL to which the request must be sent
    NSURL *url;
    
    
    /// the parameters define the list of parameters that should be
    /// included in the HTTP request. Both keys and values must be NSStrings.
    /// These parameters must be included in the request as
    /// form-encoded parameters in the body of a POST message.
    /// Note that the strings in the table will not have had any encoding
    /// applied to them. It is the responsibility of the application
    /// sending the message to encode the parameters correctly. The
    /// HTTP Content-Type to use is
    /// <code>application/x-www-form-urlencoded;charset=UTF-8</code>
    
    NSDictionary *parameters;
    
    
    /// maximum allowed size for response data.  Zero or a negative value
    /// indicates any size is allowed.  If the response size exceeds
    /// the maximum size, an exception must be thrown.
    
    int maximumResponseSize;
}

@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, readonly) NSDictionary* parameters;
@property (nonatomic) int maximumResponseSize;


/// Create a new communication request for the given URL.

-(id)initWithURLString:(NSString*)url;


/// Add the given parameter name/value pair to the request.

-(void)addParameter:(NSString*)parameterValue forParameterNamed:(NSString*)parameterName;

-(void)toString;

@end



/// The ETCommResult class defines the values returned from the communication
/// request. Instances of this class are passed back to the SDK after
/// communications are complete.

@interface ETCommResult : NSObject
{
@private
    
    /// Data will contain the data returned in the response.  This data
    /// may be set for both successful and failed requests. If no data
    /// returned by the server, leave this property as nil.
    
    NSData *data;
    
    
    /// The HTTP response code returned from the server.
    
    int responseCode;
    
    
    /// The communication error if one occurred.
    
    NSError *error;
    
    
    /// Holds the headers returned in response. If no headers returned
    /// by the server, leave this property as nil.
    
    NSDictionary *headers;
    
}
@property (nonatomic, strong) NSData *data;
@property (nonatomic) int responseCode;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSDictionary *headers;

@end




/// The ETCommCallback protocol defines an interface used by the SDK to make
/// HTTP POST and HTTP GET requests to a given URL with given parameters and return
/// a result. SDK users must implement this protocol in order to
/// communicate with the IdentityGuard Self-Service Module transaction service.

@protocol ETCommCallback 

@required


/// Perform an HTTP POST request for the given request and return the result.
/// If there is a communication error, return an ETCommResult object with no
/// data; do not return nil.
///
/// - Parameter request: the request to perform. Any parameters included in the
///                request should be sent as form-encoded parameters in the
///                body of the POST message.
///
/// - Returns: the results returned from the request.

-(ETCommResult*) post:(ETCommRequest*)request;


/// Perform an HTTP GET request for the given request and return the result.
/// If there is a communication error, return an ETCommResult object with no
/// data; do not return nil.
///
/// - Parameter request: the request to perform. Any parameters included in the
///                request should be included in the request URL.  The parameters
///                object in the request is ignored for GET requests.
///
/// - Returns:  the results returned from the request.

-(ETCommResult*) get:(ETCommRequest*)request;


@end
