//
//  SAMyMoneyView.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/13.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAMyMoneyView.h"

@implementation SAMyMoneyView {
//    UIImageView *_leftArrow;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:18];
        _textLabel.textColor = [UIColor blackColor];
        [self addSubview:_textLabel];
        _warningLabel = [UILabel new];
        _warningLabel.font = [UIFont systemFontOfSize:10];
        _warningLabel.textColor = [UIColor redColor];
        [self addSubview:_warningLabel];
        _valueLabel = [UILabel new];
        _valueLabel.font = [UIFont systemFontOfSize:18];
        _valueLabel.textColor = [UIColor blackColor];
        [self addSubview:_valueLabel];
        _leftArrow = [UIImageView new];
        _leftArrow.image = [UIImage imageNamed:@"left_arrow"];
        [self addSubview:_leftArrow];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize textLabelSize = [_textLabel.text sizeWithAttributes:@{NSFontAttributeName:_textLabel.font}];
    _textLabel.frame = CGRectMake(10, (self.bounds.size.height - textLabelSize.height)/2, textLabelSize.width, textLabelSize.height);
    CGSize warningLabelSize = [_warningLabel.text sizeWithAttributes:@{NSFontAttributeName:_warningLabel.font}];
    _warningLabel.frame = CGRectMake(CGRectGetMaxX(_textLabel.frame) + 10, (self.bounds.size.height - warningLabelSize.height)/2, warningLabelSize.width, warningLabelSize.height);
    
    [_leftArrow sizeToFit];
    CGSize arrowSize = _leftArrow.bounds.size;
    CGRect arrowFrame = CGRectMake(self.bounds.size.width - arrowSize.width - 10, (self.bounds.size.height - arrowSize.height)/2, arrowSize.width, arrowSize.height);
    _leftArrow.frame = arrowFrame;
    
    CGSize valueLabelSize = [_valueLabel.text sizeWithAttributes:@{NSFontAttributeName:_valueLabel.font}];
    _valueLabel.frame = CGRectMake(_leftArrow.frame.origin.x - 10 - valueLabelSize.width , (self.bounds.size.height - valueLabelSize.height)/2, valueLabelSize.width, valueLabelSize.height);
}
@end
