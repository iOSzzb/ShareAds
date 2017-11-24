//
//  SAFormShareChannelCell.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/28.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAFormShareChannelCell.h"

@implementation SAFormShareChannelCell {
    
    __weak IBOutlet UIButton *_wechatFriendBtn;
    __weak IBOutlet UIButton *_wechatTimelLineBtn;
    __weak IBOutlet UIButton *_QQSpaceBtn;
    __weak IBOutlet UIButton *_QQFriendBtn;
    __weak IBOutlet UIImageView *_wechatFriendCheckMark;
    __weak IBOutlet UIImageView *_wechatTimeCheckMark;
    __weak IBOutlet UIImageView *_QQSpaceCheckMark;
    __weak IBOutlet UIImageView *_QQFriendCheckMark;
    NSMutableArray *strs;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    strs = [NSMutableArray new];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(SAFormViewModel *)model {
    [super setModel:model];
    self.titleLabel.text = model.title;
}
- (IBAction)check:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender == _wechatFriendBtn) {
        if (_wechatFriendBtn.isSelected == YES) {
            [strs addObject:@"b"];
        }
        else {
            [strs removeObject:@"b"];
        }
        [_wechatFriendCheckMark setHidden:!sender.selected];
    }
    if (sender == _wechatTimelLineBtn) {
        if (_wechatTimelLineBtn.isSelected == YES) {
            [strs addObject:@"a"];
        }
        else {
            [strs removeObject:@"a"];
        }
        [_wechatTimeCheckMark setHidden:!sender.selected];
    }
    if (sender == _QQSpaceBtn) {
        if (_QQSpaceBtn.isSelected == YES) {
            [strs addObject:@"c"];
        }
        else {
            [strs removeObject:@"c"];
        }
        [_QQSpaceCheckMark setHidden:!sender.selected];
    }
    if (sender == _QQFriendBtn) {
        if (_QQFriendBtn.isSelected == YES) {
            [strs addObject:@"d"];
        }
        else {
            [strs removeObject:@"d"];
        }
        [_QQFriendCheckMark setHidden:!sender.selected];
    }
    if (strs.count == 4) {
        self.model.commitObj = @"x";
    }
    else {
        NSString *commitObj;
        for (int i = 0; i<strs.count; i++) {
            NSString *x = strs[i];
            if (commitObj == nil) {
                commitObj = x;
            }
            else {
                commitObj = [NSString stringWithFormat:@"%@,%@",commitObj,x];
            }
        }
        self.model.commitObj = commitObj;
    }
}

@end
