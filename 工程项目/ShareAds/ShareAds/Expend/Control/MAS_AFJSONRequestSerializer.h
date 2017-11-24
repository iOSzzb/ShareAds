//
//  MAS_AFJSONRequestSerializer.h
//  BBC
//
//  Created by dongping.hong001@sino-life.com on 16/6/7.
//  Copyright © 2016年 洪东平. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface MAS_AFJSONRequestSerializer : AFJSONRequestSerializer

-(instancetype)init;

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error;

@end
