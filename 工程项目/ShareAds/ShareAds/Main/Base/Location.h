//
//  Location.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/20.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import "BaseModel.h"
@interface Location : BaseModel
@property NSString *provId;//省
@property NSString *cityId;//市
@property NSString *areaId;//区
@property NSString *userId;

@end
