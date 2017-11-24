//
//  NetworkManager.m
//  PartyBuilding
//
//  Created by 张振波 on 2017/4/22.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "NetworkManager.h"
#import "AFHTTPSessionManager.h"
#import "AESDESCrypt.h"
#import "MAS_AFJSONRequestSerializer.h"
NSString *const NetworManagerNeedLoginNotification = @"NetworManagerNeedLoginNotification";
NSString * const NetworkManagerCookiesKey = @"kShareCookiesKey";

@implementation NetworkManager
{
    AFHTTPSessionManager *sessionManager;
    NSString *cookies;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        http://122.114.223.113
//        sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://demo.szshangtong.com/api/"] sessionConfiguration:configuration];
        sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:API_URL] sessionConfiguration:configuration];
        MAS_AFJSONRequestSerializer *requestSerializer = [[MAS_AFJSONRequestSerializer alloc] init];
        sessionManager.requestSerializer = requestSerializer;
        sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"application/x-www-form-urlencoded",@"text/html", nil];
        self.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [self.reachabilityManager startMonitoring];
    }
    return self;
}

+(NetworkManager *)shareManager {
    static NetworkManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        _sharedManager = [[NetworkManager alloc] init];
        
    });
    return _sharedManager;
}

- (void)POST:(nullable NSDictionary *)parameters
      sucess:(void(^)(NSDictionary *_Nullable response))success
     failure:(void(^)(NSString *errorMessage))failure
{
//    NSLog(@"main url :%@",MAIN_URL);
    [sessionManager POST:@"" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *msg = [responseObject objectForKey:@"msg"];
        NSDictionary *param = [msg objectForKey:@"param"];
        NSString *errorCode = [param objectForKey:@"errorCode"];
        if ([errorCode isEqualToString:@"0"]) {
            success(param);
        }
        else {
            NSString *message = [param objectForKey:@"message"];
            failure(message);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
#ifdef DEBUG
        NSString *message = [NSString stringWithFormat:@"%@ %ld",[error localizedDescription],(long)response.statusCode];
        failure(message);
#else
        if (response == nil) {
            NSString *message = [NSString stringWithFormat:@"%@",[error localizedDescription]];
            failure(message);
        }else if (response.statusCode>=400) {
            failure(@"服务器有点忙，请稍后再试");
        }
#endif
    }];
}

- (void)fetchDataWihtUrl:(NSString *)url
                  method:(NSString *)method
              parameters:(NSDictionary *)param
                  sucess:(void(^)(NSDictionary *response))success
                 failure:(void(^)(NSString *errorMessage,NSInteger errorCode))failure

{
    NSDictionary *msg;
    if (param) {
        msg = @{@"param":param,
                @"type":@"1",
                @"platform":@"iOS",
                @"version":@"1",
                @"appName":@"BBC",
                @"method":method
                };
        
    }
    else {
        msg = @{@"type":@"1",
                @"platform":@"iOS",
                @"version":@"1",
                @"appName":@"BBC",
                @"method":method
                };
        
    }
    NSDictionary *parameters = @{@"msg":msg};
    NSLog(@"%@方法上传的数据：%@",method,parameters);
    [sessionManager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *msg = [responseObject objectForKey:@"msg"];
        NSDictionary *param = [msg objectForKey:@"param"];
        NSString *errorCode = [param objectForKey:@"errorCode"];
        NSLog(@"response: %@",responseObject);
        if ([errorCode isEqualToString:@"0"]) {
            success(param);
        }
        else {
            if ([errorCode isEqualToString:@"-2"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NetworManagerNeedLoginNotification object:task];
            }
            NSString *message = [param objectForKey:@"message"];
            NSInteger errorCodeInteger = [errorCode integerValue];
            failure(message,errorCodeInteger);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"%ld",(long)response.statusCode);
        NSString *message = [NSString stringWithFormat:@"%@ %ld",[error localizedDescription],(long)response.statusCode];
        failure(message,response.statusCode);
    }];
}

- (void)fetchDataWihtUrl:(NSString *)url
              parameters:(NSDictionary *)param
                  sucess:(void(^)(NSDictionary *response))success
                 failure:(void(^)(NSString *errorMessage,NSInteger errorCode))failure

{
    NSDictionary *msg;
    if (param) {
        msg = @{@"param":param,
                @"type":@"1",
                @"platform":@"iOS",
                @"version":@"1",
                @"appName":@"BBC",
                };
        
    }
    else {
        msg = @{@"type":@"1",
                @"platform":@"iOS",
                @"version":@"1",
                @"appName":@"BBC",
                };
        
    }
    NSDictionary *parameters = @{@"msg":msg};
    [sessionManager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *msg = [responseObject objectForKey:@"msg"];
        NSDictionary *param = [msg objectForKey:@"param"];
        NSString *errorCode = [param objectForKey:@"errorCode"];
        NSLog(@"response: %@",responseObject);
        if ([errorCode isEqualToString:@"0"]) {
            success(param);
        }
        else {
            if ([errorCode isEqualToString:@"-2"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NetworManagerNeedLoginNotification object:task];
            }
            NSString *message = [param objectForKey:@"message"];
            NSInteger errorCodeInteger = [errorCode integerValue];
            failure(message,errorCodeInteger);
        }
#warning For test,rember delete
        if ([errorCode isEqualToString:@"操作成功"]) {
            success(param);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"%ld",(long)response.statusCode);
        NSString *message = [NSString stringWithFormat:@"%@ %ld",[error localizedDescription],(long)response.statusCode];
        failure(message,response.statusCode);
    }];
}


- (void)fetchDataWihtMethod:(NSString *)method
                 parameters:(NSDictionary *)param
                     sucess:(void(^)(NSDictionary *response))success
                    failure:(void(^)(NSString *errorMessage,NSInteger errorCode))failure

{
    NSDictionary *msg;
    if (cookies == nil ) {
        cookies = [[NSUserDefaults standardUserDefaults] objectForKey:[AESDESCrypt encryptWithText:NetworkManagerCookiesKey]];
    }
    if (![sessionManager.requestSerializer valueForHTTPHeaderField:@"cookies"]) {
        NSString *setcookies = cookies? cookies : @"";
        [sessionManager.requestSerializer setValue:setcookies forHTTPHeaderField:@"cookies"];
    }
    if (param) {
        msg = @{@"param":param,
                @"type":@"1",
                @"platform":@"iOS",
                @"version":@"1",
                @"appName":@"BBC",
                @"method":method
                };
        
    }
    else {
        NSDictionary *param = [[NSDictionary alloc] init];
        msg = @{@"type":@"1",
                @"platform":@"iOS",
                @"version":@"1",
                @"appName":@"BBC",
                @"method":method,
                @"param":param
                };
        
    }
    NSDictionary *parameters = @{@"msg":msg};
//    NSDictionary *parameters = @{@"body":dic};
//    [self POST:parameters sucess:success failure:failure];
    NSString *body = [NSString stringWithFormat:@"body=%@",[[NSString alloc] initWithData:[self toJSONData:parameters] encoding:NSUTF8StringEncoding]];
    [sessionManager POST:API_URL parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *msg = [responseObject objectForKey:@"msg"];
        NSDictionary *param = [msg objectForKey:@"param"];
        NSString *errorCode = [param objectForKey:@"errorCode"];
        NSLog(@"response: %@",responseObject);
        if ([errorCode isEqualToString:@"0"]) {
            success(param);
        }
        else {
            if ([errorCode isEqualToString:@"-3"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NetworManagerNeedLoginNotification object:task];
            }
            NSString *message = [param objectForKey:@"message"];
            NSInteger errorCodeInteger = [errorCode integerValue];
            failure(message,errorCodeInteger);
        }
//#warning For test,rember delete
//        if ([errorCode isEqualToString:@"操作成功"]) {
//            success(param);
//        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"%ld",(long)response.statusCode);
        NSString *message = [NSString stringWithFormat:@"%@ %ld",[error localizedDescription],(long)response.statusCode];
        failure(message,response.statusCode);
    }];
//    NSArray *cookie = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//    NSLog(@"CookieStorage cookie%@",cookie);
    }
- (void)setHttpHeader:(NSString *)key value:(NSString *)value {
    [sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];
}

- (void)uploadImage:(UIImage *)image
           progress:(void(^_Nullable)(NSProgress * _Nonnull uploadProgress))progress
            success:(void(^_Nullable)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))success
            failure:(void(^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure
{
    NSString *method = @"fileUpload";
    NSDictionary *msg = @{@"param":@"",
            @"type":@"1",
//            @"platform":@"iOS",
            @"version":@"1",
//            @"appName":@"BBC",
            @"method":method
            };
    
    NSDictionary *parameters = @{@"msg":msg};
    NSDictionary *body = @{@"body":[self toJSONData:parameters]};
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *uploadSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:API_URL] sessionConfiguration:configuration];
    AFJSONRequestSerializer *requestSerializer = [[AFJSONRequestSerializer alloc] init];
    uploadSessionManager.requestSerializer = requestSerializer;
    uploadSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"application/x-www-form-urlencoded",@"text/html", nil];
    [uploadSessionManager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,@"tjh/fileUpload.do"] parameters:body constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imgData = UIImageJPEGRepresentation(image, 0);
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[formatter stringFromDate:date]];
        [formData appendPartWithFileData:imgData name:@"image" fileName:fileName mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"");
        NSDictionary *responseDic = responseObject;
        NSDictionary *msg = [responseDic objectForKey:@"msg"];
        NSDictionary *param = [msg objectForKey:@"param"];
        NSString *errorCode = [param objectForKey:@"errorCode"];
        NSLog(@"response: %@",responseObject);
        if ([errorCode isEqualToString:@"0"]) {
            success(task,param);
        }
        else {
            NSString *message = [param objectForKey:@"message"];
            NSInteger errorCodeInteger = [errorCode integerValue];
            NSError *error = [NSError errorWithDomain:task.currentRequest.URL.absoluteString code:errorCodeInteger userInfo:@{@"message":message}];
            failure(task,error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"");
        failure(task,error);
    }];
}
-(NSData *)toJSONData:(id)theData{
    
    NSError *error=nil;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:&error];
    if([jsonData length]>0 && error==nil)
    {
        return jsonData;
    }
    else
    {
        return nil;
    }
}

@end
