//
//  SAComodityMenuBar.m
//  ShareAds
//
//  Created by 张振波 on 2017/12/10.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAComodityMenuBar.h"
#import "SATitleOnRightButton.h"
@interface SAComodityMenuBar()
@property (nonatomic,strong) NSArray<NSString *> *titles;
@property (nonatomic,strong) NSArray<SATitleOnRightButton *> *buttons;
@property (nonatomic, strong) NSArray <UIView *> *seperators;
@end
@implementation SAComodityMenuBar
- (instancetype)initWithTitles:(NSArray<NSString *> *)titles {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _titles = titles;
        NSMutableArray *buttonsMut = [NSMutableArray new];
        NSMutableArray *seperatorMut = [NSMutableArray new];
        for (int i = 0 ; i < _titles.count; i++) {
            NSString *title = _titles[i];
            SATitleOnRightButton *button = [SATitleOnRightButton new];
            [button setTitle:title forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
            [button setImage:[UIImage imageNamed:@"arrow_down_white"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 400 + i;
            if (i < _titles.count - 1) {
                UIView *seperator = [UIView new];
                seperator.backgroundColor = [UIColor whiteColor];
                [self addSubview:seperator];
                [seperatorMut addObject:seperator];
            }
            [self addSubview:button];
            [buttonsMut addObject:button];
        }
        _buttons = [buttonsMut copy];
        _seperators = [seperatorMut copy];
        self.backgroundColor = APP_TIN_COLOR;
        
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (_buttons.count > 0) {
        CGFloat btnW = self.bounds.size.width / _buttons.count;
        for (int i = 0; i < _buttons.count; i++ ) {
            SATitleOnRightButton *button = _buttons[i];
            button.frame = CGRectMake(i * btnW, 0, btnW, self.bounds.size.height);
            if (i < _seperators.count) {
                UIView *seperator = _seperators[i];
                seperator.frame = CGRectMake((i + 1) * btnW - 1, 3 , 2, self.bounds.size.height - 3 * 2);
            }
        }
        
    }
    
}
- (void)buttonClicked:(SATitleOnRightButton *)button {
    if ([self.delegate respondsToSelector:@selector(menuBar:didSelectedAtIndex:)]) {
        [self.delegate menuBar:self didSelectedAtIndex:button.tag - 400];
    }
}

@end
