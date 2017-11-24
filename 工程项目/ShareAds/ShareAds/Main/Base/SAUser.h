//
//  User.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/14.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
extern NSString *const SAUserNeedReloadUserInfoNotifaction;
@interface SAUser : NSObject
/*
userId      String	是	用户ID
phoneId     String	是	手机号
name        String	是	姓名
birthday	String	是	生日
sex         String	是	性别
education	String	是	学历
occupation	String	是	职业
provinceId	String	是	地址省
cityId      String	是	地址市
areaId      String	是	地址区
addressDetail	String	是	地址详情
idNo        String	是	身份证号
idNoImage	String	是	手持身份证半身照
bankNumber	String	是	银行卡号
bankBranch	String	是	银行总行
bankSubBranch	String	是	银行支行
userImage	String	是	用户头像
level       String	是	用户等级
inviteCode	String	是	邀请码
isNeedInputInviteCode	String	是	Y/N
totalMoney	float	是	用户余额
adAccountMoney	float	是	广告账户资金
keTiJingE	float	是	可提金额
yiTiJingE	float	是	已提金额
levelApplyStatus	float	是	等级申请状态。01：无申请中；02：A升级B中；03：B升级C中。
 */
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *phoneId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *education;
@property (nonatomic, copy) NSString *occupation;
@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, copy) NSString *addressDetail;
@property (nonatomic, copy) NSString *idNo;
@property (nonatomic, copy) NSString *idNoImage;
@property (nonatomic, copy) NSString *bankNumber;
@property (nonatomic, copy) NSString *bankBranch;
@property (nonatomic, copy) NSString *bankSubBranch;
@property (nonatomic, copy) NSString *userImage;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *inviteCode;
@property (nonatomic, copy) NSString *isNeedInputInviteCode;
@property (nonatomic, strong) NSNumber *totalMoney;
@property (nonatomic, strong) NSNumber *adAccountMoney;
@property (nonatomic, strong) NSNumber *keTiJingE;
@property (nonatomic, strong) NSNumber *yiTiJingE;
@property (nonatomic, strong) NSNumber *levelApplyStatus;

+(SAUser *)shareUser;
+ (void)copyValues:(SAUser *)user;
- (NSString *)getUUID;
@end
