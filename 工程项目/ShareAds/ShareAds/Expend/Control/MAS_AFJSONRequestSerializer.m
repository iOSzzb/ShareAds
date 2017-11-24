//
//  MAS_AFJSONRequestSerializer.m
//  BBC
//
//  Created by dongping.hong001@sino-life.com on 16/6/7.
//  Copyright © 2016年 张振波. All rights reserved.
//

#import "MAS_AFJSONRequestSerializer.h"

@implementation MAS_AFJSONRequestSerializer

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        self.timeoutInterval = 30;
        self.HTTPShouldHandleCookies = YES;
    }
    return self;
}

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);
    
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]]) {
        return [super requestBySerializingRequest:request withParameters:parameters error:error];
    }
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    if (parameters) {
        NSStringEncoding enc=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        NSData *bodyData=[[NSString stringWithFormat:@"%@",parameters] dataUsingEncoding:enc allowLossyConversion:YES];
        [mutableRequest setHTTPBody:bodyData];
    }
    
    return mutableRequest;
}

@end
