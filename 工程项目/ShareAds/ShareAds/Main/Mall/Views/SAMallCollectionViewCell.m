//
//  SAMallCollectionViewCell.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/11.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAMallCollectionViewCell.h"
static CGFloat kMargin = 8;
static CGFloat kMarginPrice = 8;
static CGFloat kMarginNumber = 8;
static UIFont *kCommodityNameFont = nil;
static UIFont *kPriceFont = nil;
static UIFont *kNumberFont = nil;

static CGFloat kImageAspectRadio = 3.0/4.0;
@implementation SAMallCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        _commodityNameLabel = [UILabel new];
        _commodityNameLabel.numberOfLines = 2;
        [self.contentView addSubview:_commodityNameLabel];
        kCommodityNameFont = [UIFont systemFontOfSize:15];
        kPriceFont = [UIFont systemFontOfSize:14];;
        kNumberFont = [UIFont systemFontOfSize:14];
        _commodityNameLabel.font = kCommodityNameFont;
        _priceLabel = [UILabel new];
        [self.contentView addSubview:_priceLabel];
        _priceLabel.font = kPriceFont;
        _numberLabel = [UILabel new];
        [self.contentView addSubview:_numberLabel];
        _numberLabel.font = kNumberFont;
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(3);
            make.right.equalTo(self.contentView.mas_right).offset(-3);
            make.top.equalTo(self.contentView.mas_top).offset(3);
            make.height.equalTo(self.imageView.mas_width).multipliedBy(kImageAspectRadio);
        }];
        [_commodityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageView.mas_bottom).offset(5);
            make.left.equalTo(self.contentView.mas_left).offset(3);
            make.right.equalTo(self.contentView.mas_right).offset(-3);
        }];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_commodityNameLabel.mas_bottom);
            make.left.equalTo(self.contentView.mas_left).offset(3);
            make.right.equalTo(self.contentView.mas_right).offset(-3);
        }];
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_priceLabel.mas_bottom);
            make.left.equalTo(self.contentView.mas_left).offset(3);
            make.right.equalTo(self.contentView.mas_right).offset(-3);
        }];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    _imageView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.width * kImageAspectRadio);
////    CGSize commodityNameSize = [_commodityNameLabel.text sizeWithAttributes:@{NSFontAttributeName:kCommodityNameFont}];
//    _commodityNameLabel.frame = CGRectMake(0, CGRectGetMaxY(_imageView.frame) + kMargin, self.contentView.bounds.size.width, 35);
////    _commodityNameLabel.textAlignment = NSTextAlignmentCenter;
////    CGSize priceSize = [_priceLabel.text sizeWithAttributes:@{NSFontAttributeName:kPriceFont}];
//    _priceLabel.frame = CGRectMake(0, CGRectGetMaxY(_commodityNameLabel.frame) + kMarginPrice, self.contentView.bounds.size.width, 15);
////    _priceLabel.textAlignment = NSTextAlignmentCenter;
//    CGSize numberSize = [_numberLabel.text sizeWithAttributes:@{NSFontAttributeName:kNumberFont}];
//    _numberLabel.frame = CGRectMake(0 , CGRectGetMaxY(_priceLabel.frame)+kMarginNumber, self.contentView.bounds.size.width, 15);
    
}
- (CGFloat)calculateCellHeightWithWidth:(CGFloat)width {
    CGFloat height = 0;
    height = width * kImageAspectRadio;
    height += kMargin;
    NSString *word = @"一行字";
    height += [word sizeWithAttributes:@{NSFontAttributeName:kCommodityNameFont}].height;
    height += kMarginPrice;
    height += [word sizeWithAttributes:@{NSFontAttributeName:kPriceFont}].height;
    height += kMarginNumber;
    height += [word sizeWithAttributes:@{NSFontAttributeName:kNumberFont}].height;
    return height;
}
@end
