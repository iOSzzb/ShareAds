//
//  HomeBannerAds.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/19.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "BaseModel.h"

/**
 首页Banner广告
 */
/*
 picUrl	String	是	图片地址
 url	String	是	链接地址
 */
@interface HomeBannerAds : BaseModel
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *url;
@end
