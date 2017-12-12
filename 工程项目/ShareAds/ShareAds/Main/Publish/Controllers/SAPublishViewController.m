//
//  SAPublishViewController.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/5.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAPublishViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SAPublishCell.h"
#import "SAFormViewController.h"
#import "SAMyMoneyView.h"
#import "SACalendarStyleLabel.h"
#import "SASelectAreaController.h"
#import "MJRefresh.h"
#import "Advertisement.h"
#import "SAMyMoneyViewController.h"
@interface SAPublishViewController ()<UITableViewDataSource,UITableViewDelegate,SASelectAreaControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *posterBanner;
@property (nonatomic, strong) UILabel *posterNumberLabel;
@property (nonatomic, strong) UIView *userBanner;
@property (nonatomic, strong) UILabel *userNumberLabel;
@property (nonatomic, strong) SAMyMoneyView *myMoneyView;
@property (nonatomic, strong) SAMyMoneyView *myPublishView;
@property (nonatomic, strong) UIButton *publishBtn;
@property (nonatomic, strong) SACalendarStyleLabel *posterNumLabel;
@property (nonatomic, strong) SACalendarStyleLabel *userNumLabel;
@property (nonatomic, strong) UIButton *selectAreaBtn;
@property (nonatomic, strong) UIButton *numberBtn;
@property (nonatomic, strong) NSArray *dataSource;
@end
static NSString * const kTableViewCellID = @"TableViewCellID";
@implementation SAPublishViewController
{
    NSInteger _pageSize;
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self p_setupTableView];
    [self p_setupPosterBanner];
    [self p_setupUserBanner];
    [self p_setupMyMoneyView];
    [self p_setupMyPublishView];
    [self p_setupPublishBtn];
    [self getnumber:@"01" area:nil];
    [self pullDown];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:SAUserNeedReloadUserInfoNotifaction object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    _myMoneyView.valueLabel.text = [NSString stringWithFormat:@"%@元",[SAUser shareUser].adAccountMoney];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableHeaderView.frame = CGRectMake(0, 0, _tableView.bounds.size.width, CGRectGetMaxY(_myPublishView.frame));
    [_publishBtn sizeToFit];
    CGSize btnSize = CGSizeMake(50, 50);
    _publishBtn.frame = CGRectMake(self.view.bounds.size.width - btnSize.width - 25, self.view.bounds.size.height - self.tabBarController.tabBar.bounds.size.height - 20 - btnSize.height, btnSize.width, btnSize.height);
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Private Method
- (void)p_setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellID];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SAPublishCell class]) bundle:nil] forCellReuseIdentifier:kTableViewCellID];
    _tableView.rowHeight = 75;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 200)];
    self.tableView.tableHeaderView = _tableHeaderView;
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDown)];
    header.ignoredScrollViewContentInsetTop = 20;
    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUp)];
    self.tableView.sectionFooterHeight = 0.1;
}
- (void)p_setupPosterBanner {
    self.posterBanner = [[UIView alloc] init];
    _posterBanner.backgroundColor = APP_TIN_COLOR;
    self.posterNumLabel = [[SACalendarStyleLabel alloc] init];
    _posterNumLabel.text = @"0000000";
    [_posterBanner addSubview:_posterNumLabel];
    [_posterNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_posterBanner.mas_left).offset(8);
        make.centerY.equalTo(_posterBanner.mas_centerY);
    }];
    UILabel *label1 = [UILabel new];
    NSString *str1 = @"位广告主正在推介汇";
    NSString *str2 = @"推广";
    NSString *str = [NSString stringWithFormat:@"%@%@",str1,str2];
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:str];
    [mutStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]} range:[str rangeOfString:str1]];
    [mutStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor redColor]} range:[str rangeOfString:str2]];
    label1.attributedText = mutStr;
    [_posterBanner addSubview:label1];
    label1.adjustsFontSizeToFitWidth = YES;
    label1.minimumScaleFactor = 0.5;
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_posterNumLabel.mas_right).offset(8);
        make.centerY.equalTo(_posterBanner.mas_centerY);
//        make.right.equalTo(_posterBanner.mas_right);
    }];
    _posterBanner.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    [_tableHeaderView addSubview:_posterBanner];
}
- (void)p_setupUserBanner {
    self.userBanner = [[UIView alloc] init];
    _userBanner.backgroundColor = APP_TIN_COLOR;
    _userBanner.frame = CGRectMake(0, CGRectGetMaxY(_posterBanner.frame) + 10, self.view.bounds.size.width, 68);
    [_tableHeaderView addSubview:_userBanner];
    self.userNumLabel = [[SACalendarStyleLabel alloc] init];
    _userNumLabel.text = @"0000000";
    [_userBanner addSubview:_userNumLabel];
    [_userNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userBanner.mas_left).offset(8);
        make.centerY.equalTo(_userBanner.mas_centerY);
    }];
    NSString *str1 = @"位会员在全国使用";
    NSString *str2 = @"推介汇";
    NSString *str = [NSString stringWithFormat:@"%@%@",str1,str2];
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:str];
    [mutStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]} range:[str rangeOfString:str1]];
    [mutStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor redColor]} range:[str rangeOfString:str2]];
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = mutStr;
    label.font = [UIFont systemFontOfSize:14];
    [_userBanner addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userBanner.mas_top).offset(3);
        make.left.equalTo(_userNumLabel.mas_right).offset(8);
    }];
    UILabel *quyu = [[UILabel alloc] init];
    quyu.text = @"区域";
    quyu.font = [UIFont systemFontOfSize:14];
    [_userBanner addSubview:quyu];
    [quyu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_left);
        make.top.equalTo(label.mas_bottom).offset(3);
    }];
    self.selectAreaBtn = [UIButton new];
    _selectAreaBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _selectAreaBtn.layer.cornerRadius = 5;
    _selectAreaBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    _selectAreaBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _selectAreaBtn.layer.borderWidth = 1;
    _selectAreaBtn.backgroundColor = [UIColor whiteColor];
    [_selectAreaBtn setImage:[UIImage imageNamed:@"expend_arrow"] forState:UIControlStateNormal];
    [_selectAreaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_selectAreaBtn setTitle:@"     " forState:UIControlStateNormal];
    [_selectAreaBtn addTarget:self action:@selector(selectAreaBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_userBanner addSubview:_selectAreaBtn];
    [_selectAreaBtn setContentCompressionResistancePriority:246 forAxis:UILayoutConstraintAxisHorizontal];
    [_selectAreaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(quyu.mas_right);
        make.centerY.equalTo(quyu.mas_centerY);
        make.right.lessThanOrEqualTo(_userBanner.mas_right).priority(248);
    }];
    UILabel *shuliang = [[UILabel alloc] init];
    shuliang.text = @"数量";
    shuliang.font = [UIFont systemFontOfSize:14];
    [_userBanner addSubview:shuliang];
    [shuliang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_left);
        make.top.equalTo(quyu.mas_bottom).offset(6);
    }];
    self.numberBtn = [UIButton new];
    _numberBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _numberBtn.layer.cornerRadius = 5;
    _numberBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    _numberBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _numberBtn.layer.borderWidth = 1;
    _numberBtn.backgroundColor = [UIColor whiteColor];
    [_numberBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_numberBtn setTitle:@"     " forState:UIControlStateNormal];
    [_userBanner addSubview:_numberBtn];
    [_numberBtn setContentCompressionResistancePriority:246 forAxis:UILayoutConstraintAxisHorizontal];
    [_numberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shuliang.mas_right);
        make.centerY.equalTo(shuliang.mas_centerY);
        make.right.lessThanOrEqualTo(_userBanner.mas_right).priority(248);
    }];
}
- (void)p_setupMyMoneyView {
    SAMyMoneyView *myMoneyView = [[SAMyMoneyView  alloc] init];
    [_tableHeaderView addSubview:myMoneyView];
    myMoneyView.textLabel.text = @"我的资金";
//    myMoneyView.warningLabel.text = @"可充值  可申请随时撤回未用完的资金";
    myMoneyView.valueLabel.text = [NSString stringWithFormat:@"%@元",[SAUser shareUser].adAccountMoney];
    [myMoneyView addTarget:self action:@selector(myMoneyClicked:) forControlEvents:UIControlEventTouchUpInside];
    [myMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userBanner.mas_bottom).offset(10);
        make.left.equalTo(_tableHeaderView.mas_left);
        make.right.equalTo(_tableHeaderView.mas_right);
        make.height.equalTo(@40);
    }];
    myMoneyView.backgroundColor = [UIColor whiteColor];
    _tableHeaderView.backgroundColor = LIGHT_GRAY_BACKGROUND_COLOR;
////    UIView *topLine = [UIView new];
//    topLine.backgroundColor = LIGHT_GRAY_BORDER_COLOR;
//    [myMoneyView addSubview:topLine];
//    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(myMoneyView.mas_top);
//        make.left.equalTo(myMoneyView.mas_left);
//        make.right.equalTo(myMoneyView.mas_right);
//        make.height.equalTo(@0.5);
//    }];
//    UIView *bottomLine = [UIView new];
//    bottomLine.backgroundColor = LIGHT_GRAY_BORDER_COLOR;
//    [myMoneyView addSubview:bottomLine];
//    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(myMoneyView.mas_bottom);
//        make.left.equalTo(myMoneyView.mas_left);
//        make.right.equalTo(myMoneyView.mas_right);
//        make.height.equalTo(@0.5);
//    }];
    self.myMoneyView = myMoneyView;
}
- (void)p_setupMyPublishView {
    SAMyMoneyView *mypublishView = [[SAMyMoneyView  alloc] init];
    [_tableHeaderView addSubview:mypublishView];
    mypublishView.textLabel.text = @"我的发布";
    [mypublishView.leftArrow setHidden:YES];
    mypublishView.backgroundColor = [UIColor whiteColor];
//    [mypublishView addTarget:self action:@selector(myMoneyClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mypublishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_myMoneyView.mas_bottom).offset(10);
        make.left.equalTo(_tableHeaderView.mas_left);
        make.right.equalTo(_tableHeaderView.mas_right);
        make.height.equalTo(@40);
    }];
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = LIGHT_GRAY_BORDER_COLOR;
    [mypublishView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(mypublishView.mas_bottom);
        make.left.equalTo(mypublishView.mas_left);
        make.right.equalTo(mypublishView.mas_right);
        make.height.equalTo(@0.5);
    }];
    self.myPublishView = mypublishView;
    [self.tableHeaderView layoutIfNeeded];
}
- (void)p_setupPublishBtn {
    self.publishBtn = [UIButton new];
    [_publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [_publishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CGSize btnSize = CGSizeMake(50, 50);
    _publishBtn.layer.cornerRadius = btnSize.width/2;
    _publishBtn.backgroundColor = APP_TIN_COLOR;
    _publishBtn.frame = CGRectMake(self.view.bounds.size.width - btnSize.width - 25, self.view.bounds.size.height - self.tabBarController.tabBar.bounds.size.height - 20 - btnSize.height, btnSize.width, btnSize.height);
    NSLog(@"%@",[NSString stringWithFormat:@"%@",NSStringFromCGRect(_publishBtn.frame)] );
    [_publishBtn addTarget:self action:@selector(publishbtnClicked) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_publishBtn];

}
#pragma mark - UITableViewDelegate & UITableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellID forIndexPath:indexPath];
    Advertisement *model = _dataSource[indexPath.row];
    [cell.adsImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    NSString *titleWithBrackets = [NSString stringWithFormat:@"【%@】",model.title];
    NSString *title = [NSString stringWithFormat:@"%@%@",titleWithBrackets,model.content];
    NSMutableAttributedString *attrbutedTitle = [[NSMutableAttributedString alloc] initWithString:title];
    
    NSRange titleRange = [title rangeOfString:titleWithBrackets];
    [attrbutedTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor redColor]} range:titleRange];
    NSRange contentRange = [title rangeOfString:model.content];
    [attrbutedTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor blackColor]} range:contentRange];
    cell.nameLabel.attributedText = attrbutedTitle;
//    cell.nameLabel.text = model.title;
    cell.priceLabel.text = [NSString stringWithFormat:@"单价%0.2f元",[model.price floatValue]] ;
    cell.amountLabel.text = [NSString stringWithFormat:@"剩余%0.2f元",[model.remainAmount floatValue]];
    __weak typeof(self) weakSelf = self;
//    cell.actionBlock = ^(PublishCellOptType actionType) {
//        if (actionType == PublishCellOptTypeLeft) {
//            [weakSelf removeMyAds:model];
//        }
//        if (actionType == PublishCellOptTypeRight) {
//            [weakSelf editMyAds:model];
//        }
//    };
    if ([model.status isEqualToString:@"01"]) {//已上架
        [cell.leftBtn setTitle:@"下架" forState:UIControlStateNormal];
        [cell.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        cell.actionBlock = ^(PublishCellOptType actionType) {
            if (actionType == PublishCellOptTypeLeft) {
                [weakSelf removeMyAds:model];
            }
            if (actionType == PublishCellOptTypeRight) {
                [weakSelf editMyAds:model];
            }
        };
    } else if ([model.status isEqualToString:@"02"]) {//审核中
        [cell.leftBtn setTitle:@"预览" forState:UIControlStateNormal];
        [cell.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        cell.actionBlock = ^(PublishCellOptType actionType) {
            if (actionType == PublishCellOptTypeLeft) {
                [weakSelf preview:model];
            }
            if (actionType == PublishCellOptTypeRight) {
                [weakSelf editMyAds:model];
            }
        };
    } else if ([model.status isEqualToString:@"03"]) {//已下架
        [cell.leftBtn setTitle:@"快速上架" forState:UIControlStateNormal];
        [cell.rightBtn setTitle:@"删除" forState:UIControlStateNormal];
        cell.actionBlock = ^(PublishCellOptType actionType) {
            if (actionType == PublishCellOptTypeLeft) {
                [weakSelf quickPost:model];
            }
            if (actionType == PublishCellOptTypeRight) {
                [weakSelf deleteAds:model];
            }
        };
    } else if ([model.status isEqualToString:@"04"]) {//编辑审核中
        [cell.leftBtn setTitle:@"预览" forState:UIControlStateNormal];
        [cell.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        cell.actionBlock = ^(PublishCellOptType actionType) {
            if (actionType == PublishCellOptTypeLeft) {
                [weakSelf preview:model];
            }
            if (actionType == PublishCellOptTypeRight) {
                [weakSelf editMyAds:model];
            }
        };
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
#pragma mark - 点击事件
- (void)myMoneyClicked:(UIControl *)control {
    NSLog(@"我的资金");
    SAMyMoneyViewController *vc = [[SAMyMoneyViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 我要发布按钮点击
- (void)publishbtnClicked {
    SAFormViewController *formvc = [SAFormViewController new];
    formvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:formvc animated:YES];
    NSLog(@"发布按钮点击");
}
#pragma mark -- 选择区域
- (void)selectAreaBtnClicked:(UIButton *)btn{
    SASelectAreaController *vc = [SASelectAreaController new];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:vc animated:NO completion:nil];
    });

}
#pragma mark - SASelectAreaControllerDelegate -- 选地区的回调
- (void)selectAreaController:(SASelectAreaController *)sexvc didSelectProvince:(Province *)province city:(City *)city district:(District *)district {
    NSString *str;
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
    if (province != nil) {
        str = province.desc;
        [mutDic setObject:province.provId forKey:@"provinceCode"];

    }
    if (city != nil) {
        str = [str stringByAppendingString:city.desc];
        [mutDic setObject:city.cityId forKey:@"cityCode"];
    }
    if (district != nil) {
        str = [str stringByAppendingString:district.desc];
        [mutDic setObject:district.areaId forKey:@"areaCode"];
    }
    [_selectAreaBtn setTitle:str forState:UIControlStateNormal];
    [self getnumber:@"02" area:mutDic];
}
#pragma mark - network 网络请求
- (void)getnumber:(NSString *)type area:(NSDictionary *)area{
    NSDictionary *dic = @{@"type":type};
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    if (area) {
        [mutDic addEntriesFromDictionary:area];
    }
    [NetworkInterface getSpecUserNumber:dic success:^(NSDictionary *response) {
        NSLog(@"");
        NSString *adNumer = response[@"adNumber"];
        NSString *usNumber = response[@"usNumber"];
        NSMutableString *mutstr = [NSMutableString stringWithString:usNumber];
        NSMutableString *mutstrAD = [NSMutableString stringWithString:adNumer];
        for (int i = 0; i < 7 - usNumber.length; i ++) {
            [mutstr insertString:@"0" atIndex:0];
        }
        for (int i = 0; i < 7 - adNumer.length; i ++) {
            [mutstrAD insertString:@"0" atIndex:0];
        }
        self.userNumLabel.text = mutstrAD;
        self.posterNumLabel.text = mutstr;
        [self.numberBtn setTitle:adNumer forState:UIControlStateNormal];
//        if ([type isEqualToString:@"01"]) {
//            self.posterNumLabel.text = mutstr;
//        }
//        if ([type isEqualToString:@"02"]) {
//            self.userNumLabel.text = mutstrAD;
//            [self.numberBtn setTitle:adNumer forState:UIControlStateNormal];
//        }
        
    } failure:^(NSString *message, NSInteger errorCode) {
        NSLog(@"");
    }];
}
- (void)getShareAdsInfoWithIndex:(NSInteger)index {
    [NetworkInterface getReleaseAdsWithIndex:index success:^(NSArray<Advertisement *> *list, NSInteger pageSize) {
        _pageSize = pageSize;
        NSMutableArray *mut = [[NSMutableArray alloc] initWithArray:_dataSource];
        [mut addObjectsFromArray:list];
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (int i = _dataSource.count; i < mut.count; i ++ ) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        _dataSource = [mut copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [_tableView endUpdates];
        });
        
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
        if (list.count < _pageSize && _dataSource.count != 0) {
            [_tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
    } failure:^(NSString *message, NSInteger errorCode) {
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
    }];
}
#pragma mark - 上下拉刷新
- (void)pullDown {
    _dataSource = [NSArray new];
    [_tableView reloadData];
    [self getShareAdsInfoWithIndex:1];
    [self getnumber:@"01" area:nil];
}
- (void)pullUp {
    if (_pageSize != 0) {
        if (_dataSource.count % _pageSize == 0) {
            NSInteger nextPage = _dataSource.count / _pageSize + 1;
            [self getShareAdsInfoWithIndex:nextPage];
        }
    }
    else {
        _dataSource = [NSArray new];
        [self getShareAdsInfoWithIndex:1];
    }
}
#pragma mark - 编辑、下架
- (void)editMyAds:(Advertisement *)ads {
    
}
- (void)removeMyAds:(Advertisement *)ads {
    [NetworkInterface stopAdWithId:ads.id success:^(NSDictionary *response) {
        [SVProgressHUD showSuccessWithStatus:@"下架成功"];
    } failure:^(NSString *message, NSInteger errorCode) {
        [SVProgressHUD showErrorWithStatus:message];
    }];
}
- (void)preview:(Advertisement *)ads {
    
}
- (void)quickPost:(Advertisement *)ads {
    
}

- (void)deleteAds:(Advertisement *)ads {
    
}
- (void)reloadData {
    [self pullDown];
    [NetworkInterface getUserInfo:^{
        _myMoneyView.valueLabel.text = [NSString stringWithFormat:@"%@元",[SAUser shareUser].adAccountMoney];
    } failure:^(NSString *message, NSInteger errorCode) {
    }];

}

@end
