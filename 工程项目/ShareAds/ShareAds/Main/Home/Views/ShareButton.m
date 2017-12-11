//
//  ShareButton.m
//  ShareAds
//
//  Created by 张振波 on 2017/12/8.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "ShareButton.h"

@implementation ShareButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = LIGHT_GRAY_FONT_COLOR;
        self.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [self addSubview:_titleLabel];
        self.imageView = [UIImageView new];
        [self addSubview:_imageView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.centerX.equalTo(self.mas_centerX);
//            make.top.equalTo(_imageView.mas_bottom).offset(8);
        }];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.centerX.equalTo(self.mas_centerX);
        }];
    }
    return self;
}
@end
