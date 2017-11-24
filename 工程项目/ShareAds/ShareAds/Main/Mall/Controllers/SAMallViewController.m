//
//  SAMallViewController.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/5.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAMallViewController.h"
#import "SAMallCollectionViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Commodity.h"
#import "SACommdityDetailController.h"
@interface SAMallViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<Commodity *> *commdities;
@end
static const CGFloat CellMargin = 8;
static NSString * const kMallCellReuseID = @"kMallCellReuseID";
@implementation SAMallViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"兑换商城";
    [self p_setupCollectionView];
    [self getCommditiesWithIndex:1];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = CellMargin;
    CGFloat cellWidth = (self.view.bounds.size.width - 3 * CellMargin)/2;
    SAMallCollectionViewCell *cell = [SAMallCollectionViewCell new];
    CGFloat cellHeight = [cell calculateCellHeightWithWidth:cellWidth];
    layout.itemSize = CGSizeMake(cellWidth, cellHeight);
}
#pragma mark - Private Method
- (void)p_setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(ceil(self.view.bounds.size.width - 3 * CellMargin)/2, 200);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.contentInset = UIEdgeInsetsMake(CellMargin, CellMargin, 0, CellMargin);
    [_collectionView registerClass:[SAMallCollectionViewCell class] forCellWithReuseIdentifier:kMallCellReuseID];
    _collectionView.backgroundColor = LIGHT_GRAY_BACKGROUND_COLOR;
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}
#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _commdities.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Commodity *commodity = _commdities[indexPath.row];
    SAMallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMallCellReuseID forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:commodity.image]];
    cell.commodityNameLabel.text = commodity.desc;
    NSString *price = [NSString stringWithFormat:@"%.1f",commodity.price];
    NSString *priceStr = [NSString stringWithFormat:@"价格：%@",price];
    
    NSMutableAttributedString *attrPrice = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrPrice addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[priceStr rangeOfString:price]];
    cell.priceLabel.attributedText = attrPrice;
    cell.numberLabel.text = [NSString stringWithFormat:@"数量：%ld",(long)commodity.currNumber];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Commodity *commodity = _commdities[indexPath.row];
    SACommdityDetailController *vc = [SACommdityDetailController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.commdity = commodity;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)getCommditiesWithIndex:(NSInteger )index {
    [NetworkInterface getCommodityListWithIndex:index success:^(NSArray<Commodity *> *list, NSInteger pageSize) {
        NSMutableArray *mut = [NSMutableArray arrayWithArray:_commdities];
        [mut addObjectsFromArray:list];
        NSMutableArray *indexpaths = [NSMutableArray new];
        for (NSInteger i = _commdities.count; i < mut.count; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [indexpaths addObject:indexPath];
        }
        self.commdities = [mut copy];
        [_collectionView insertItemsAtIndexPaths:indexpaths];
    } failure:^(NSString *message, NSInteger errorCode) {
        
    }];
}
@end
