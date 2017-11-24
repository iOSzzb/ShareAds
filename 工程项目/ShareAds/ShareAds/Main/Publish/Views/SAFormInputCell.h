//
//  SAFormInputCell.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/25.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAFormBaseCell.h"
@interface SAFormInputCell : SAFormBaseCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
