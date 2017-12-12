//
//  SACalendarStyleLabel.m
//  ShareAds
//
//  Created by 张振波 on 2017/8/1.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SACalendarStyleLabel.h"

@implementation SACalendarStyleLabel
{
    NSArray *_labels;
    NSArray *_labelBackgroundViews;
    CGSize _bgSize;
    NSInteger _number;
}
static const CGFloat kMargin = 5;
- (instancetype)initWithText:(NSString *)text {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _text = [text copy];
        _number = text.length;
        _bgSize = CGSizeMake(15, 20);
        NSMutableArray *mutL = [NSMutableArray new];
        NSMutableArray *mutB = [NSMutableArray new];
        for (int i = 0; i < _number; i ++) {
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
            [mutL addObject:label];
            label.text = [NSString stringWithFormat:@"%c",[text characterAtIndex:i]];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bgSize.width, _bgSize.height)];
            view.backgroundColor = [UIColor whiteColor];
            [mutB addObject:view];
            [view addSubview:label];
            [self addSubview:view];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(view.mas_centerX);
                make.centerY.equalTo(view.mas_centerY);
            }];
        }
        _labels = [mutL copy];
        _labelBackgroundViews = [mutB copy];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _bgSize = CGSizeMake(15, 20);
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    for (int i = 0; i < _number; i ++) {
        UIView *bg = _labelBackgroundViews[i];
        bg.frame = CGRectMake(i * (kMargin + _bgSize.width), (self.bounds.size.height - _bgSize.height)/2, _bgSize.width, _bgSize.height);
    }
}
- (void)setText:(NSString *)text {
    _text = [text copy];
    [_labelBackgroundViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = obj;
        [view removeFromSuperview];
    }];
    _number = text.length;
    NSMutableArray *mutL = [NSMutableArray new];
    NSMutableArray *mutB = [NSMutableArray new];
    for (int i = 0; i < _number; i ++) {
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
        [mutL addObject:label];
        label.text = [NSString stringWithFormat:@"%c",[text characterAtIndex:i]];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bgSize.width, _bgSize.height)];
        view.backgroundColor = [UIColor whiteColor];
        [mutB addObject:view];
        [view addSubview:label];
        [self addSubview:view];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.centerY.equalTo(view.mas_centerY);
        }];
    }
    _labels = [mutL copy];
    _labelBackgroundViews = [mutB copy];
    [self setNeedsLayout];
    [self invalidateIntrinsicContentSize];
}
- (CGSize)intrinsicContentSize {
    return CGSizeMake((_bgSize.width + kMargin) * _text.length - kMargin, _bgSize.height);
}
@end
