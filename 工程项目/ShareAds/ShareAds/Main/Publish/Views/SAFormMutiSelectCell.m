//
//  SAFormMutiSelectCell.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/27.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAFormMutiSelectCell.h"

@implementation SAFormMutiSelectCell
{
    __weak IBOutlet UIView *_backGroundView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_deleteButton addTarget:self action:@selector(deleteBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    _backGroundView.layer.cornerRadius = 5;
//    _backGroundView.backgroundColor = [UIColor colorWithRed:191.0/255.0 green:233.0/255.0 blue:255.0/255.0 alpha:1];
    _backGroundView.backgroundColor = LIGHT_GRAY_BACKGROUND_COLOR;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.minimumScaleFactor = 0.3;
}
- (void)deleteBtnPressed {
    if (_deleteBlock) {
        _deleteBlock();
    }
}
@end
