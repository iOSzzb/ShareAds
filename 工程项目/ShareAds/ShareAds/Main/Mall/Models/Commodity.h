//
//  Commodity.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/20.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "BaseModel.h"

/**
 兑换商品
 */

/*
 id	String	是	id
 type	String	是	商品类型
 desc	String	是	商品描述
 image	String	是	商品图标地址
 price	float	是	价格
 onlineTime	String	是	上架时间
 currNumber	int	是	当前商品数量
 sellNumber	int	是	已兑换数量
 url	String	是	链接地址
 */
@interface Commodity : NSObject
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,assign) float price;
@property (nonatomic,copy) NSString *onlineTime;
@property (nonatomic,assign) NSInteger currNumber;
@property (nonatomic,assign) NSInteger sellNumber;
@property (nonatomic,strong) NSArray *url;

@end
