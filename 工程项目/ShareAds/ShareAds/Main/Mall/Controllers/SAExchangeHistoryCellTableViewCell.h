//
//  SAExchangeHistoryCellTableViewCell.h
//  ShareAds
//
//  Created by 张振波 on 2017/12/11.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAExchangeHistoryCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
