//
//  SAMeViewModel.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/14.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAMeViewModel.h"

@implementation SAMeViewModel
+ (NSArray<SAMeViewModel *> *)prepareForMeTableView {
    SAMeViewModel *level = [SAMeViewModel new];
    level.leftText = @"我的等级";
    SAMeViewModel *score = [SAMeViewModel new];
    score.leftText = @"我的积分";
    SAMeViewModel *cash = [SAMeViewModel new];
    cash.leftText = @"我的提现";
    SAMeViewModel *marketing = [SAMeViewModel new];
    marketing.leftText = @"我的推广";
    SAMeViewModel *favorite = [SAMeViewModel new];
    favorite.leftText = @"我的收藏";
    SAMeViewModel *bankCard = [SAMeViewModel new];
    bankCard.leftText = @"我的银行卡";
    SAMeViewModel *realName = [SAMeViewModel new];
    realName.leftText = @"实名认证";
    SAMeViewModel *invitation = [SAMeViewModel new];
    invitation.leftText = @"邀请好友";
    return @[level,score,cash,marketing,favorite,bankCard,realName,invitation];
}
@end
