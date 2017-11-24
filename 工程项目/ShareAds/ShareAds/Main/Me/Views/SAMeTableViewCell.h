//
//  SAMeTableViewCell.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/14.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAMeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;

@end
