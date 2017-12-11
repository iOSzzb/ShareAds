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
#import "SAComodityMenuBar.h"
#import "SADropList.h"
#import "MJRefresh.h"
#import "SAExchangHistoryViewController.h"
@interface SAMallViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SAComodityMenuBarDelegate,SADropListDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<Commodity *> *commdities;
@property (nonatomic, strong) SAComodityMenuBar *menuBar;
@property (nonatomic, strong) UIView *statusBarBg;
@property (nonatomic, strong) SADropList *dropList;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSString *currentCommdyType;
@property (nonatomic, strong) NSString *currentSortType;
@end
static const CGFloat CellMargin = 5;
static NSString * const kMallCellReuseID = @"kMallCellReuseID";
@implementation SAMallViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentSortType = @"";
    self.currentCommdyType = @"";
    [NetworkInterface syncCommodityTypeSuccess:nil failure:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"兑换商城";
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.statusBarBg = [UIView new];
    _statusBarBg.backgroundColor = APP_TIN_COLOR;
    [self.view addSubview:_statusBarBg];
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    [_statusBarBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@(statusHeight));
    }];
    [self p_setupMenuBar];
    [self p_setupCollectionView];
    [self getCommdities];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = CellMargin;
    CGFloat cellWidth = (self.view.bounds.size.width - 3 * CellMargin)/2;
//    SAMallCollectionViewCell *cell = [SAMallCollectionViewCell new];
    CGFloat cellHeight = 36 + 17 + 17 + 5 + 3 + (cellWidth - 6) * 3.0/4.0;
    layout.itemSize = CGSizeMake(cellWidth, cellHeight);
}
#pragma mark - Private Method
- (void)p_setupMenuBar {
    SAComodityMenuBar *menuBar = [[SAComodityMenuBar alloc] initWithTitles:@[@"全部分类",@"智能筛选",@"兑换记录"]];
    self.menuBar = menuBar;
    _menuBar.delegate = self;
    [self.view addSubview:_menuBar];
    [_menuBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_statusBarBg.mas_bottom);
        make.height.equalTo(@40);
    }];
}
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
        make.top.equalTo(self.menuBar.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-self.tabBarController.tabBar.bounds.size.height);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    __weak typeof(self) weakSelf = self;
    _collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getCommdities];
    }] ;
}
#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _commdities.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Commodity *commodity = _commdities[indexPath.row];
    SAMallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMallCellReuseID forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:commodity.image]];
//    cell.commodityNameLabel.text = commodity.desc;
    
    NSString *titleWithBrackets = [NSString stringWithFormat:@"【%@】",commodity.typeDesc];
    NSString *title = [NSString stringWithFormat:@"%@%@",titleWithBrackets,commodity.desc];
    NSMutableAttributedString *attrbutedTitle = [[NSMutableAttributedString alloc] initWithString:title];
    
    NSRange titleRange = [title rangeOfString:titleWithBrackets];
    [attrbutedTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor redColor]} range:titleRange];
    NSRange contentRange = [title rangeOfString:commodity.desc];
    [attrbutedTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor blackColor]} range:contentRange];
    cell.commodityNameLabel.attributedText = attrbutedTitle;
    
    
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
- (void)getCommdities {
//    [NetworkInterface getCommodityListWithIndex:index success:^(NSArray<Commodity *> *list, NSInteger pageSize) {
//        NSMutableArray *mut = [NSMutableArray arrayWithArray:_commdities];
//        [mut addObjectsFromArray:list];
//        NSMutableArray *indexpaths = [NSMutableArray new];
//        for (NSInteger i = _commdities.count; i < mut.count; i ++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//            [indexpaths addObject:indexPath];
//        }
//        self.commdities = [mut copy];
//        [_collectionView insertItemsAtIndexPaths:indexpaths];
//    } failure:^(NSString *message, NSInteger errorCode) {
//        
//    }];
    if (self.commdities.count == 0) {
        self.currentPage = 0;
    }
    NSString *captureType = self.currentCommdyType;
    NSString *captureSortType = self.currentSortType;
    self.currentPage += 1;
    [NetworkInterface getCommodityListWithIndex:self.currentPage type:self.currentCommdyType keywords:@"" sortType:self.currentSortType success:^(NSArray<Commodity *> *list, NSInteger pageSize) {
        [_collectionView.mj_footer endRefreshing];
        if ([captureType isEqualToString:self.currentCommdyType] && [captureSortType isEqualToString:self.currentSortType]) {
            NSMutableArray *mut = [NSMutableArray arrayWithArray:_commdities];
            [mut addObjectsFromArray:list];
            NSMutableArray *indexpaths = [NSMutableArray new];
            for (NSInteger i = _commdities.count; i < mut.count; i ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                [indexpaths addObject:indexPath];
            }
            self.commdities = [mut copy];
            [_collectionView insertItemsAtIndexPaths:indexpaths];
        }
    } failure:^(NSString *message, NSInteger errorCode) {
        if (self.currentPage > 0) {
            self.currentPage -= 1;
        }
        [_collectionView.mj_footer endRefreshing];
    }];
}
- (void)menuBar:(SAComodityMenuBar *)bar didSelectedAtIndex:(NSUInteger)index {
    [_dropList removeFromSuperview];
    if (index == 2) {
        SAExchangHistoryViewController *history = [SAExchangHistoryViewController new];
        history.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:history animated:YES];
    } else {
        if (self.dropList == nil) {
            self.dropList = [SADropList new];
            _dropList.frame = CGRectMake(0, CGRectGetMaxY(self.menuBar.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.menuBar.frame));
            _dropList.delegate = self;
        }
        [self.view addSubview:_dropList];
        if (index == 0) {
            _dropList.sourceType = SADropListSourceTypeCommidy;
        }
        if (index == 1) {
            _dropList.sourceType = SADropListSourceTypeSort;
        }
    }
    
    
}
- (void)dropList:(SADropList *)list didSelectAtIndex:(NSUInteger)index result:(NSString *)result {
    NSLog(@"%@",result);
    if (list.sourceType == SADropListSourceTypeCommidy) {
        if (![self.currentCommdyType isEqualToString:result]) {
            self.commdities = [NSArray new];
            [self.collectionView reloadData];
            self.currentCommdyType = result;
            [self getCommdities];
        }
    }
    if (list.sourceType == SADropListSourceTypeSort) {
        if (![self.currentSortType isEqualToString:result]) {
            self.currentSortType = result;
            self.commdities = [NSArray new];
            [self.collectionView reloadData];
            [self getCommdities];
        }
        
    }
    
    [list removeFromSuperview];
}
@end
