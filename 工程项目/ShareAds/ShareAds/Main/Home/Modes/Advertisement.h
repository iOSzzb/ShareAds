//
//  Advertisement.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/17.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import "ShareChannel.h"
/*
 id	String	是	发布的广告id
 iconUrl	String	是	广告图标地址
 title	String	是	广告标题
 price	String	是	分享单价
 remainAmount	String	是	剩余总额
 url	String	是	广告链接
 shareTime	String	是	允许分享的时间段。01：无限制；02：周末；03：工作日
 shareArea	Array	是	允许分享的区域
 shareChannelArray	数组	是	允许分享的渠道。01：微信朋友圈；02：微信好友；03：QQ空间；04：QQ好友
 amount	String	是	广告总价
 shareNums	int	是	已分享的次数
 status	String	是	当前状态。01：上架中；02：已下架；03：审核中
 releaseTime	long	是	发布时间
 saveTime	long	是	收藏的时间
 
 timeShareArray	数组	是	不同时间分享次数列表。例：[2017/7/3:50;2017/7/4:80]
 areaShareArray	数组	是	区域分享次数列表。例：[01:50;02:80]
 chanelShareArray	数组	是	渠道分享次数列表。例：[01:50;02:80;03;90]
 */

/**
 广告
 */
@interface Advertisement : NSObject
@property NSString *id;
@property NSString *iconUrl;
@property NSString *title;
@property NSNumber *price;
@property NSNumber *remainAmount;
@property NSString *url;
@property NSString *shareTime;
@property NSArray *shareArea;
@property NSString *shareChannelArray;
@property NSNumber *amount;
@property NSInteger shareNums;
@property NSString *status;
@property NSString *releaseTime;
@property NSInteger saveTime;
@property (nonatomic, strong) NSArray *timeShareArray;
@property (nonatomic, strong) NSArray *areaShareArray;
@property (nonatomic, strong) NSArray *chanelShareArray;

@end
