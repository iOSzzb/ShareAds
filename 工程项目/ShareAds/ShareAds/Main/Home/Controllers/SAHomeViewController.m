//
//  SAHomeViewController.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/5.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAHomeViewController.h"
#import "SAAdsSearchResultViewController.h"
#import "SAAdsSearchController.h"
#import "SDCycleScrollView.h"
#import "SASegmentControl.h"
#import "SAAdsListCell.h"
#import "HomeBannerAds.h"
#import "CommonWebViewController.h"
#import "Advertisement.h"
#import "UIImageView+WebCache.h"
typedef NS_ENUM(NSInteger,CurrentSelectedCategory) {
    CurrentSelectedCategoryDefault = 0,//默认排序
    CurrentSelectedCategoryLeftAmount = 1,//剩余广告费
    CurrentSelectedCategorySpreadNum = 2,//传播量
    CurrentSelectedCategoryPrice = 3,//单价
    CurrentSelectedCategoryIndustry = 4//行业
};
@interface SAHomeViewController ()<UISearchControllerDelegate,SDCycleScrollViewDelegate,SASegmentControlDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableViewHeaderView;
@property (nonatomic, strong) SDCycleScrollView *adsBanner;
@property (nonatomic, strong) SASegmentControl *segmentControl;
@property (nonatomic, strong) NSArray<HomeBannerAds *> *bannerAds;
@property (nonatomic, strong) NSArray<Advertisement *> *defaultAds;//默认排序
@property (nonatomic, strong) NSArray<Advertisement *> *leftAnmoutAds;//剩余广告费
@property (nonatomic, strong) NSArray<Advertisement *> *spreadNumAds;//传播量
@property (nonatomic, strong) NSArray<Advertisement *> *priceAds;//单价
@property (nonatomic, strong) NSArray<Advertisement *> *industryAds;//行业
@property (nonatomic, strong) NSArray<Advertisement *> *currentArray;
@property (nonatomic, assign) CurrentSelectedCategory currentCategory;
@end
static NSString * const ADCellResuseID = @"ADCellResuseID";
@implementation SAHomeViewController
{
    NSInteger _pageSize;
    NSInteger _currentPage;
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:NetworkInterfaceLoginSuccessNotification object:nil];
    self.currentCategory = CurrentSelectedCategoryDefault;
    self.defaultAds = [NSArray new];
    self.leftAnmoutAds = [NSArray new];
    self.spreadNumAds = [NSArray new];
    self.priceAds = [NSArray new];
    self.industryAds = [NSArray new];
    self.currentArray = self.defaultAds;
    [self p_setupTableView];
    [self p_setupSearchController];
    [self p_setupBanner];
    [self p_setupSegmentControl];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setMinimumDismissTimeInterval:3];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tableViewHeaderView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, CGRectGetMaxY(_segmentControl.frame)+10);
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - private method
#pragma mark -- setup UI
- (void)p_setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    _tableView.tableHeaderView = _tableViewHeaderView;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SAAdsListCell class]) bundle:nil] forCellReuseIdentifier:ADCellResuseID];
    _tableView.rowHeight = 75;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
- (void)p_setupSearchController {
    self.searchController = [[SAAdsSearchController alloc] initWithSearchResultsController:[SAAdsSearchResultViewController new]];
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.definesPresentationContext = YES;
    [self.tableViewHeaderView addSubview:self.searchController.searchBar];
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    self.searchController.searchBar.placeholder = @"请输入商家或者商品名称";
}
- (void)p_setupBanner {
    self.adsBanner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,  CGRectGetMaxY(_searchController.searchBar.frame) + 15, self.view.bounds.size.width, 120) delegate:self placeholderImage:[UIImage new]];
    _adsBanner.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    [_tableViewHeaderView addSubview:_adsBanner];
}
- (void)p_setupSegmentControl {
    self.segmentControl = [[SASegmentControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_adsBanner.frame) + 15, self.view.bounds.size.width, 44)];
    _segmentControl.delegate = self;
    _segmentControl.items = @[@"默认",@"传播量",@"余额",@"单价"];
    [_tableViewHeaderView addSubview:_segmentControl];
    
}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击了第%ld张图片",(long)index);
    CommonWebViewController *commonWeb = [CommonWebViewController new];
    commonWeb.urlStr = _bannerAds[index].url;
    commonWeb.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commonWeb animated:YES];
}
#pragma mark - SASegmentControlDelegate
- (void)segmentControl:(SASegmentControl *)segmentControl didSelectAtIndex:(NSInteger)index {
    NSLog(@"点击了%ld segementControl",(long)index);
    self.currentCategory = index;
    switch (self.currentCategory) {
        case CurrentSelectedCategoryDefault:
            _currentArray = _defaultAds;
            break;
        case CurrentSelectedCategoryLeftAmount:
            _currentArray =  _leftAnmoutAds;
            break;
        case CurrentSelectedCategorySpreadNum:
            _currentArray =  _spreadNumAds;
            break;
        case CurrentSelectedCategoryPrice:
            _currentArray =  _priceAds;
            break;
        case CurrentSelectedCategoryIndustry:
            _currentArray = _industryAds;
            break;
        default:
            _currentArray = _defaultAds;
            break;
    }
    if (_currentArray.count == 0) {
        [self fechAds];
    }
    else {
        [_tableView reloadData];
    }
}
#pragma mark - UITableDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _currentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAAdsListCell *cell = [tableView dequeueReusableCellWithIdentifier:ADCellResuseID forIndexPath:indexPath];
    Advertisement *ads;
    ads = _currentArray[indexPath.row];
    cell.titleLabel.text = ads.title;
//    NSDecimalNumber *price = [[NSDecimalNumber alloc ] initWithFloat:ads.price];
//    NSDecimalNumber *amount = [[NSDecimalNumber alloc ] initWithFloat:ads.remainAmount];
    cell.priceLabel.text = [NSString stringWithFormat:@"单价%@元",[ads.price stringValue]] ;
    cell.amountLabel.text = [NSString stringWithFormat:@"总价%@元",[ads.amount stringValue]];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:ads.iconUrl]];
    cell.actionBlock = ^(SAAdsListCellActionType type) {
        if (type == SAAdsListCellActionTypeShare) {
            NSLog(@"点击了share");
        }
        if (type == SAAdsListCellActionTypeFavorate) {
            NSLog(@"点击了收藏");
            [NetworkInterface favoriteAdsWithId:ads.id success:^(NSDictionary *response) {
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            } failure:^(NSString *message, NSInteger errorCode) {
                [SVProgressHUD showSuccessWithStatus:@"收藏失败"];
            }];
        }
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    Advertisement *ads = _currentArray[indexPath.row];
    CommonWebViewController *commonWeb = [CommonWebViewController new];
    commonWeb.urlStr = ads.url;
    commonWeb.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commonWeb animated:YES];
}
#pragma mark - Obverser
- (void)loginSuccess {
    [self fechBannerAds];
    [self fechAds];
}

#pragma mark - network
- (void)fechBannerAds {
    [NetworkInterface getMainPageAds:^(NSArray<HomeBannerAds *> *ads) {
        self.bannerAds = ads;
        NSMutableArray *mut = [NSMutableArray new];
        [_bannerAds enumerateObjectsUsingBlock:^(HomeBannerAds * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mut addObject:obj.picUrl];
        }];
        _adsBanner.imageURLStringsGroup = [mut copy];;
    } failure:^(NSString *message, NSInteger errorCode) {
        
    }];
}
- (void)fechAds {
    NSInteger index = 1;
    NSString *type = @"01";
    switch (self.currentCategory) {
        case CurrentSelectedCategoryDefault:
            type = @"01";
            break;
        case CurrentSelectedCategoryLeftAmount:
            type = @"02";
            break;
        case CurrentSelectedCategorySpreadNum:
            type = @"03";
            break;
        case CurrentSelectedCategoryPrice:
            type = @"04";
            break;
        case CurrentSelectedCategoryIndustry:
            type = @"05";
            break;
        default:
            type = @"01";
            break;
    }

    if (self.currentArray != nil && self.currentArray.count != 0 && _pageSize != 0) {
        index = self.currentArray.count / _pageSize;
        _currentPage = index;
    }
    CurrentSelectedCategory categoryWhenFetch = _currentCategory;
    [NetworkInterface getAdsWithIndex:index type:type hangye:@"" success:^(NSArray<Advertisement *> *list, NSInteger pageSize) {
        if (self.currentArray.count == 0 || self.currentArray == nil) {
            self.currentArray = list;
            if (self.currentCategory == categoryWhenFetch) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
            }
        }
        else {
            NSMutableArray *mut = [NSMutableArray arrayWithArray:self.currentArray];
            [mut addObjectsFromArray:list];
            NSMutableArray *indexpaths = [NSMutableArray new];
            for (NSInteger i = self.currentArray.count; i < self.currentArray.count + list.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexpaths addObject:indexPath];
            }
            self.currentArray = [mut copy];
            if (self.currentCategory == categoryWhenFetch) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView beginUpdates];
                    [_tableView insertRowsAtIndexPaths:[indexpaths copy] withRowAnimation:UITableViewRowAnimationNone];
                    [_tableView endUpdates];
                });
            }
            
        }
        switch (self.currentCategory) {
            case CurrentSelectedCategoryDefault:
                self.defaultAds = self.currentArray;
                break;
            case CurrentSelectedCategoryLeftAmount:
                self.leftAnmoutAds = self.currentArray;
                break;
            case CurrentSelectedCategorySpreadNum:
                self.spreadNumAds = self.currentArray;
                break;
            case CurrentSelectedCategoryPrice:
                self.priceAds = self.currentArray;
                break;
            case CurrentSelectedCategoryIndustry:
                self.industryAds = self.currentArray;
                break;
            default:
                break;
        }
        
    } failure:^(NSString *message, NSInteger errorCode) {
        
    }];
}

@end
