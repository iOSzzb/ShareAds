//
//  User.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/14.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAUser.h"
#import "AESDESCrypt.h"
NSString *const SAUserNeedReloadUserInfoNotifaction = @"SAUserNeedReloadUserInfoNotifaction";
@implementation SAUser
+(SAUser *)shareUser {
    static SAUser *_sharedUser = nil;
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        _sharedUser = [[SAUser alloc] init];
    });
    return _sharedUser;
}
- (NSString *)getUUID {
    NSString *key = [AESDESCrypt encryptWithText:@"UUID"];
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (uuid == nil) {
        uuid = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:[AESDESCrypt encryptWithText:uuid] forKey:key];
    }
    else {
        uuid = [AESDESCrypt decryptWithText:uuid];
    }
    return uuid;
}
+ (void)copyValues:(SAUser *)user {
    [SAUser shareUser].userId = user.userId;
    [SAUser shareUser].phoneId = user.phoneId;
    [SAUser shareUser].name = user.name;
    [SAUser shareUser].birthday = user.birthday;
    [SAUser shareUser].sex = user.sex;
    [SAUser shareUser].education = user.education;
    [SAUser shareUser].occupation = user.occupation;
    [SAUser shareUser].provinceId = user.provinceId;
    [SAUser shareUser].cityId = user.cityId;
    [SAUser shareUser].areaId = user.areaId;
    [SAUser shareUser].addressDetail = user.addressDetail;
    [SAUser shareUser].idNo = user.idNo;
    [SAUser shareUser].idNoImage = user.idNoImage;
    [SAUser shareUser].bankNumber = user.bankNumber;
    [SAUser shareUser].bankBranch = user.bankBranch;
    [SAUser shareUser].bankSubBranch = user.bankSubBranch;
    [SAUser shareUser].userImage = user.userImage;
    [SAUser shareUser].level = user.level;
    [SAUser shareUser].inviteCode = user.inviteCode;
    [SAUser shareUser].isNeedInputInviteCode = user.isNeedInputInviteCode;
    [SAUser shareUser].totalMoney = user.totalMoney;
    [SAUser shareUser].adAccountMoney = user.adAccountMoney;
    [SAUser shareUser].keTiJingE = user.keTiJingE;
    [SAUser shareUser].yiTiJingE = user.yiTiJingE;
    [SAUser shareUser].levelApplyStatus = user.levelApplyStatus;
}
@end
