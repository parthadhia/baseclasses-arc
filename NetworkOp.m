//
//  NetworkOp.m
//  guesstweet
//
//  Created by Denny Kwon on 12/28/12.
//  Copyright (c) 2012 com.thegridmedia. All rights reserved.
//

#import "NetworkOp.h"

@implementation NetworkOp
@synthesize address;
@synthesize delegate;
@synthesize responseHeaders;
@synthesize urlRequest;
@synthesize responseData;
@synthesize urlConnection;
@synthesize requestHeaders;
@synthesize networkStatus;

- (id)initWithAddress:(NSString *)a parameters:(NSDictionary *)p
{
    self = [super init];
    if (self){
        self.address = a;
        
        urlRequest = [[NSMutableURLRequest alloc] init];
        [self.urlRequest setHTTPMethod:@"POST"];
        if (p != nil) {
            NSString *postParameters = @"";
            NSArray *keys = [p allKeys];
            for (NSString *k in keys){
                postParameters = [postParameters stringByAppendingString:k];
                postParameters = [postParameters stringByAppendingString:@"="];
                postParameters = [postParameters stringByAppendingString:[p objectForKey:k]];
                postParameters = [postParameters stringByAppendingString:@"&"];
            }
            postParameters = [postParameters stringByAppendingString:@"none=none"]; //trailing parameter, serves no purpose but to end the string properly (key=value&key=value&none=none)
            [self.urlRequest setHTTPBody:[postParameters dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [self.urlRequest setURL:[NSURL URLWithString:address]];
    }
    return self;
}

+ (NetworkOp *)operationWithAddress:(NSString *)a parameters:(NSDictionary *)p
{
    NetworkOp *networkOp = [[NetworkOp alloc] initWithAddress:a parameters:p];
    return networkOp;
}

- (void)sendRequest
{
    if (self.urlConnection)
        return;
    
    NSLog(@"NETWORK OP - SendRequest: %@", self.address);
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    self.networkStatus = [reachability currentReachabilityStatus];
    if (self.networkStatus==NotReachable){
        NSLog(@"NETWORK OP - SendRequest: NOT REACHABLE");
        return;
    }
    
    if (self.networkStatus==ReachableViaWiFi)
        NSLog(@"NETWORK OP - SendRequest: ReachableViaWiFi");
    
    if (self.networkStatus==ReachableViaWWAN)
        NSLog(@"NETWORK OP - SendRequest: ReachableViaWWAN");
    
    if (self.requestHeaders){
        for (NSString *header in self.requestHeaders.allKeys) {
            [self.urlRequest setValue:[self.requestHeaders objectForKey:header] forHTTPHeaderField:header];
        }
    }
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    if (!urlConnection){
        [delegate requestData:nil];
        return;
    }
}

- (void)setHttpMethod:(NSString *)m
{
    [self.urlRequest setHTTPMethod:m];
}

- (void)cancel
{
    [self.urlConnection cancel];
    self.urlConnection = nil;
    
}

- (void)clear
{
    if (address != nil){
        self.address = nil;
    }
    if (responseData!=nil){
        self.responseData = nil;
    }
    if (urlConnection != nil){
        self.urlConnection = nil;
    }
    if (urlRequest != nil){
        self.urlRequest = nil;
        urlRequest = [[NSMutableURLRequest alloc] init];
        [self.urlRequest setHTTPMethod:@"POST"];
    }
}

- (id)jsonResponse
{
    if (!self.responseData)
        return nil;
    
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableContainers error:&error];
    if (error){
        NSLog(@"NETWORK OP - jsonResponse: JSON ERROR: %@", [error localizedDescription]);
        return nil;
    }
    
    return json;
}


#pragma mark -
#pragma mark URLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
    if(headers)
        self.responseHeaders = headers;
    
    NSLog(@"NETWORK OP - connection didReceiveResponse: %@", self.address);
    if ([self.delegate respondsToSelector:@selector(initialResponse:)])
        [self.delegate initialResponse:headers];
    
    if (responseData==nil){
        self.responseData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.responseData appendData:data];
    if ([delegate respondsToSelector:@selector(downloadedData:)]) //this clogs up the main thread
        [delegate downloadedData:data];
    
    //	NSLog(@"NETWORK OP - connection didReceiveData: %d", responseData.length);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"NETWORK OP - connectionDidFinishLoading");
    NSData *data = [self.responseData copy];
    
    [delegate requestData:[NSArray arrayWithObjects:address, data, nil]];
    self.responseData = nil;
    self.urlConnection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"NETWORK OP - connection didFailWithError: %@", [error localizedDescription]);
    [self.delegate requestData:nil];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end
