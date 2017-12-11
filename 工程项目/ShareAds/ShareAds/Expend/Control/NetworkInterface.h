//
//  NetworkInterface.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/17.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAUser.h"
typedef NS_ENUM(NSInteger,NetworkErrorCode) {
    NetworkErrorCodeSuccess = 0,
    NetworkErrorCodeAuthSysError = -2,
    NetworkErrorCodeAuthFailed = -3,//会话失效，需要重新登录
    NetworkErrorCodeNillParam = -201,//传参时传了空参数
    NetworkErrorCodeParseFailed = -202,//解析参数出错
};

extern NSString *const NetworkInterfaceLoginSuccessNotification;

@class MakeMoney,Withdraw,Advertisement,ShareApp,Trade,Province,City,District,HomeBannerAds,Commodity,Location;
typedef void(^NetworkFailureBlock)(NSString *message,NSInteger errorCode);
typedef void(^NetworkSuccessBlock)(NSDictionary *response);

@interface NetworkInterface : NSObject

/**
 登录

 @param username 用户名
 @param password 密码
 @param failure 失败回调
 @param success 成功回调
 */

+(void)loginWithUsername:(NSString *)username
                password:(NSString *)password
                 success:(NetworkSuccessBlock)success
                 failure:(NetworkFailureBlock)failure;

+(void)autoLogin:(NetworkSuccessBlock)success
         failure:(NetworkFailureBlock)failure;
+(void)getOptCode:(NSString *)mobileNo
          success:(NetworkSuccessBlock)success
          failure:(NetworkFailureBlock)failure;
+(void)resetPassword:(NSString *)newPassword
             optCode:(NSString *)optCode
             success:(NetworkSuccessBlock)success
             failure:(NetworkFailureBlock)failure;
+(void)getUserInfo:(void(^)(void))success failure:(NetworkFailureBlock)failure;

/**
 从A升级到B级账户所需要提交的信息
 */
+(void)updateUserInfoA2B:(NSString *)phoneId
                    name:(NSString *)name
                birthday:(NSString *)birthday
                     sex:(NSString *)sex
               education:(NSString *)education
              occupation:(NSString *)occupation
              provinceId:(NSString *)provinceId
                  cityId:(NSString *)cityId
                  areaId:(NSString *)areaId
           addressDetail:(NSString *)addressDetail
                 success:(NetworkSuccessBlock )success
                 failure:(NetworkFailureBlock )failure;;
/**
 从B升级到C级账户所需要提交的信息
 */

+(void)updateUserInfoB2C:(NSString *)idNo
               idNoImage:(NSString *)idNoImage
              bankNumber:(NSString *)bankNumber
              bankBranch:(NSString *)bankBranch
           bankSubBranch:(NSString *)bankSubBranch
                 success:(NetworkSuccessBlock )success
                 failure:(NetworkFailureBlock )failure;
/**
 修改银行账户
 */

+(void)updateUserInfoToChangeBankNo:(NSString *)bankNumber
                         bankBranch:(NSString *)bankBranch
                      bankSubBranch:(NSString *)bankSubBranch
                            success:(NetworkSuccessBlock )success
                            failure:(NetworkFailureBlock )failure;
/**
 修改地址
 */

+(void)updateUserInfoToChangeAddr:(NSString *)provinceId
                           cityId:(NSString *)cityId
                           areaId:(NSString *)areaId
                    addressDetail:(NSString *)addressDetail
                          success:(NetworkSuccessBlock )success
                          failure:(NetworkFailureBlock )failure;
/**
 设置密码
 */

+(void)updateUserInfoToSetPassword:(NSString *)newPsw
                           success:(NetworkSuccessBlock )success
                           failure:(NetworkFailureBlock )failure;
/**
 修改密码
 */
+(void)updateUserInfoToPassword:(NSString *)oldPsw
                         newPsw:(NSString *)newPsw
                        success:(NetworkSuccessBlock )success
                        failure:(NetworkFailureBlock )failure;
/**
 查询钱获取及消费记录详情
 */
+(void)getMakeMoneyListInfoWithIndex:(NSInteger)index
                             success:(void(^)(NSArray<MakeMoney *>* list,float totalMoney,NSInteger pageSize))success
                             failure:(NetworkFailureBlock )failure;
/**
 查询提现获取记录详情	
 */
+ (void)getWithdrawListInfoWithIndex:(NSInteger)index
                             success:(void(^)(NSArray<Withdraw *> *list,float keTiJingE,float yiTiJingE, NSInteger pageSize))success
                             failure:(NetworkFailureBlock)failure;
/**
 查询我的推广 	
 */
+ (void)getShareAdsInfoWithIndex:(NSInteger)index
                         success:(void(^)(NSArray<Withdraw *> *list, NSInteger pageSize))success
                         failure:(NetworkFailureBlock)failure;
/**
 查询我的收藏
 */
+(void)getFavoriteWithIndex:(NSInteger)index
                    success:(void(^)(NSArray<Advertisement *> *list, NSInteger pageSize))success
                    failure:(NetworkFailureBlock)failure;
/**
 查询我推广APP的记录
 */
+(void)getShareAppRecordWithIndex:(NSInteger)index
                          success:(void(^)(NSArray<Advertisement *> *list, NSInteger pageSize))success
                          failure:(NetworkFailureBlock)failure;
/**
 请求推广APP
 */
+(void)reqShareApp:(NSArray *)area
           channel:(NSString *)channel
           success:(void(^)(ShareApp *shareApp))success
           failure:(NetworkFailureBlock)failure;
/**
 推广APP
 */
+ (void)shareApp:(NSArray *)area
         channel:(NSString *)channel
         success:(NetworkSuccessBlock)success
         failure:(NetworkFailureBlock)failure;
/**
 同步行业信息表	
 */
+(void)syncTradesInfo:(void(^)(NSArray<Trade*> *tradeList))success
              failure:(NetworkFailureBlock)failure;
/**
 同步区域信息表
 */
+ (void)syncAreaInfo:(void(^)(NSArray<Province *> *provinceList,NSArray<City *> *cityList,NSArray<District *> *districtList))success
             failure:(NetworkFailureBlock)failure;
/**
 查询首页广告
 */
+ (void)getMainPageAds:(void(^)(NSArray<HomeBannerAds *> *ads))success
               failure:(NetworkFailureBlock)failure;

/**
 查询已发布的广告

 @param index 查询页码，默认每页返回20条
 @param type 01：默认类型，按上架时间；02：剩余广告费；03：传播量；04：单价；05：行业，已上架时间排序；
 @param hangye 行业；
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)getAdsWithIndex:(NSInteger)index type:(NSString *)type hangye:(NSString *)hangye
                success:(void(^)(NSArray<Advertisement *> *list, NSInteger pageSize))success
                failure:(NetworkFailureBlock)failure;
/**
 请求分享广告
 */
+ (void)reqShareAdWithId:(NSString *)ID
                    area:(NSArray *)area
                 channel:(NSString *)channel
                 success:(NetworkSuccessBlock)success
                 failure:(NetworkFailureBlock)failure;

/**
 分享广告
 */
+ (void)shareAdWithId:(NSString *)ID
                 area:(NSArray *)area
              channel:(NSString *)channel
              success:(NetworkSuccessBlock)success
              failure:(NetworkFailureBlock)failure;
/**
 收藏广告
 */
+ (void)favoriteAdsWithId:(NSString *)ID
                  success:(NetworkSuccessBlock)success
                  failure:(NetworkFailureBlock)failure;
/**
 取消收藏广告
 */
+ (void)cancleFavoriteAdsWithId:(NSString *)ID
                        success:(NetworkSuccessBlock)success
                        failure:(NetworkFailureBlock)failure;
/**
 查询所有发布记录	
 */
+ (void)getReleaseAdsWithIndex:(NSInteger )index
                       success:(void(^)(NSArray<Advertisement *> *list, NSInteger pageSize))success
                       failure:(NetworkFailureBlock)failure;
/**
 查询指定的发布记录详情	
 */
+ (void)getSpectReleaseAdWithId:(NSString *)ID
                        success:(void(^)(Advertisement *ads))success
                        failure:(NetworkFailureBlock)failure;
/**
 发布广告
 */
+ (void)releaseAd:(NSDictionary *)param
          success:(NetworkSuccessBlock)success
          failure:(NetworkFailureBlock)failure;
/**
 停掉广告
 */
+ (void)stopAdWithId:(NSString *)ID
             success:(NetworkSuccessBlock)success
             failure:(NetworkFailureBlock)failure;
/**
 查询使用人数	
 */
+ (void)getSpecUserNumber:(NSDictionary *)param
                  success:(NetworkSuccessBlock)success
                  failure:(NetworkFailureBlock)failure;
/**
 查询商品列表	
 */
+ (void)getCommodityListWithIndex:(NSInteger)index
                                     type:(NSString *)type
                                 keywords:(NSString *)keywords
                                 sortType:(NSString *)sortType
                                  success:(void(^)(NSArray<Commodity *> *list ,NSInteger pageSize))success
                                  failure:(NetworkFailureBlock)failure;
/**
 查询兑换商品记录
 */
+ (void)getExchangeCommodityListWithIndex:(NSInteger)index
                                  success:(void(^)(NSArray<Withdraw *> *list, NSInteger pageSize))success
                                  failure:(NetworkFailureBlock)failure;
/**
 兑换商品	
 */
+ (void)exchangeCommodityWithID:(NSString *)commodityId
                  recipientName:(NSString *)recipientName
               recipientAddress:(NSString *)recipientAddress
                 recipientPhone:(NSString *)recipientPhone
                        success:(NetworkSuccessBlock)success
                        failure:(NetworkFailureBlock)failure;
/**
 上报当前所处位置	
 */
+ (void)reportLoction:(Location *)location
              success:(NetworkSuccessBlock)success
              failure:(NetworkFailureBlock)failure;
/**
 设置安装APP的推荐人的邀请码	
 通过getUserInfo接口中的isNeedInputInviteCode字段来判断是否需要设置安装APP的推荐人的邀请码	
 */
+ (void)setInviteCodeForShareApp:(NSString *)inviteCode
                         success:(NetworkSuccessBlock)success
                         failure:(NetworkFailureBlock)failure;
/**
 查询我的业务提成详情	
 */
+ (void)getBusinessPercentageInfo:(NSInteger)index
                          success:(void(^)(NSArray<Withdraw *> *list, NSInteger pageSize))success
                          failure:(NetworkFailureBlock)failure;
/**
 充值接口
 */
+ (void)recharge:(NSString *)money type:(NSString *)type
         success:(NetworkSuccessBlock)success
         failure:(NetworkFailureBlock)failure;
+ (void)syncCommodityTypeSuccess:(NetworkSuccessBlock)success
                         failure:(NetworkFailureBlock)failure;
@end
