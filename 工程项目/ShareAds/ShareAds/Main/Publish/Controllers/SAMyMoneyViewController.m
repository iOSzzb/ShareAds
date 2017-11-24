//
//  SAMyMoneyViewController.m
//  ShareAds
//
//  Created by 张振波 on 2017/8/1.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAMyMoneyViewController.h"
#import "SAMeTableViewCell.h"
#import "SAAddMoneyViewController.h"
@interface SAMyMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tabelView;
@end

@implementation SAMyMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabelView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    [self.tabelView registerNib:[UINib nibWithNibName:NSStringFromClass([SAMeTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cellId"];
    self.tabelView.sectionFooterHeight = 10;
    self.tabelView.sectionHeaderHeight = 10;
    [self addBackItem];
    [self.view addSubview:_tabelView];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tabelView.frame = self.view.bounds;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 2;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.leftLabel.text = @"我的资金";
        cell.rightLabel.text = [NSString stringWithFormat:@"%@元",[SAUser shareUser].adAccountMoney] ;
        [cell.arrowImg setHidden:YES];
    }else if(indexPath.section == 1){
        [cell.arrowImg setHidden:NO];
        if (indexPath.row == 0) {
            cell.leftLabel.text = @"充值";
        }
        else if (indexPath.row == 1) {
            cell.leftLabel.text = @"提现";
        }

    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            SAAddMoneyViewController *addVc = [SAAddMoneyViewController new];
            [self.navigationController pushViewController:addVc animated:YES];
        }
    }
}
@end
