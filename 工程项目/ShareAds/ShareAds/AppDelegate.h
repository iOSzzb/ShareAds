//
//  AppDelegate.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/5.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SALocationManager.h"
extern NSString *const AppDelegateSysSuccessNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SALocationManager *locationManager;

@end

