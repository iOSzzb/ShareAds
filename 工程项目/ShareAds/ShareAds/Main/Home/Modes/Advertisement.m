//
//  Advertisement.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/17.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "Advertisement.h"
@implementation Advertisement
/*+(NSString *)primaryKey {
    return @"id";
}
 */
/*
+ (NSArray<NSString *> *)ignoredProperties {
    return @[@"timeShareArray",@"areaShareArray",@"chanelShareArray"];
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSArray *shareChannelArray = dic[@"shareChannelArray"];
    RLMRealm *realm = [RLMRealm defaultRealm];
    if (shareChannelArray != nil && ![shareChannelArray isEqual:[NSNull null]]) {
        [shareChannelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *channelId = obj;
            ShareChannel *shareChannel = [ShareChannel objectForPrimaryKey:channelId];
            if (shareChannel == nil) {
                shareChannel = [ShareChannel new];
                shareChannel.shareChannelId = channelId;
                [ShareChannel createOrUpdateInRealm:realm withValue:shareChannel];
            }
            [self.shareChannelArray addObject:shareChannel];
        }];
    }
    return YES;
}
 */

@end
