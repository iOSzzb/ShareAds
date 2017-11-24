//
//  SAUploadImgeStatusModel.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/31.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAUploadImgeStatusModel.h"

@implementation SAUploadImgeStatusModel
- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
        _status = SAUploadImgeStatusReady;
    }
    return self;
}
@end
