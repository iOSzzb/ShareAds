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
    __weak IBOutlet UIButton *_editBtn;
    __weak IBOutlet UIButton *_offBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _editBtn.layer.cornerRadius = 3;
    _editBtn.layer.borderColor = APP_TIN_COLOR.CGColor;
    _editBtn.layer.borderWidth = 1;
    _editBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    _offBtn.layer.cornerRadius = 3;
    _offBtn.layer.borderColor = APP_TIN_COLOR.CGColor;
    _offBtn.layer.borderWidth = 1;
    _offBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnClicked:(UIButton *)sender {
    if (_actionBlock) {
        if (sender == _editBtn) {
            _actionBlock(PublishCellOptTypeEdit);
        } else if (sender == _offBtn) {
            _actionBlock(PublishCellOptTypeRemove);
        }
    }
}

@end
