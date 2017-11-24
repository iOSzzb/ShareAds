//
//  SAMallCollectionViewCell.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/11.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAMallCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *commodityNameLabel;
@property (nonatomic, strong, readonly) UILabel *priceLabel;
@property (nonatomic, strong, readonly) UILabel *numberLabel;
- (CGFloat)calculateCellHeightWithWidth:(CGFloat)width;
@end
