//
//  Trade.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/19.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "BaseModel.h"

/**
 行业信息表
 */
/*
id	String	是	ID
desc	String	是	描述
versionNo	String	是	版本号
 */
@interface Trade : BaseModel
@property NSString *id;
@property NSString *desc;
@property NSString *versionNo;
@end
