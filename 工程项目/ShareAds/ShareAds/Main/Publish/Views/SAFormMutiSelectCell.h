//
//  SAFormMutiSelectCell.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/27.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAFormMutiSelectCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic,copy) void(^deleteBlock)(void);
@end
