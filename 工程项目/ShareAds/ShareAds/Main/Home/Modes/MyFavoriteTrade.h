//
//  MyFavoriteTrade.h
//  ShareAds
//
//  Created by 张振波 on 2017/12/4.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "Trade.h"
/**
 记录用户感兴趣的行业，在首页中展示
 */
@interface MyFavoriteTrade : BaseModel
@property NSString *userId;
@property RLMArray<Trade *><Trade> *trades;
@end
