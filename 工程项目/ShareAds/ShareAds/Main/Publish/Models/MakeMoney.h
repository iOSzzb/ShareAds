//
//  MakeMoney.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/17.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"


/*
id	String	是	id
type	String	是	01：分享广告；02：推荐APP；03：拉广告业务提成；04：兑换商品；05：提现；06：压金；07：被推荐人安装APP；08：输入了推荐人；
desc	String	是	记录描述
money	float	是	获取及消费的钱数
time	long	是	时间
status	String	是	01：已完成；02：进行中
 */

/**
 赚钱记录
 */
@interface MakeMoney : NSObject
@property NSString *id;
@property NSString *type;
@property NSString *desc;
@property float money;
@property NSInteger time;
@property NSString *status;
@end
