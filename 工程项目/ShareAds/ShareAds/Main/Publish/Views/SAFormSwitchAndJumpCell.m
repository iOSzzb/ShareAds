//
//  SAFormSwitchAndJumpCell.m
//  ShareAds
//
//  Created by 张振波 on 2017/12/12.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAFormSwitchAndJumpCell.h"

@implementation SAFormSwitchAndJumpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setModel:(SAFormViewModel *)model {
    [super setModel:model];
    _titleLabel.text = model.title;
    _switchBtn.on = model.switchStatus;
    self.model.commitObj = _switchBtn.isOn?@"Y":@"N";
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"key");
}

- (void)switchAction:(UISwitch *)sender {
    self.model.switchStatus = sender.isOn;
    self.model.commitObj = sender.isOn?@"Y":@"N";
}
@end
