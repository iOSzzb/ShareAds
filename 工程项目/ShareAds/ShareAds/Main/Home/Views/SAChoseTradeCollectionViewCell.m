//
//  SAChoseTradeCollectionViewCell.m
//  ShareAds
//
//  Created by 张振波 on 2017/12/5.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAChoseTradeCollectionViewCell.h"
@interface SAChoseTradeCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation SAChoseTradeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.cornerRadius = 5;
}

@end
