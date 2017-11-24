//
//  SALanunchView.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/24.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SALanunchView.h"

@implementation SALanunchView
{
    UIImageView *_imageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initail];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initail];
    }
    return self;
}
- (void)initail {
    self.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    label.text = @"这是启动页";
    [self addSubview:label];
}
@end
