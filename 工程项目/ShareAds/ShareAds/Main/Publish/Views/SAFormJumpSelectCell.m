//
//  SAFormJumpSelectCell.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/25.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAFormJumpSelectCell.h"

@implementation SAFormJumpSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(SAFormViewModel *)model {
    [super setModel:model];
    _titleLabel.text = model.title;
    _subtitleLabel.text = model.placeHolder;
    
}
@end
