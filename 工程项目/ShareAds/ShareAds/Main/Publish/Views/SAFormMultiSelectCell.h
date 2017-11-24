//
//  SAFormMultiSelectCell.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/27.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAFormBaseCell.h"
extern  NSInteger const SAFormMultiSelectCellMaxArea;
@interface SAFormMultiSelectCell : SAFormBaseCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) void(^deleteBlock)(void);
@property (nonatomic, copy) void(^addBlock)(void);
+ (CGFloat)heightForModel:(SAFormViewModel *)model;
@end
