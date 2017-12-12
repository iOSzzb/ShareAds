//
//  SAPublishCell.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/12.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAPublishCell.h"

@implementation SAPublishCell
{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _rightBtn.layer.cornerRadius = 3;
    _rightBtn.layer.borderColor = APP_TIN_COLOR.CGColor;
    _rightBtn.layer.borderWidth = 1;
    _rightBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    _leftBtn.layer.cornerRadius = 3;
    _leftBtn.layer.borderColor = APP_TIN_COLOR.CGColor;
    _leftBtn.layer.borderWidth = 1;
    _leftBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnClicked:(UIButton *)sender {
    if (_actionBlock) {
        if (sender == _leftBtn) {
            _actionBlock(PublishCellOptTypeLeft);
        } else if (sender == _rightBtn) {
            _actionBlock(PublishCellOptTypeRight);
        }
    }
}

@end
