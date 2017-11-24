//
//  SASegmentControl.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/10.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SASegmentControl.h"
@interface SASegmentControl()
@property (nonatomic, strong) NSArray<UIButton *> *buttons;
@property (nonatomic, assign) CGFloat btnWidthSum;
@end
static const CGFloat leftAndRightMargin = 20;
@implementation SASegmentControl
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _selectedColor = [UIColor greenColor];
    _normalColor = [UIColor blackColor];
    _defaultIndex = 0;
    UIView *topLine = [UIView new];
    topLine.backgroundColor = LIGHT_GRAY_BACKGROUND_COLOR;
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@0.5);
    }];
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = LIGHT_GRAY_BACKGROUND_COLOR;
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@0.5);
    }];
}

- (void)setItems:(NSArray *)items {
    _items = [items copy];
    if (self.buttons) {
        [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
            [button removeFromSuperview];
        }];
    }
    [_items enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            self.btnWidthSum = 0;
        }
        UIFont *font = [UIFont systemFontOfSize:17];
        CGSize btnSize = [obj sizeWithAttributes:@{NSFontAttributeName:font}];;
        self.btnWidthSum += btnSize.width;
    }];
    NSMutableArray *buttonArray = [NSMutableArray new];
    [_items enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton new];
        btn.tag = idx;
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:self.selectedColor forState:UIControlStateSelected];
        [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIFont *font = [UIFont systemFontOfSize:17];
        btn.titleLabel.font = font;
        
        CGSize btnSize = [obj sizeWithAttributes:@{NSFontAttributeName:font}];
        CGFloat x;
        if (idx == 0) {
            x = leftAndRightMargin;
        }
        else if (idx == _items.count-1){
            x = self.bounds.size.width - btnSize.width - leftAndRightMargin;
        } else {
            if (self.btnWidthSum > 0) {
                x = (self.bounds.size.width - 2*leftAndRightMargin - self.btnWidthSum)/(self.items.count-1)+ CGRectGetMaxX(_buttons[idx - 1].frame);

            }
            else {
                x = (self.bounds.size.width - 2*leftAndRightMargin)/(self.items.count-1) * idx - btnSize.width/2;

            }
        }
        CGFloat y = (self.bounds.size.height-btnSize.height)/2;
        CGRect btnFrame = CGRectMake(x, y, btnSize.width, btnSize.height);
        btn.frame = btnFrame;
        [self addSubview:btn];
        [buttonArray addObject:btn];
        if (idx == _defaultIndex) {
            btn.selected = YES;
        }
    }];
    self.buttons = [buttonArray copy];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.buttons) {
        [_buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
            UIFont *font = [UIFont systemFontOfSize:17];
            btn.titleLabel.font = font;
            NSString *str = _items[idx];
            CGSize btnSize = [str sizeWithAttributes:@{NSFontAttributeName:font}];;
            CGFloat x;
            if (idx == 0) {
                x = leftAndRightMargin;
            }
            else if (idx == _items.count-1){
                x = self.bounds.size.width - btnSize.width - leftAndRightMargin;
            } else {
                if (self.btnWidthSum > 0) {
                    x = (self.bounds.size.width - 2*leftAndRightMargin - self.btnWidthSum)/(self.items.count-1) + CGRectGetMaxX(_buttons[idx - 1].frame);
                    
                }
                else {
                    x = (self.bounds.size.width - 2*leftAndRightMargin)/(self.items.count-1) * idx - btnSize.width/2 + 30;
                }
            }
            CGFloat y = (self.bounds.size.height-btnSize.height)/2;
            CGRect btnFrame = CGRectMake(x, y, btnSize.width, btnSize.height);
            btn.frame = btnFrame;
        }];

    }
}

- (void)buttonClicked:(UIButton *)btn {
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != btn) {
            obj.selected = NO;
        }
    }];
    btn.selected = YES;
    _currentIndex = btn.tag;
    if ([self.delegate respondsToSelector:@selector(segmentControl:didSelectAtIndex:)]) {
        [self.delegate segmentControl:self didSelectAtIndex:btn.tag];
    }
}
@end
