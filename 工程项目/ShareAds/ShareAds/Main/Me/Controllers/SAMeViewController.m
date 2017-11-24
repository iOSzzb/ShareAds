//
//  SAMeViewController.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/5.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAMeViewController.h"
#import "SAMeViewModel.h"
#import "SAMeTableViewCell.h"
#import "NetworkInterface.h"
@interface SAMeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<SAMeViewModel *> *dataSource;
@end
static NSString * const kMeCellID = @"MeCellId";
@implementation SAMeViewController
#pragma mark - Life Cyle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self p_setupTableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [NetworkInterface getUserInfo:^{
        
    } failure:^(NSString *message, NSInteger errorCode) {
        NSLog(@"%ld%@",(long)errorCode,message);
    }];
    
}
#pragma mark - Private Method
- (void)p_setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 40;
    //去掉空数据的cell的分割线
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SAMeTableViewCell class]) bundle:nil] forCellReuseIdentifier:kMeCellID];
    self.dataSource = [SAMeViewModel prepareForMeTableView];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMeCellID];
    SAMeViewModel *model = _dataSource[indexPath.row];
    cell.leftLabel.text = model.leftText;
    if (model.rightText != nil) {
        cell.rightLabel.font = [UIFont systemFontOfSize:15];
        cell.rightLabel.text = model.rightText;
    } else {
        cell.rightLabel.font = [UIFont systemFontOfSize:10];
        cell.rightLabel.text = model.littleSubtext;
    }
    return cell;
}
@end
