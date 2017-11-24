//
//  Withdraw.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/17.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
/*
 id
 desc
 money
 time
 status
 */
@interface Withdraw : BaseModel
@property NSString *id;
@property NSString *desc;
@property float money;
@property NSInteger time;
@property NSString *status;
@end
