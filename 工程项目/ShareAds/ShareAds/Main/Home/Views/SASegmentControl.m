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
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *addBtn;
@end
static const CGFloat leftAndRightMargin = 20;
static const CGFloat interItemSpacing = 10;
@implementation SASegmentControl
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex < self.buttons.count) {
        _currentIndex = currentIndex;
        [self buttonClicked:self.buttons[_currentIndex]];
    }
}
- (void)initialize {
    _selectedColor = [UIColor redColor];
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
    _scrollView = [UIScrollView new];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    _addBtn = [UIButton new];
    [self addSubview:_addBtn];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(_addBtn.mas_height);
    }];
    _addBtn.backgroundColor = [UIColor whiteColor];
    _addBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [_addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
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
    NSMutableArray<UIButton *> *buttonArray = [NSMutableArray new];
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
//        if (idx == 0) {
//            x = leftAndRightMargin;
//        }
//        else if (idx == _items.count-1){
//            x = self.bounds.size.width - btnSize.width - leftAndRightMargin;
//        } else {
//            if (self.btnWidthSum > 0) {
//                x = (self.bounds.size.width - 2*leftAndRightMargin - self.btnWidthSum)/(self.items.count-1)+ CGRectGetMaxX(_buttons[idx - 1].frame);
//
//            }
//            else {
//                x = (self.bounds.size.width - 2*leftAndRightMargin)/(self.items.count-1) * idx - btnSize.width/2;
//
//            }
//        }
        CGFloat interSpacing = leftAndRightMargin;
        if (_btnWidthSum < self.bounds.size.width - 2 * leftAndRightMargin - (_items.count - 1) * leftAndRightMargin - _addBtn.bounds.size.width  && _items.count > 1) {
            interSpacing = (self.bounds.size.width - 2 * leftAndRightMargin - _btnWidthSum - _addBtn.bounds.size.width) / (_items.count - 1);
        } else {
            interSpacing = interItemSpacing;
        }
        if (idx == 0) {
            x = leftAndRightMargin;
        } else  {
            x = CGRectGetMaxX(buttonArray[idx - 1].frame) + interSpacing;
        }
        CGFloat y = (self.bounds.size.height-btnSize.height)/2;
        CGRect btnFrame = CGRectMake(x, y, btnSize.width, btnSize.height);
        btn.frame = btnFrame;
        [_scrollView addSubview:btn];
        [buttonArray addObject:btn];
        if (idx == _defaultIndex) {
            btn.selected = YES;
        }
    }];
    self.buttons = [buttonArray copy];
    CGFloat maxX = self.buttons.lastObject == nil ? self.bounds.size.width : CGRectGetMaxX(self.buttons.lastObject.frame);
    _scrollView.contentSize = CGSizeMake(maxX + self.addBtn.bounds.size.width, self.bounds.size.height);

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
//            if (idx == 0) {
//                x = leftAndRightMargin;
//            }
//            else if (idx == _items.count-1){
//                x = self.bounds.size.width - btnSize.width - leftAndRightMargin;
//            } else {
//                if (self.btnWidthSum > 0) {
//                    x = (self.bounds.size.width - 2*leftAndRightMargin - self.btnWidthSum)/(self.items.count-1) + CGRectGetMaxX(_buttons[idx - 1].frame);
//                    
//                }
//                else {
//                    x = (self.bounds.size.width - 2*leftAndRightMargin)/(self.items.count-1) * idx - btnSize.width/2 + 30;
//                }
//            }
            CGFloat interSpacing = leftAndRightMargin;
            if (_btnWidthSum < self.bounds.size.width - 2 * leftAndRightMargin - (_buttons.count - 1) * leftAndRightMargin  && _buttons.count > 1) {
                interSpacing = (self.bounds.size.width - 2 * leftAndRightMargin - _btnWidthSum - _addBtn.bounds.size.width) /( _buttons.count - 1);
            } else {
                interSpacing = interItemSpacing;
            }
            if (idx == 0) {
                x = leftAndRightMargin;
            } else  {
                x = CGRectGetMaxX(_buttons[idx - 1].frame) + interSpacing;
            }
            CGFloat y = (self.bounds.size.height-btnSize.height)/2;
            CGRect btnFrame = CGRectMake(x, y, btnSize.width, btnSize.height);
            btn.frame = btnFrame;
        }];
        CGFloat maxX = self.buttons.lastObject == nil ? self.bounds.size.width : CGRectGetMaxX(self.buttons.lastObject.frame);
        _scrollView.contentSize = CGSizeMake(maxX + self.addBtn.bounds.size.width, self.bounds.size.height);
    }
}

- (void)buttonClicked:(UIButton *)btn {
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != btn) {
            obj.selected = NO;
        }
    }];
    btn.selected = YES;
    [self scrollToCenterFor:btn];
    _currentIndex = btn.tag;
    if ([self.delegate respondsToSelector:@selector(segmentControl:didSelectAtIndex:)]) {
        [self.delegate segmentControl:self didSelectAtIndex:btn.tag];
    }
}

- (void)addBtnOnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(segmentControlAddBtnOnClick:)]) {
        [self.delegate segmentControlAddBtnOnClick:self];
    }
}

- (void)scrollToCenterFor:(UIButton *)button {
    CGFloat x = button.frame.origin.x - button.bounds.size.width / 2 - self.bounds.size.width / 2;
    if (x > 0) {
        CGPoint offset = CGPointMake(x, 0);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    
}
@end
