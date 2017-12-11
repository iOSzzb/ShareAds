//
//  NetworkInterface.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/17.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "NetworkInterface.h"
#import "NetworkManager.h"
#import "AESDESCrypt.h"
#import "SAUser.h"
#import "MakeMoney.h"
#import "Withdraw.h"
#import "Advertisement.h"
#import "ShareApp.h"
#import "Trade.h"
#import "Province.h"
#import "City.h"
#import "District.h"
#import "HomeBannerAds.h"
#import "Commodity.h"
#import "Location.h"
#import "CommodityType.h"
NSString * const NetworkInterfaceLoginSuccessNotification = @"kNetworkInterfaceLoginSuccessNotification";

@implementation NetworkInterface
+(void)loginWithUsername:(NSString *)username
                password:(NSString *)password
                 success:(NetworkSuccessBlock)success
                 failure:(NetworkFailureBlock)failure
{
    if (username == nil || password == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"username":username,
                            @"password":password};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"login" parameters:param sucess:^(NSDictionary *response) {
        success(response);
        NSString *cookies = response[@"cookies"];
        [[NSUserDefaults standardUserDefaults] setObject:cookies forKey:[AESDESCrypt encryptWithText:NetworkManagerCookiesKey]];
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkInterfaceLoginSuccessNotification object:nil];
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure(errorMessage,errorCode);
    }];
}
+(void)autoLogin:(NetworkSuccessBlock)success
         failure:(NetworkFailureBlock)failure
{
    NSString *uuid = [[SAUser shareUser] getUUID];
    NSLog(@"UUID = %@",uuid);
    if (uuid == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"deviceId":@"89860025111457197848"};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"autoLogin" parameters:param sucess:^(NSDictionary *response) {
        success(response);
        NSString *cookies = response[@"cookies"];
        [[NSUserDefaults standardUserDefaults] setObject:cookies forKey:[AESDESCrypt encryptWithText:NetworkManagerCookiesKey]];
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkInterfaceLoginSuccessNotification object:nil];
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure(errorMessage,errorCode);
    }];
}
+(void)getOptCode:(NSString *)mobileNo
          success:(NetworkSuccessBlock)success
          failure:(NetworkFailureBlock)failure
{
    if (mobileNo == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"mobileNo":mobileNo};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"getOptCode" parameters:param sucess:^(NSDictionary *response) {
        success(response);
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure(errorMessage,errorCode);
    }];
}
+(void)resetPassword:(NSString *)newPassword
             optCode:(NSString *)optCode
             success:(NetworkSuccessBlock)success
             failure:(NetworkFailureBlock)failure

{
    if (newPassword == nil || optCode == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"newPassword":newPassword,@"optCode":optCode};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"resetPassword" parameters:param sucess:^(NSDictionary *response) {
        success(response);
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure(errorMessage,errorCode);
    }];
}
+(void)getUserInfo:(void(^)(void))success failure:(NetworkFailureBlock)failure {
    [[NetworkManager shareManager] fetchDataWihtMethod:@"getUserInfo" parameters:@{} sucess:^(NSDictionary *response) {
        SAUser *user = [SAUser yy_modelWithJSON:response];
        [SAUser copyValues:user];
        success();
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure(errorMessage,errorCode);
    }];
}
/*
phoneId	String	是	手机号
name	String	是	姓名
birthday	String	是	生日
sex	String	是	性别
education	String	是	学历
occupation	String	是	职业
provinceId	String	是	地址省
cityId	String	是	地址市
areaId	String	是	地址区
addressDetail	String	是	地址详情
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
                 failure:(NetworkFailureBlock )failure
{
    if (phoneId == nil ||
        name == nil ||
        birthday == nil ||
        sex == nil ||
        education == nil ||
        occupation == nil ||
        provinceId == nil ||
        cityId == nil ||
        areaId == nil ||
        addressDetail == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"phoneId":phoneId,
                            @"name":name,
                            @"birthday":birthday,
                            @"sex":sex,
                            @"education":education,
                            @"occupation":occupation,
                            @"provinceId":provinceId,
                            @"cityId":cityId,
                            @"areaId":areaId,
                            @"addressDetail":addressDetail,
                            @"opType":@"01"};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"updateUserInfo" parameters:param sucess:^(NSDictionary *response) {
        success(response);
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure(errorMessage,errorCode);
    }];
    
}

/*
 idNo	String	是	身份证号
 idNoImage	String	是	手持身份证半身照
 bankNumber	String	是	银行卡号
 bankBranch	String	是	银行总行
 bankSubBranch	String	是	银行支行
 */

+(void)updateUserInfoB2C:(NSString *)idNo
                    idNoImage:(NSString *)idNoImage
                bankNumber:(NSString *)bankNumber
                     bankBranch:(NSString *)bankBranch
               bankSubBranch:(NSString *)bankSubBranch
                 success:(NetworkSuccessBlock )success
                 failure:(NetworkFailureBlock )failure
{
    if (idNo == nil ||
        idNoImage == nil ||
        bankNumber == nil ||
        bankBranch == nil ||
        bankSubBranch == nil ) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"idNo":idNo,
                            @"idNoImage":idNoImage,
                            @"bankNumber":bankNumber,
                            @"bankBranch":bankBranch,
                            @"bankSubBranch":bankSubBranch,
                            @"opType":@"02"};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"updateUserInfo" parameters:param sucess:^(NSDictionary *response) {
        success(response);
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure(errorMessage,errorCode);
    }];
    
}
//bankNumber
//bankBranch
//bankSubBranch
+(void)updateUserInfoToChangeBankNo:(NSString *)bankNumber
                         bankBranch:(NSString *)bankBranch
                      bankSubBranch:(NSString *)bankSubBranch
                            success:(NetworkSuccessBlock )success
                            failure:(NetworkFailureBlock )failure
{
    if (bankNumber == nil ||
        bankBranch == nil ||
        bankSubBranch == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"bankNumber":bankNumber,
                            @"bankBranch":bankBranch,
                            @"bankSubBranch":bankSubBranch,
                            @"opType":@"03"};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"updateUserInfo" parameters:param sucess:^(NSDictionary *response) {
        success(response);
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure(errorMessage,errorCode);
    }];
    
}
//provinceId
//cityId
//areaId
//addressDetail
+(void)updateUserInfoToChangeAddr:(NSString *)provinceId
                           cityId:(NSString *)cityId
                           areaId:(NSString *)areaId
                    addressDetail:(NSString *)addressDetail
                          success:(NetworkSuccessBlock )success
                          failure:(NetworkFailureBlock )failure
{
    if (provinceId == nil ||
        cityId == nil ||
        areaId == nil ||
        addressDetail == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"provinceId":provinceId,
                            @"cityId":cityId,
                            @"areaId":areaId,
                            @"addressDetail":addressDetail,
                            @"opType":@"04"};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"updateUserInfo" parameters:param sucess:^(NSDictionary *response) {
        success(response);
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure(errorMessage,errorCode);
    }];
    
}
+(void)updateUserInfoToSetPassword:(NSString *)newPsw
                          success:(NetworkSuccessBlock )success
                          failure:(NetworkFailureBlock )failure
{
    if (newPsw == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"newPsw":newPsw,
                            @"opType":@"05"};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"updateUserInfo" parameters:param sucess:^(NSDictionary *response) {
        success(response);
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure(errorMessage,errorCode);
    }];
    
}
//oldPsw
//newPsw

+(void)updateUserInfoToPassword:(NSString *)oldPsw
                           newPsw:(NSString *)newPsw
                          success:(NetworkSuccessBlock )success
                          failure:(NetworkFailureBlock )failure
{
    if (newPsw == nil ||
        newPsw == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"oldPsw":oldPsw,
                            @"newPsw":newPsw,
                            @"opType":@"06"};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"updateUserInfo" parameters:param sucess:^(NSDictionary *response) {
        success(response);
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure(errorMessage,errorCode);
    }];
    
}

+(void)getMakeMoneyListInfoWithIndex:(NSInteger)index
                             success:(void(^)(NSArray<MakeMoney *>* list,float totalMoney,NSInteger pageSize))success
                             failure:(NetworkFailureBlock )failure
{
    NSDictionary *param = @{@"index":@(index)};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"getMakeMoneyListInfo" parameters:param sucess:^(NSDictionary *response) {
        NSArray *makeMoneyList = response[@"makeMoneyList"];
        float totalMoney = [response[@"totalMoney"] floatValue];
        NSInteger pageSize = [response[@"pageSize"] integerValue];
        NSMutableArray<MakeMoney *> *list = [NSMutableArray new];
        if (makeMoneyList != nil && ![makeMoneyList isEqual:[NSNull null]]) {
            [makeMoneyList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                MakeMoney *make = [MakeMoney yy_modelWithDictionary:dic];
                [list addObject:make];
            }];
            success([list copy],totalMoney,pageSize);
        }
        else {
            failure(@"没有可用数据",NetworkErrorCodeParseFailed);
        }
        
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure(errorMessage, errorCode);
    }];
}
+ (void)getWithdrawListInfoWithIndex:(NSInteger)index
                             success:(void(^)(NSArray<Withdraw *> *list,float keTiJingE,float yiTiJingE, NSInteger pageSize))success
                             failure:(NetworkFailureBlock)failure {
    NSDictionary *param = @{@"index":@(index)};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"getWithdrawListInfo" parameters:param sucess:^(NSDictionary *response) {
        NSArray *withdrawList = response[@"WithdrawList"];
        float keTiJingE = [response[@"keTiJingE"] floatValue];
        float yiTiJingE = [response[@"yiTiJingE"] floatValue];
        NSInteger pageSize = [response[@"pageSize"] integerValue];
        NSMutableArray<Withdraw*> *list = [NSMutableArray new];
        if (withdrawList != nil && ![withdrawList isEqual:[NSNull null]]) {
            [withdrawList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                Withdraw *withdraw = [Withdraw yy_modelWithDictionary:dic];
                [list addObject:withdraw];
            }];
            success([list copy],keTiJingE,yiTiJingE,pageSize);
        }
        else {
            failure(@"后台返回出错",NetworkErrorCodeParseFailed);
        }
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure(errorMessage,errorCode);
    }];
}

+ (void)getShareAdsInfoWithIndex:(NSInteger)index
                             success:(void(^)(NSArray<Withdraw *> *list, NSInteger pageSize))success
                             failure:(NetworkFailureBlock)failure {
    NSDictionary *param = @{@"index":@(index)};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"getShareAdsInfo" parameters:param sucess:^(NSDictionary *response) {
        NSArray *withdrawList = response[@"shareList"];
        NSInteger pageSize = [response[@"pageSize"] integerValue];
        NSMutableArray<Withdraw*> *list = [NSMutableArray new];
        if (withdrawList != nil && ![withdrawList isEqual:[NSNull null]]) {
            [withdrawList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                Withdraw *withdraw = [Withdraw yy_modelWithDictionary:dic];
                [list addObject:withdraw];
            }];
            success([list copy],pageSize);
        }
        else {
            failure(@"后台返回出错",NetworkErrorCodeParseFailed);
        }
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure(errorMessage,errorCode);
    }];
}
+(void)getFavoriteWithIndex:(NSInteger)index
                    success:(void(^)(NSArray<Advertisement *> *list, NSInteger pageSize))success
                    failure:(NetworkFailureBlock)failure {
    NSDictionary *param = @{@"index":@(index)};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"getFavorite" parameters:param sucess:^(NSDictionary *response) {
        NSArray *favoriteList = response[@"favoriteList"];
        NSInteger pageSize = [response[@"pageSize"] integerValue];
        NSMutableArray<Advertisement*> *list = [NSMutableArray new];
        if (favoriteList != nil && ![favoriteList isEqual:[NSNull null]]) {
            [favoriteList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                Advertisement *ad = [Advertisement yy_modelWithDictionary:dic];
                [list addObject:ad];
            }];
            success(list,pageSize);
        }
        else {
            failure(@"后台返回出错",NetworkErrorCodeParseFailed);
        }
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure(errorMessage,errorCode);
    }];
}
+(void)getShareAppRecordWithIndex:(NSInteger)index
                          success:(void(^)(NSArray<Advertisement *> *list, NSInteger pageSize))success
                          failure:(NetworkFailureBlock)failure {
    NSDictionary *param = @{@"index":@(index)};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"getShareAppRecord" parameters:param sucess:^(NSDictionary *response) {
        NSArray *withdrawList = response[@"WithdrawList"];
        NSInteger pageSize = [response[@"pageSize"] integerValue];
        NSMutableArray<Withdraw*> *list = [NSMutableArray new];
        if (withdrawList != nil && ![withdrawList isEqual:[NSNull null]]) {
            [withdrawList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                Withdraw *withdraw = [Withdraw yy_modelWithDictionary:dic];
                [list addObject:withdraw];
            }];
            success([list copy],pageSize);
        }
        else {
            failure(@"后台返回出错",NetworkErrorCodeParseFailed);
        }
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure(errorMessage,errorCode);
    }];
}
+(void)reqShareApp:(NSArray *)area
           channel:(NSString *)channel
           success:(void(^)(ShareApp *shareApp))success
           failure:(NetworkFailureBlock)failure {
    if (area == nil || channel == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"area":area,@"channel":channel};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"reqShareApp" parameters:param sucess:^(NSDictionary *response) {
        ShareApp *app = [ShareApp yy_modelWithJSON:response];
        success(app);
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure(errorMessage,errorCode);
    }];
}
+ (void)shareApp:(NSArray *)area
         channel:(NSString *)channel
         success:(NetworkSuccessBlock)success
         failure:(NetworkFailureBlock)failure {
    if (area == nil || channel == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"area":area,@"channel":channel};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"shareApp" parameters:param sucess:^(NSDictionary *response) {
        success(response);
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure(errorMessage,errorCode);
    }];
}
+(void)syncTradesInfo:(void(^)(NSArray<Trade*> *tradeList))success
              failure:(NetworkFailureBlock)failure{
    NSString *versionNo = nil;
    if ([Trade allObjects].count != 0) {
        Trade *trade = [Trade allObjects].firstObject;
        versionNo = trade.versionNo;
    }
    if (versionNo == nil) {
        versionNo = @"0";
    }
    NSDictionary *param = @{@"versionNo":versionNo};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"syncTradesInfo" parameters:param sucess:^(NSDictionary *response) {
//        NSString *returnVersionNo = response[@"version"];
        NSString *isNeedUpdate = response[@"isNeedUpdate"];
        if ([isNeedUpdate isEqualToString:@"N"]) {
            if (success) {
                success([NSArray new]);
            }
        }
        else {
            NSArray *tradeList = response[@"tradeList"];
            NSMutableArray<Trade *> *list = [NSMutableArray new];
            if (tradeList != nil && ![tradeList isEqual:[NSNull null]]) {
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                [tradeList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dic = obj;
                    Trade *trade = [Trade yy_modelWithJSON:dic];
                    Trade *localTrade = [Trade objectForPrimaryKey:trade.id];
                    if (localTrade == nil) {
//                        trade.versionNo = returnVersionNo;
                        [Trade createInRealm:realm withValue:trade];
                        [list addObject:trade];
                    } else {
                        localTrade.desc = trade.desc;
                        [list addObject:localTrade];
                    }
                }];
                [realm commitWriteTransaction];
                if (success) {
                    success([list copy]);
                }
            }
            else {
                if (failure) {
                    failure(@"后台返回数据出错",NetworkErrorCodeParseFailed);
                }
            }
        }
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        if (failure) {
            failure(errorMessage,errorCode);
        }
    }];
}
+ (void)syncAreaInfo:(void(^)(NSArray<Province *> *provinceList,NSArray<City *> *cityList,NSArray<District *> *districtList))success
             failure:(NetworkFailureBlock)failure
{
    NSString *versionNo = nil;
    if ([Province allObjects].count != 0) {
        Province *province = [Province allObjects].firstObject;
        versionNo = province.versionNo;
    }
    if (versionNo == nil) {
        versionNo = @"0";
    }

    NSDictionary *param = @{@"versionNo":versionNo};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"syncAreaInfo" parameters:param sucess:^(NSDictionary *response) {
        NSString *returnVersionNo = response[@"versionNo"];
        NSString *isNeedUpdate = response[@"isNeedUpdate"];
        if ([isNeedUpdate isEqualToString:@"N"]) {
            if (success != nil) {
                success([NSArray new],[NSArray new],[NSArray new]);
            }
        }
        else {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            NSArray *provList = response[@"provList"];
            NSMutableArray<Province *> *provMut = [NSMutableArray new];
            [provList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                Province *province = [Province yy_modelWithJSON:dic];
                province.versionNo = returnVersionNo;
                [Province createInRealm:realm withValue:province];
                [provMut addObject:province];
            }];
            NSArray *cityList = response[@"cityList"];
            NSMutableArray<City *> *cityMut = [NSMutableArray new];
            [cityList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                City *city = [City yy_modelWithJSON:dic];
                city.versionNo = returnVersionNo;
                [City createInRealm:realm withValue:city];
                [cityMut addObject:city];
            }];
            NSArray *areaList = response[@"areaList"];
            NSMutableArray<District *> *districtMut = [NSMutableArray new];
            [areaList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                District *district = [District yy_modelWithJSON:dic];
                district.versionNo = returnVersionNo;
                [District createInRealm:realm withValue:district];
                [districtMut addObject:district];
            }];
            [realm commitWriteTransaction];
            if (success) {
                success([provMut copy],[cityMut copy],[districtMut copy]);
            }
        }
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        if (failure) {
            failure(errorMessage,errorCode);
        }
    }];
}
+ (void)getMainPageAds:(void(^)(NSArray<HomeBannerAds *> *ads))success
               failure:(NetworkFailureBlock)failure {
    [[NetworkManager shareManager] fetchDataWihtMethod:@"getMainPageAds" parameters:@{} sucess:^(NSDictionary *response) {
        NSArray *adList = response[@"adList"];
        NSMutableArray *mutAdsList = [NSMutableArray new];
        if (adList != nil && ![adList isEqual:[NSNull null]]) {
            [adList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HomeBannerAds *ads = [HomeBannerAds yy_modelWithJSON:obj];
                [mutAdsList addObject:ads];
            }];
            success([mutAdsList copy]);
        }
        else {
            failure(@"后台返回数据出错",NetworkErrorCodeParseFailed);
        }
        
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        
    }];
}

+ (void)getAdsWithIndex:(NSInteger)index type:(NSString *)type hangye:(NSString *)hangye
                success:(void(^)(NSArray<Advertisement *> *list, NSInteger pageSize))success
                failure:(NetworkFailureBlock)failure {
    if (type == nil || hangye == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"index":@(index),
                            @"hangye":hangye,
                            @"type":type};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"getAds" parameters:param sucess:^(NSDictionary *response) {
        NSInteger pageSize = [response[@"pageSize"] integerValue];
        NSArray *adsList = response[@"adList"];
        NSMutableArray<Advertisement*> *list = [NSMutableArray new];
        if (adsList != nil && ![adsList isEqual:[NSNull null]]) {
            [adsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Advertisement *ad = [Advertisement yy_modelWithDictionary:obj];
                [list addObject:ad];
            }];
            success(list,pageSize);
        }
        else {
            failure(@"后台返回出错",NetworkErrorCodeParseFailed);
        }
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        
    }];
}
+ (void)reqShareAdWithId:(NSString *)ID
                    area:(NSArray *)area
                 channel:(NSString *)channel
                 success:(NetworkSuccessBlock)success
                 failure:(NetworkFailureBlock)failure
{
    if (ID == nil || area == nil || channel == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"area":area,@"channel":channel,@"id":ID,};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"reqShareAd" parameters:param sucess:success failure:failure];
}
+ (void)shareAdWithId:(NSString *)ID
                 area:(NSArray *)area
              channel:(NSString *)channel
              success:(NetworkSuccessBlock)success
              failure:(NetworkFailureBlock)failure{
    if (ID == nil || area == nil || channel == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"area":area,@"channel":channel,@"id":ID,};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"shareAd" parameters:param sucess:success failure:failure];
}
//action	String	是	01：收藏；02：取消收藏
+ (void)saveOrCancelAdWithId:(NSString *)ID
                      action:(NSString *)action
                     success:(NetworkSuccessBlock)success
                     failure:(NetworkFailureBlock)failure{
    NSDictionary *param = @{@"action":action,@"id":ID,};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"saveOrCancelAd" parameters:param sucess:success failure:failure];
}
+ (void)favoriteAdsWithId:(NSString *)ID
                  success:(NetworkSuccessBlock)success
                  failure:(NetworkFailureBlock)failure{
    if (ID == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    [NetworkInterface saveOrCancelAdWithId:ID action:@"01" success:success failure:failure];
}
+ (void)cancleFavoriteAdsWithId:(NSString *)ID
                  success:(NetworkSuccessBlock)success
                  failure:(NetworkFailureBlock)failure{
    if (ID == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    [NetworkInterface saveOrCancelAdWithId:ID action:@"02" success:success failure:failure];
}
+ (void)getReleaseAdsWithIndex:(NSInteger )index
                       success:(void(^)(NSArray<Advertisement *> *list, NSInteger pageSize))success
                       failure:(NetworkFailureBlock)failure {
    NSDictionary *param = @{@"index":@(index)};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"getReleaseAds" parameters:param sucess:^(NSDictionary *response) {
        NSInteger pageSize = [response[@"pageSize"] integerValue];
        NSArray *adsList = response[@"adList"];
        NSMutableArray<Advertisement*> *list = [NSMutableArray new];
        if (adsList != nil && ![adsList isEqual:[NSNull null]]) {
            [adsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Advertisement *ad = [Advertisement yy_modelWithDictionary:obj];
                [list addObject:ad];
            }];
            success(list,pageSize);
        }
        else {
            failure(@"后台返回出错",NetworkErrorCodeParseFailed);
        }
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        
    }];
}
+ (void)getSpectReleaseAdWithId:(NSString *)ID
                        success:(void(^)(Advertisement *ads))success
                        failure:(NetworkFailureBlock)failure {
    if (ID == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"id":ID};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"getSpectReleaseAd" parameters:param sucess:^(NSDictionary *response) {
        Advertisement *ads = [Advertisement yy_modelWithJSON:response];
        success(ads);
    } failure:failure];
}
+ (void)releaseAd:(NSDictionary *)param
          success:(NetworkSuccessBlock)success
          failure:(NetworkFailureBlock)failure{
    [[NetworkManager shareManager] fetchDataWihtMethod:@"releaseAd" parameters:param sucess:success failure:failure];
}
+ (void)stopAdWithId:(NSString *)ID
             success:(NetworkSuccessBlock)success
             failure:(NetworkFailureBlock)failure{
    if (ID == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"id":ID};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"stopAd" parameters:param sucess:success failure:failure];
        
}
+ (void)getSpecUserNumber:(NSDictionary *)param
                  success:(NetworkSuccessBlock)success
                  failure:(NetworkFailureBlock)failure {
    [[NetworkManager shareManager] fetchDataWihtMethod:@"getSpecUserNumber" parameters:param sucess:success failure:failure];
}
+ (void)getCommodityListWithIndex:(NSInteger)index
                             type:(NSString *)type
                         keywords:(NSString *)keywords
                         sortType:(NSString *)sortType
                          success:(void(^)(NSArray<Commodity *> *list ,NSInteger pageSize))success
                          failure:(NetworkFailureBlock)failure{
    NSDictionary *param = @{@"index":@(index),
                            @"type":type,
                            @"keywords":keywords,
                            @"sortType":sortType};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"getCommodityList" parameters:param sucess:^(NSDictionary *response) {
        NSInteger pageSize = [response[@"pageSize"] integerValue];
        NSArray *commodityList = response[@"commodityList"];
        NSMutableArray<Commodity *> *list = [NSMutableArray new];
        if (commodityList != nil && ![commodityList isEqual:[NSNull null]]) {
            [commodityList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Commodity *commodity = [Commodity yy_modelWithJSON:obj];
                [list addObject:commodity];
            }];
            success(list,pageSize);
        }
        else {
            failure(@"解析出错",NetworkErrorCodeParseFailed);
        }
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        
    }];
}
+ (void)getExchangeCommodityListWithIndex:(NSInteger)index
                                  success:(void(^)(NSArray<Withdraw *> *list, NSInteger pageSize))success
                                  failure:(NetworkFailureBlock)failure{
    NSDictionary *param = @{@"index":@(index)};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"getExchangeCommodityList" parameters:param sucess:^(NSDictionary *response) {
        NSArray *withdrawList = response[@"exchangeList"];
        NSInteger pageSize = [response[@"pageSize"] integerValue];
        NSMutableArray<Withdraw*> *list = [NSMutableArray new];
        if (withdrawList != nil && ![withdrawList isEqual:[NSNull null]]) {
            [withdrawList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                Withdraw *withdraw = [Withdraw yy_modelWithDictionary:dic];
                [list addObject:withdraw];
            }];
            success([list copy],pageSize);
        }
        else {
            failure(@"后台返回出错",NetworkErrorCodeParseFailed);
        }
    } failure:failure];
}
+ (void)exchangeCommodityWithID:(NSString *)commodityId
                  recipientName:(NSString *)recipientName
               recipientAddress:(NSString *)recipientAddress
                 recipientPhone:(NSString *)recipientPhone
                        success:(NetworkSuccessBlock)success
                        failure:(NetworkFailureBlock)failure {
    if (commodityId == nil || recipientName == nil || recipientAddress == nil || recipientPhone == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"commodityId":commodityId,
                            @"recipientName":recipientName,
                            @"recipientAddress":recipientAddress,
                            @"recipientPhone":recipientPhone};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"exchangeCommodity" parameters:param sucess:success failure:failure];
}
+ (void)withdrawAppay:(NSString *)type
                money:(float)money
              success:(NetworkSuccessBlock)success
              failure:(NetworkFailureBlock)failure{
    if (type == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *param = @{@"type":type,
                            @"money":@(money)};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"withdrawAppay" parameters:param sucess:success failure:failure];
}
+ (void)reportLoction:(Location *)location
              success:(NetworkSuccessBlock)success
              failure:(NetworkFailureBlock)failure{
    if (location == nil || ( location.areaId == nil && location.cityId == nil && location.provId == nil)) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSMutableDictionary *mutDic = [NSMutableDictionary new];
    if (location.provId) {
        [mutDic setObject:location.provId forKey:@"provinceCode"];
    }
    if (location.cityId) {
        [mutDic setObject:location.cityId forKey:@"cityCode"];
    }
    if (location.areaId) {
        [mutDic setObject:location.areaId forKey:@"areaCode"];
    }
    [[NetworkManager shareManager] fetchDataWihtMethod:@"reportLoction" parameters:mutDic sucess:success failure:failure];
}
+ (void)setInviteCodeForShareApp:(NSString *)inviteCode
                         success:(NetworkSuccessBlock)success
                         failure:(NetworkFailureBlock)failure{
    NSString *code = inviteCode;
    if (code == nil) {
        code = @"0";
    }
    NSDictionary *param = @{@"inviteCode":code};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"setInviteCodeForShareApp" parameters:param sucess:success failure:failure];
}
+ (void)getBusinessPercentageInfo:(NSInteger)index
                          success:(void(^)(NSArray<Withdraw *> *list, NSInteger pageSize))success
                          failure:(NetworkFailureBlock)failure{
    NSDictionary *param = @{@"index":@(index)};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"getShareAdsInfo" parameters:param sucess:^(NSDictionary *response) {
        NSArray *withdrawList = response[@"WithdrawList"];
        NSInteger pageSize = [response[@"pageSize"] integerValue];
        NSMutableArray<Withdraw*> *list = [NSMutableArray new];
        if (withdrawList != nil && ![withdrawList isEqual:[NSNull null]]) {
            [withdrawList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                Withdraw *withdraw = [Withdraw yy_modelWithDictionary:dic];
                [list addObject:withdraw];
            }];
            success([list copy],pageSize);
        }
        else {
            failure(@"后台返回出错",NetworkErrorCodeParseFailed);
        }
    } failure:failure];
}
+ (void)recharge:(NSString *)money type:(NSString *)type
         success:(NetworkSuccessBlock)success
         failure:(NetworkFailureBlock)failure
{
    if (type == nil) {
        failure(@"参数不能为空",NetworkErrorCodeNillParam);
        return;
    }
    NSDictionary *prarm = @{@"amount":money,@"rechargeType":type};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"recharge" parameters:prarm sucess:success failure:failure];
}
+ (void)syncCommodityTypeSuccess:(NetworkSuccessBlock)success
                         failure:(NetworkFailureBlock)failure {
    [[NetworkManager shareManager] fetchDataWihtMethod:@"syncCommodityType" parameters:@{} sucess:^(NSDictionary *response) {
        NSArray *commodityTypeList = response[@"commodityTypeList"];
        if (commodityTypeList != nil && ![commodityTypeList isEqual:[NSNull null]]) {
            [commodityTypeList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                CommodityType *commodityType = [CommodityType yy_modelWithDictionary:dic];
                RLMRealm *defaultRealm = [RLMRealm defaultRealm];
                [defaultRealm beginWriteTransaction];
                [CommodityType createOrUpdateInRealm:defaultRealm withValue:commodityType];
                [defaultRealm commitWriteTransaction];
            }];
        }
        if (success) {
            success(response);
        }
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        if (failure) {
            failure(errorMessage,errorCode);
        }
    }];
}
@end
