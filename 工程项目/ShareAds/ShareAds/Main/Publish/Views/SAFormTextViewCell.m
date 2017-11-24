//
//  SAFormTextViewCell.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/26.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAFormTextViewCell.h"
@interface SAFormTextViewCell()<UITextViewDelegate>
@end
@implementation SAFormTextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _textView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(SAFormViewModel *)model {
    [super setModel:model];
    _titleLabel.text = model.title;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [[NSNotificationCenter defaultCenter] postNotificationName:SAFormViewModelFirstResponderNotification object:nil userInfo:@{@"responder":textView,@"model":self.model?self.model:[NSNull null],@"becomeFirstResponder":@1}];

}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [[NSNotificationCenter defaultCenter] postNotificationName:SAFormViewModelFirstResponderNotification object:nil userInfo:@{@"responder":textView,@"model":self.model?self.model:[NSNull null],@"becomeFirstResponder":@1}];
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.model.inputText = textView.text;
    self.model.commitObj = textView.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:SAFormViewModelFirstResponderNotification object:nil userInfo:@{@"firstResponder":textView,@"model":self.model?self.model:[NSNull null],@"becomeFirstResponder":@0}];
}
@end
