//
//  City.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/19.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "BaseModel.h"

/**
 城市
 */
/*
cityId	String	是	ID
provId	String	是	ID
desc	String	是	描述
versionNo	String	是	版本号
 */
@interface City : BaseModel
@property NSString *cityId;
@property NSString *provId;
@property NSString *desc;
@property NSString *versionNo;
@end
