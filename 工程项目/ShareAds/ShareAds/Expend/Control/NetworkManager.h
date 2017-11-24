//
//  NetworkManager.h
//  PartyBuilding
//
//  Created by 张振波 on 2017/4/22.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const NetworManagerNeedLoginNotification;
extern NSString *const NetworkManagerCookiesKey;
@class AFNetworkReachabilityManager;
@interface NetworkManager : NSObject
@property (nonatomic, strong) AFNetworkReachabilityManager *  reachabilityManager;

+(instancetype)shareManager;
- (void)fetchDataWihtMethod:(NSString *)method
                 parameters:(NSDictionary *)param
                     sucess:(void(^)(NSDictionary * response))success
                    failure:(void(^)(NSString *errorMessage,NSInteger errorCode))failure;
- (void)fetchDataWihtUrl:(NSString *)url
                  method:(NSString *)method
              parameters:(NSDictionary *)param
                  sucess:(void(^)(NSDictionary *response))success
                 failure:(void(^)(NSString *errorMessage,NSInteger errorCode))failure;

- (void)fetchDataWihtUrl:(NSString *)url
              parameters:(NSDictionary *)param
                  sucess:(void(^)(NSDictionary *response))success
                 failure:(void(^)(NSString *errorMessage,NSInteger errorCode))failure;
- (void)setHttpHeader:(NSString *)key value:(NSString *)value;
- (void)uploadImage:(UIImage *)image
           progress:(void(^_Nullable)(NSProgress * _Nonnull uploadProgress))progress
            success:(void(^_Nullable)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))success
            failure:(void(^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
@end
