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
#import <Realm/Realm.h>
#import "Trade.h"
#import "AppDelegate.h"
#import "MyFavoriteTrade.h"
#import "MJRefresh.h"
#import "SAChoseTradeViewController.h"
#import "AdsWebViewController.h"
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
//@property (nonatomic, assign) CurrentSelectedCategory currentCategory;
@property (nonatomic, copy) NSString *currentHangyeId;
@property (nonatomic, strong) RLMNotificationToken *notiToken;
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
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:NetworkInterfaceLoginSuccessNotification object:nil];
//    self.currentCategory = CurrentSelectedCategoryDefault;
    self.defaultAds = [NSArray new];
    self.leftAnmoutAds = [NSArray new];
    self.spreadNumAds = [NSArray new];
    self.priceAds = [NSArray new];
    self.industryAds = [NSArray new];
    self.currentArray = self.defaultAds;
    [self p_setupTableView];
//    [self p_setupSearchController];
    [self p_setupBanner];
    [self p_setupSegmentControl];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setMinimumDismissTimeInterval:3];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:AppDelegateSysSuccessNotification object:nil];
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
    [self.notiToken invalidate];
}
#pragma mark - private method
#pragma mark -- setup UI
- (void)p_setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    _tableView.tableHeaderView = _tableViewHeaderView;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SAAdsListCell class]) bundle:nil] forCellReuseIdentifier:ADCellResuseID];
    _tableView.rowHeight = 105;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    __weak typeof(self) weakSelf = self;
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        NSString *hangye = @"";
        if (weakSelf.currentHangyeId == nil) {
            hangye = @"";
        } else {
            hangye = weakSelf.currentHangyeId;
        }
        [weakSelf fechAdsWidthType:@"01" hangye:hangye];
    }] ;
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
    self.adsBanner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.width * 318 / 732) delegate:self placeholderImage:[UIImage new]];
    _adsBanner.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    [_tableViewHeaderView addSubview:_adsBanner];
}
- (void)p_setupSegmentControl {
    self.segmentControl = [[SASegmentControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_adsBanner.frame) + 15, self.view.bounds.size.width, 44)];
    _segmentControl.delegate = self;
//    _segmentControl.items = @[@"默认",@"传播量",@"余额",@"单价"];
    
    
//    self.notiToken = [[MyFavoriteTrade allObjects] addNotificationBlock:^(RLMResults<MyFavoriteTrade *> * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
//        NSMutableArray *items = [NSMutableArray new];
//        for (int i = 0; i < results.count; i++ ) {
//            
//        }
//        weakSelf.segmentControl.items =
//    }];
    [_tableViewHeaderView addSubview:_segmentControl];
}
//- (void)viewDidAppear:(BOOL)animated {
////    __weak typeof(self) weakSelf = self;
////    MyFavoriteTrade *my = [[MyFavoriteTrade allObjects] objectsWhere:@"userId = %@",[SAUser shareUser].userId].firstObject;
////    if (my != nil) {
////        self.notiToken = [my.trades addNotificationBlock:^(RLMArray<Trade *> * _Nullable array, RLMCollectionChange * _Nullable changes, NSError * _Nullable error) {
////            NSMutableArray *items = [NSMutableArray new];
////            for (int i = 0; i < array.count; i++ ) {
////                [items addObject:array[i].desc];
////            }
////            [items insertObject:@"推荐" atIndex:0];
////            weakSelf.segmentControl.items = [items copy];
////        }];
////        NSMutableArray *items = [NSMutableArray new];
////        for (int i = 0; i < my.trades.count; i++ ) {
////            [items addObject:my.trades[i].desc];
////        }
////        [items insertObject:@"推荐" atIndex:0];
////        self.segmentControl.items = [items copy];
////    }
//}
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
    if (index == 0) {
        if (self.currentHangyeId == nil && self.currentArray.count > 0) {
            return;
        }
        self.currentArray = [NSArray new];
        [self.tableView reloadData];
        self.currentHangyeId = nil;
        [self fechAdsWidthType:@"01" hangye:@""];
    } else {
        MyFavoriteTrade *mytrades = [MyFavoriteTrade allObjects].firstObject;
        if (mytrades != nil && mytrades.trades.count > index - 1) {
            Trade *trade = [mytrades.trades objectAtIndex:index -1];
            if (![self.currentHangyeId isEqualToString:trade.id]) {
                self.currentArray = [NSArray new];
                [self.tableView reloadData];
                self.currentHangyeId = trade.id;
                [self fechAdsWidthType:@"01" hangye:trade.id];
            }
            
        }
    }
//    self.currentCategory = index;
//    switch (self.currentCategory) {
//        case CurrentSelectedCategoryDefault:
//            _currentArray = _defaultAds;
//            break;
//        case CurrentSelectedCategoryLeftAmount:
//            _currentArray =  _leftAnmoutAds;
//            break;
//        case CurrentSelectedCategorySpreadNum:
//            _currentArray =  _spreadNumAds;
//            break;
//        case CurrentSelectedCategoryPrice:
//            _currentArray =  _priceAds;
//            break;
//        case CurrentSelectedCategoryIndustry:
//            _currentArray = _industryAds;
//            break;
//        default:
//            _currentArray = _defaultAds;
//            break;
//    }
//    if (_currentArray.count == 0) {
//        [self fechAds];
//    }
//    else {
//        [_tableView reloadData];
//    }
}

- (void)segmentControlAddBtnOnClick:(SASegmentControl *)segmentControl {
    SAChoseTradeViewController *choseVC = [[SAChoseTradeViewController alloc] init];
    [self presentViewController:choseVC animated:YES completion:nil];
}
#pragma mark - UITableDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _currentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAAdsListCell *cell = [tableView dequeueReusableCellWithIdentifier:ADCellResuseID forIndexPath:indexPath];
    Advertisement *ads;
    ads = _currentArray[indexPath.row];
//    cell.titleLabel.text = ads.title;
    NSString *titleWithBrackets = [NSString stringWithFormat:@"【%@】",ads.title];
    NSString *title = [NSString stringWithFormat:@"%@%@",titleWithBrackets,ads.content];
    NSMutableAttributedString *attrbutedTitle = [[NSMutableAttributedString alloc] initWithString:title];
    
    NSRange titleRange = [title rangeOfString:titleWithBrackets];
    [attrbutedTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor redColor]} range:titleRange];
    NSRange contentRange = [title rangeOfString:ads.content];
    [attrbutedTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor blackColor]} range:contentRange];
    cell.titleLabel.attributedText = attrbutedTitle;
//    NSDecimalNumber *price = [[NSDecimalNumber alloc ] initWithFloat:ads.price];
//    NSDecimalNumber *amount = [[NSDecimalNumber alloc ] initWithFloat:ads.remainAmount];
    cell.priceLabel.text = [NSString stringWithFormat:@"单价%0.2f元",[ads.price floatValue]] ;
    cell.amountLabel.text = [NSString stringWithFormat:@"剩余%0.2f元",[ads.remainAmount floatValue]];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:ads.iconUrl]];
    cell.actionBlock = ^(SAAdsListCellActionType type) {
        if (type == SAAdsListCellActionTypeShare) {
            NSLog(@"点击了share");
            AdsWebViewController *webView = [AdsWebViewController new];
            webView.urlStr = ads.url;
            webView.hidesBottomBarWhenPushed = YES;
            webView.shareChannels = ads.shareChannelArray;
            webView.showShareBtnWhenViewAppear = YES;
            webView.ads = ads;
            [self.navigationController pushViewController:webView animated:YES];
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
    AdsWebViewController *webView = [AdsWebViewController new];
    webView.urlStr = ads.url;
    webView.hidesBottomBarWhenPushed = YES;
    webView.shareChannels = ads.shareChannelArray;
    webView.ads = ads;
    [self.navigationController pushViewController:webView animated:YES];
}
#pragma mark - Obverser
- (void)loginSuccess {
    [self fechBannerAds];
    [self fechAdsWidthType:@"01" hangye:@""];
    RLMRealm *realm = [RLMRealm defaultRealm];
    MyFavoriteTrade *favo = [MyFavoriteTrade objectsWhere:@"userId = %@",[SAUser shareUser].userId].firstObject;
    if (favo == nil) {
        MyFavoriteTrade *myTades = [[MyFavoriteTrade alloc] init];
        myTades.userId = [SAUser shareUser].userId;
        RLMResults *all = [Trade allObjects];
        for (int i = 0; i < 4; i ++ ) {
            if (i < all.count) {
                Trade *trade = [all objectAtIndex:i];
                [myTades.trades addObject:trade];
            }
        }
        [realm beginWriteTransaction];
        [MyFavoriteTrade createInRealm:realm withValue:myTades];
        [realm commitWriteTransaction];
        favo = [MyFavoriteTrade objectsWhere:@"userId = %@",[SAUser shareUser].userId].firstObject;
        __weak typeof(self) weakSelf = self;
        self.notiToken = [favo.trades addNotificationBlock:^(RLMArray<Trade *> * _Nullable array, RLMCollectionChange * _Nullable changes, NSError * _Nullable error) {
            NSInteger selectedIndex = -1;
            NSMutableArray *items = [NSMutableArray new];
            for (int i = 0; i < array.count; i++ ) {
                [items addObject:array[i].desc];
                if ([array[i].id isEqualToString:weakSelf.currentHangyeId]) {
                    selectedIndex = i;
                }
            }
            [items insertObject:@"推荐" atIndex:0];
            weakSelf.segmentControl.items = [items copy];
            weakSelf.segmentControl.currentIndex = selectedIndex + 1;
        }];

    } else {
//        NSMutableArray *items = [NSMutableArray new];
//        for (int i = 0; i < favo.trades.count; i++ ) {
//            [items addObject:favo.trades[i].desc];
//        }
//        [items insertObject:@"推荐" atIndex:0];
//        self.segmentControl.items = [items copy];
        __weak typeof(self) weakSelf = self;
        self.notiToken = [favo.trades addNotificationBlock:^(RLMArray<Trade *> * _Nullable array, RLMCollectionChange * _Nullable changes, NSError * _Nullable error) {
            NSMutableArray *items = [NSMutableArray new];
            NSInteger selectedIndex = -1;
            for (int i = 0; i < array.count; i++ ) {
                [items addObject:array[i].desc];
                if ([array[i].id isEqualToString:weakSelf.currentHangyeId]) {
                    selectedIndex = i;
                }
            }
            [items insertObject:@"推荐" atIndex:0];
            weakSelf.segmentControl.items = [items copy];
            weakSelf.segmentControl.currentIndex = selectedIndex + 1;
        }];
    }
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
- (void)fechAdsWidthType:(NSString *)type hangye:(NSString *)hangye {
//    NSInteger index = 1;
//    NSString *type = @"01";
//    switch (self.currentCategory) {
//        case CurrentSelectedCategoryDefault:
//            type = @"01";
//            break;
//        case CurrentSelectedCategoryLeftAmount:
//            type = @"02";
//            break;
//        case CurrentSelectedCategorySpreadNum:
//            type = @"03";
//            break;
//        case CurrentSelectedCategoryPrice:
//            type = @"04";
//            break;
//        case CurrentSelectedCategoryIndustry:
//            type = @"05";
//            break;
//        default:
//            type = @"01";
//            break;
//    }

//    if (self.currentArray != nil && self.currentArray.count != 0 && _pageSize != 0) {
//        index = self.currentArray.count / _pageSize + 1;
//    }
    if (self.currentArray == nil || self.currentArray.count == 0) {
        _currentPage = 0;
    }
    _currentPage = _currentPage + 1;
    [SVProgressHUD show];
//    CurrentSelectedCategory categoryWhenFetch = _currentCategory;
    NSString *idWhenFetch = self.currentHangyeId;
    [NetworkInterface getAdsWithIndex:_currentPage type:type hangye:hangye success:^(NSArray<Advertisement *> *list, NSInteger pageSize) {
        [self.tableView.mj_footer endRefreshing];
        _pageSize = pageSize;
        if (self.currentArray.count == 0 || self.currentArray == nil) {
            if ([self.currentHangyeId isEqualToString:idWhenFetch] || (self.currentHangyeId == nil && idWhenFetch == nil)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.currentArray = list;
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
            if ([self.currentHangyeId isEqualToString:idWhenFetch] || (self.currentHangyeId == nil && idWhenFetch == nil)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView beginUpdates];
                    [_tableView insertRowsAtIndexPaths:[indexpaths copy] withRowAnimation:UITableViewRowAnimationNone];
                    [_tableView endUpdates];
                });
            }
            
        }
        [SVProgressHUD dismiss];
//        switch (self.currentCategory) {
//            case CurrentSelectedCategoryDefault:
//                self.defaultAds = self.currentArray;
//                break;
//            case CurrentSelectedCategoryLeftAmount:
//                self.leftAnmoutAds = self.currentArray;
//                break;
//            case CurrentSelectedCategorySpreadNum:
//                self.spreadNumAds = self.currentArray;
//                break;
//            case CurrentSelectedCategoryPrice:
//                self.priceAds = self.currentArray;
//                break;
//            case CurrentSelectedCategoryIndustry:
//                self.industryAds = self.currentArray;
//                break;
//            default:
//                break;
//        }
        
    } failure:^(NSString *message, NSInteger errorCode) {
        [SVProgressHUD dismiss];
        _currentPage -= 1;
        [self.tableView.mj_footer endRefreshing];
    }];
}

@end
