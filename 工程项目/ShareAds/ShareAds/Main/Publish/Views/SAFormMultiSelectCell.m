//
//  SAFormMultiSelectCell.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/27.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAFormMultiSelectCell.h"
#import "SAFormMutiSelectCell.h"
#import "SAFormMultiAddImgCell.h"
#import "Province.h"
#import "City.h"
#import "District.h"
@interface SAFormMultiSelectCell() <UICollectionViewDelegate,UICollectionViewDataSource>
@end
static const CGFloat kTopViewHeight = 45;
static const CGFloat kItemHeight = 30;
static const CGFloat kMargin = 8;
NSInteger const SAFormMultiSelectCellMaxArea = 4;
@implementation SAFormMultiSelectCell {
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_layout;
    UIView *_topView;
    UIImageView *_leftArrowImgView;
    CGSize _itemSize;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _layout = [UICollectionViewFlowLayout new];
        _layout.minimumInteritemSpacing = kMargin;
        _layout.minimumLineSpacing = kMargin;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 0) collectionViewLayout:_layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SAFormMutiSelectCell class]) bundle:nil] forCellWithReuseIdentifier:@"cellid"];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SAFormMultiAddImgCell class]) bundle:nil] forCellWithReuseIdentifier:@"addcellid"];
        [self.contentView addSubview:_collectionView];
        _titleLabel = [UILabel new];
        _topView = [UIView new];
        _leftArrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left_arrow"]];
        [_topView addSubview:_leftArrowImgView];
        [_topView addSubview:_titleLabel];
        [self.contentView addSubview:_topView];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _itemSize = CGSizeMake(floor((self.contentView.bounds.size.width - 3 * kMargin)/2), kItemHeight);
    [self calculateFrame];
}
- (void)setModel:(SAFormViewModel *)model {
    [super setModel:model];
    _titleLabel.text = model.title;
    [self calculateFrame];
    [_collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *dataSource = self.model.commitObj;
    if (dataSource.count >= SAFormMultiSelectCellMaxArea) {
        return SAFormMultiSelectCellMaxArea;
    }
    else {
        return dataSource.count + 1;
    }
}
- (void)calculateFrame {
    _layout.itemSize = _itemSize;
    _topView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, kTopViewHeight);
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(8, (kTopViewHeight - _titleLabel.frame.size.height)/2, _titleLabel.bounds.size.width, _titleLabel.bounds.size.height);
    [_leftArrowImgView sizeToFit];
    _leftArrowImgView.frame = CGRectMake(self.contentView.bounds.size.width - _leftArrowImgView.bounds.size.width - 8, (kTopViewHeight - _leftArrowImgView.bounds.size.height)/2, _leftArrowImgView.bounds.size.width, _leftArrowImgView.bounds.size.height);
    NSArray *dataSource = self.model.commitObj;
    if (dataSource.count == 0) {
        [_collectionView setHidden:YES];
        _collectionView.frame = CGRectZero;
    }
    else {
        [_collectionView setHidden:NO];
        NSInteger line;
        if (dataSource.count >= SAFormMultiSelectCellMaxArea) {
            line = dataSource.count/2 + dataSource.count%2;
        }
        else {
            line = (dataSource.count+1)/2 + (dataSource.count+1)%2;
        }
        _collectionView.frame = CGRectMake(kMargin, CGRectGetMaxY(_topView.frame), self.contentView.bounds.size.width - 2 * kMargin, line* kItemHeight + (line - 1)*kMargin);
        NSLog(@"%@",NSStringFromCGRect(_collectionView.frame));
    }
}
+ (CGFloat)heightForModel:(SAFormViewModel *)model {
    NSArray *dataSource = model.commitObj;
    if (dataSource.count == 0) {
        return kTopViewHeight;
    }
    else {
        NSInteger line;
        if (dataSource.count >= SAFormMultiSelectCellMaxArea) {
            line = dataSource.count/2 + dataSource.count%2;
        }
        else {
            line = (dataSource.count+1)/2 + (dataSource.count+1)%2;
        }
        return kTopViewHeight + line* kItemHeight  + (line + 1)*kMargin;
    }
    
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *dataSource = self.model.commitObj;
    if (indexPath.row == dataSource.count) {
        SAFormMultiAddImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addcellid" forIndexPath:indexPath];
        return cell;
    }
    SAFormMutiSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    NSDictionary *dic = dataSource[indexPath.row];
    NSString *provinceCode = dic[@"provinceCode"];
    NSString *cityCod = dic[@"cityCode"];
    NSString *areaCode = dic[@"areaCode"];
    
    if (areaCode != nil && ![areaCode isEqualToString:@""]) {
        District *district = [District objectsWhere:@"areaId = %@",areaCode].firstObject;
        City *city = [City objectsWhere:@"cityId = %@",district.cityId].firstObject;
        Province *province = [Province objectsWhere:@"provId = %@",district.provId].firstObject;
        cell.titleLabel.text = [NSString stringWithFormat:@"%@%@%@",province.desc,city.desc,district.desc];
    }
    else if (cityCod != nil && ![cityCod isEqualToString:@""]) {
        City *city = [City objectsWhere:@"cityId = %@",cityCod].firstObject;
        Province *province = [Province objectsWhere:@"provId = %@",city.provId].firstObject;
        cell.titleLabel.text = [NSString stringWithFormat:@"%@%@",province.desc,city.desc];
    }
    else if (provinceCode != nil && ![provinceCode isEqualToString:@""]) {
        Province *province = [Province objectsWhere:@"provId = %@",provinceCode].firstObject;
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",province.desc];
    }
    __weak typeof(_collectionView) weakCollectionView = _collectionView;
    __weak typeof(self) weakSelf = self;
    cell.deleteBlock = ^{
        NSMutableArray *array = [NSMutableArray arrayWithArray:weakSelf.model.commitObj];
        [array removeObjectAtIndex:indexPath.row];
        weakSelf.model.commitObj = [array copy];
        [weakCollectionView reloadData];
        if (weakSelf.deleteBlock) {
            weakSelf.deleteBlock();
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *dataSource = self.model.commitObj;
    if (indexPath.row == dataSource.count) {
        if (self.addBlock) {
            self.addBlock();
        }
    }
}
@end
