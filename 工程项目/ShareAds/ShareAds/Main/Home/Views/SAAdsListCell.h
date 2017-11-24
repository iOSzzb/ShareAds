//
//  SAAdsListCell.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/11.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,SAAdsListCellActionType) {
    SAAdsListCellActionTypeShare,
    SAAdsListCellActionTypeFavorate
};
typedef void(^SAAdsListCellActionBlock)(SAAdsListCellActionType actionType);
@interface SAAdsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, copy) SAAdsListCellActionBlock actionBlock;
@end
