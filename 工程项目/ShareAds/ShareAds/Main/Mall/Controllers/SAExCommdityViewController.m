//
//  SAExCommdityViewController.m
//  ShareAds
//
//  Created by 张振波 on 2017/12/11.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAExCommdityViewController.h"
#import "SAExchangeCommdityTableViewCell.h"

@interface SAExCommdityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *viewModels;
@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *telNumber;
@property (nonatomic, strong) UIButton *exchangeBtn;
@end

@implementation SAExCommdityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换商品";
    [self addBackItem];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SAExchangeCommdityTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.viewModels = @[@{@"title":@"收件人",@"placeHolder":@"请输入收件人"},
                        @{@"title":@"地址",@"placeHolder":@"请输入收件地址"},
                        @{@"title":@"收件人手机号码",@"placeHolder":@"请输入手机号"}];
    self.tableView.rowHeight = 45;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 15)];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    self.tableView.sectionHeaderHeight = 15;
    self.tableView.sectionFooterHeight = 0.1;
    self.exchangeBtn = [UIButton new];
    self.exchangeBtn.layer.cornerRadius = 5;
    self.exchangeBtn.backgroundColor = APP_TIN_COLOR;
    [self.exchangeBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    [self.exchangeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.exchangeBtn addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:self.exchangeBtn];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.exchangeBtn.frame = CGRectMake(20, (45 + 15) * 3 + 30, self.view.bounds.size.width - 40, 40);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModels.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SAExchangeCommdityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *model = self.viewModels[indexPath.section];
    NSString *title = model[@"title"];
    cell.itemLabel.text = title;
    cell.textField.placeholder = model[@"placeHolder"];
    __weak typeof(self) weakSelf = self;
    cell.textFieldCallbackBlock = ^(UITextField *textView, SAExTBCellTextFieldStatus status) {
        if (status == SAExTBCellTextFieldStatusBegin) {
            weakSelf.currentTextField = textView;
        }
        if (status == SAExTBCellTextFieldStatusEnd) {
            weakSelf.currentTextField = nil;
            if ([title isEqualToString:@"收件人"]) {
                weakSelf.name = textView.text;
            }
            if ([title isEqualToString:@"地址"]) {
                weakSelf.address = textView.text;
            }
            if ([title isEqualToString:@"收件人手机号码"]) {
                weakSelf.telNumber = textView.text;
            }
        }
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SAExchangeCommdityTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
}
- (void)exchange {
    [self.currentTextField resignFirstResponder];
    if (self.address == nil || self.address.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入收件地址"];
        return;
    }
    if (self.name == nil || self.name.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入收件人姓名"];
        return;
    }
    if (self.telNumber == nil || self.telNumber.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入收件人电话"];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您是否确定兑换此商品？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [NetworkInterface exchangeCommodityWithID:self.commdityId recipientName:self.name recipientAddress:self.address recipientPhone:self.telNumber success:^(NSDictionary *response) {
            [SVProgressHUD showSuccessWithStatus:@"订单提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *message, NSInteger errorCode) {
            [SVProgressHUD showErrorWithStatus:@"订单提交失败"];
        }];
    }];
    
    [alert addAction:cancle];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
