//
//  SAFormSwitchCell.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/25.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAFormBaseCell.h"
@interface SAFormSwitchCell : SAFormBaseCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@end
