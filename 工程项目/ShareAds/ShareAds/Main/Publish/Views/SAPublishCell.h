//
//  SAPublishCell.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/12.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,PublishCellOptType)  {
    PublishCellOptTypeLeft,
    PublishCellOptTypeRight
};
typedef void(^PublishCellBtnClickedBlock)(PublishCellOptType optType);
@interface SAPublishCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *adsImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (nonatomic, copy) PublishCellBtnClickedBlock actionBlock;
@end
