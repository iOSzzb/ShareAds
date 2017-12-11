//
//  SATitleOnRightButton.m
//  ShareAds
//
//  Created by 张振波 on 2017/12/10.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SATitleOnRightButton.h"

@implementation SATitleOnRightButton
- (void)layoutSubviews {
    [super layoutSubviews];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.bounds.size.width, 0, self.imageView.bounds.size.width)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width)];
}
@end
