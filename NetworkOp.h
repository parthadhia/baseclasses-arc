//
//  NetworkOp.h
//  guesstweet
//
//  Created by Denny Kwon on 12/28/12.
//  Copyright (c) 2012 com.thegridmedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"


@protocol NetworkOpDelegate <NSObject>
@required
- (void)requestData:(NSArray *)pkg; //returns [address, data]
@optional
- (void)downloadedData:(NSData *)data;
- (void)initialResponse:(NSDictionary *)headers;
@end


@interface NetworkOp : NSObject

+ (NetworkOp *)operationWithAddress:(NSString *)a parameters:(NSDictionary *)p;
- (id)initWithAddress:(NSString *)a parameters:(NSDictionary *)p;
- (id)jsonResponse;
- (void)sendRequest;
- (void)setHttpMethod:(NSString *)m;
- (void)clear;
- (void)cancel;
@property (retain, nonatomic) NSMutableURLRequest *urlRequest;
@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSURLConnection *urlConnection;
@property (retain, nonatomic) NSString *address;
@property (retain, nonatomic) NSDictionary *responseHeaders;
@property (retain, nonatomic) NSDictionary *requestHeaders;
@property (nonatomic) NetworkStatus networkStatus;
@property (assign)id delegate;
@end
