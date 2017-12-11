//
//  SAExchangeCommdityTableViewCell.m
//  ShareAds
//
//  Created by 张振波 on 2017/12/11.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAExchangeCommdityTableViewCell.h"

@implementation SAExchangeCommdityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.textFieldCallbackBlock) {
        self.textFieldCallbackBlock(textField,SAExTBCellTextFieldStatusEnd);
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.textFieldCallbackBlock) {
        self.textFieldCallbackBlock(textField,SAExTBCellTextFieldStatusBegin);
    }
}
@end
