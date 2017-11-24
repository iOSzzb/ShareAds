//
//  SAFormMultiImgCell.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/26.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAFormBaseCell.h"
@interface SAFormMultiImgCell : SAFormBaseCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) UICollectionView *collectionView;

@end
