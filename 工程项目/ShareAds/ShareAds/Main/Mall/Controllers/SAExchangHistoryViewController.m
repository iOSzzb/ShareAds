//
//  SAExchangHistoryViewController.m
//  ShareAds
//
//  Created by 张振波 on 2017/12/11.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAExchangHistoryViewController.h"
#import "SAExchangeHistoryCellTableViewCell.h"
#import "Withdraw.h"
#import "MJRefresh.h"
@interface SAExchangHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSArray<Withdraw *> *list;
@end

@implementation SAExchangHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SAExchangeHistoryCellTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cellid"];
    _tableView.rowHeight = 60;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.title = @"兑换记录";
    self.list = [NSArray new];
    [self getExchangeCommodityList];
    __weak typeof(self) weakSelf = self;
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getExchangeCommodityList];
    }] ;
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAExchangeHistoryCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    Withdraw *withdraw = self.list[indexPath.row];
    cell.nameLabel.text = withdraw.desc;
    cell.priceLabel.text = withdraw.money;
    cell.timeLabel.text = withdraw.time;
    if ([withdraw.status isEqualToString:@"01"]) {
        cell.statusLabel.text = @"已完成";
    } else if ([withdraw.status isEqualToString:@"02"]) {
        cell.statusLabel.text = @"进行中";
    }
    return cell;
}

- (void)getExchangeCommodityList {
    if (self.list.count == 0) {
        self.currentPage = 0;
    }
    self.currentPage += 1;
    [NetworkInterface getExchangeCommodityListWithIndex:self.currentPage success:^(NSArray<Withdraw *> *list, NSInteger pageSize) {
        NSMutableArray *mut = [NSMutableArray arrayWithArray:self.list];
        [mut addObjectsFromArray:list];
        self.list = [mut copy];
        [self.tableView reloadData];
        [_tableView.mj_footer endRefreshing];
    } failure:^(NSString *message, NSInteger errorCode) {
        self.currentPage -= 1;
        [_tableView.mj_footer endRefreshing];
    }];
}
@end
