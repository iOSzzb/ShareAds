//
//  AppDelegate.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/5.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "AppDelegate.h"
#import "SATabBarController.h"
#import "SAUser.h"
#import "NetworkInterface.h"
#import "SALanunchView.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
@interface AppDelegate ()

@end
NSString * const AppDelegateSysSuccessNotification = @"AppDelegateSysSuccessNotification";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    SALanunchView *lanunchView = [[SALanunchView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [SATabBarController new];
    [self.window makeKeyAndVisible];
    [self.window addSubview:lanunchView];
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"document path = %@",doc);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [NetworkInterface autoLogin:^(NSDictionary *response) {
        dispatch_group_enter(group);
        [NetworkInterface syncTradesInfo:^(NSArray<Trade *> *tradeList) {
            dispatch_group_leave(group);
        } failure:^(NSString *message, NSInteger errorCode) {
            
        }];
        dispatch_group_enter(group);
        [NetworkInterface syncAreaInfo:^(NSArray<Province *> *provinceList, NSArray<City *> *cityList, NSArray<District *> *districtList) {
            dispatch_group_leave(group);
        } failure:^(NSString *message, NSInteger errorCode) {
            
        }];
        dispatch_group_enter(group);
        [NetworkInterface getUserInfo:^{
            dispatch_group_leave(group);
        } failure:^(NSString *message, NSInteger errorCode) {
            
        }];
        dispatch_group_leave(group);
    } failure:^(NSString *message, NSInteger errorCode) {
        
    }];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            lanunchView.transform = CGAffineTransformMakeScale(2.0, 2.0);
//            lanunchView.alpha = 0.0;
//            dispatch_group_leave(group);
//        } completion:^(BOOL finished) {
//            [lanunchView removeFromSuperview];
//        }];
//    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            lanunchView.transform = CGAffineTransformMakeScale(2.0, 2.0);
            lanunchView.alpha = 0.0;
            [[NSNotificationCenter defaultCenter] postNotificationName:AppDelegateSysSuccessNotification object:nil];
            self.locationManager = [[SALocationManager alloc] init];
            [self.locationManager getCurrentLoaction];
        } completion:^(BOOL finished) {
            [lanunchView removeFromSuperview];
        }];
    });
    [WXApi registerApp:WX_APPID];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSString *sourceAppliction = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    if ([sourceAppliction isEqualToString:@"com.tencent.mqq"]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    if ([sourceAppliction isEqualToString:@"com.tencent.mqq"]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
@end
