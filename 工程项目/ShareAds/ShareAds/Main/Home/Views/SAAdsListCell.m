//
//  SAAdsListCell.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/11.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAAdsListCell.h"

@implementation SAAdsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)shareButtonPressed:(UIButton *)sender {
    if (_actionBlock) {
        _actionBlock(SAAdsListCellActionTypeShare);
    }
}
- (IBAction)collectionBtnPressed:(UIButton *)sender {
    if (_actionBlock) {
        _actionBlock(SAAdsListCellActionTypeFavorate);
    }
}

@end
