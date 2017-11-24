//
//  SAFormInputCell.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/25.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAFormInputCell.h"
@interface SAFormInputCell()<UITextFieldDelegate>
@end
@implementation SAFormInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _textField.delegate = self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textField.delegate = self;
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(SAFormViewModel *)model {
    [super setModel:model];
    _titleLabel.text = model.title;
    _textField.text = model.commitObj?model.commitObj:@"";
    _textField.placeholder = model.placeHolder;
    _textField.keyboardType = model.keyboardType;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:SAFormViewModelFirstResponderNotification object:nil userInfo:@{@"responder":textField,@"model":self.model?self.model:[NSNull null],@"becomeFirstResponder":@1}];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:SAFormViewModelFirstResponderNotification object:nil userInfo:@{@"responder":textField,@"model":self.model?self.model:[NSNull null],@"becomeFirstResponder":@1}];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.model.inputText = textField.text;
    self.model.commitObj = textField.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:SAFormViewModelFirstResponderNotification object:nil userInfo:@{@"firstResponder":textField,@"model":self.model?self.model:[NSNull null],@"becomeFirstResponder":@0}];
}
@end
