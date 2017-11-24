//
//  SAFormMultiAddImgCell.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/27.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAFormMultiAddImgCell.h"

@implementation SAFormMultiAddImgCell
{
    __weak IBOutlet UIView *_backgroundView;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _backgroundView.layer.cornerRadius = 5;
    _backgroundView.backgroundColor = LIGHT_GRAY_BACKGROUND_COLOR;
}

@end
