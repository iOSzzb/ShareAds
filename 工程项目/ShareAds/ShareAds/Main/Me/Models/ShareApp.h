//
//  ShareApp.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/17.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
/*
flag	String	是	01：允许分享；02：不允许分享
desc	String	是	请求成功或失败的理由
icon	String	是	分享APP的图标
title	String	是	分享APP的标题
url	String	是	分享APP的链接
 */
@interface ShareApp : NSObject
@property NSString *flag;
@property NSString *desc;
@property NSString *icon;
@property NSString *title;
@property NSString *url;

@end
