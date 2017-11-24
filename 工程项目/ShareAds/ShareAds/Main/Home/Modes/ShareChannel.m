//
//  ShareChannel.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/17.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "ShareChannel.h"
#import <Realm/Realm.h>
//允许分享的渠道。01：微信朋友圈；02：微信好友；03：QQ空间；04：QQ好友
@implementation ShareChannel
+(NSString *)primaryKey {
    return @"shareChannelId";
}
@end
