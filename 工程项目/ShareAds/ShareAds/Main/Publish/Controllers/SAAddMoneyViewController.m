//
//  SAMyMoneyViewController.m
//  ShareAds
//
//  Created by 张振波 on 2017/8/1.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAAddMoneyViewController.h"
#import "SAMeTableViewCell.h"
#import "SAFormInputCell.h"
@interface SAAddMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *addMoneyBtn;
@end

@implementation SAAddMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackItem];
    self.title = @"充值";
    self.tabelView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    [self.tabelView registerNib:[UINib nibWithNibName:NSStringFromClass([SAMeTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cellId"];
    [self.tabelView registerNib:[UINib nibWithNibName:NSStringFromClass([SAFormInputCell class]) bundle:nil] forCellReuseIdentifier:@"inputcellId"];
    self.tabelView.sectionFooterHeight = 10;
    self.tabelView.sectionHeaderHeight = 10;
    [self addBackItem];
    [self.view addSubview:_tabelView];
    self.addMoneyBtn = [UIButton new];
    [_addMoneyBtn setTitle:@"充值" forState:UIControlStateNormal];
    [_addMoneyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addMoneyBtn setBackgroundColor:APP_TIN_COLOR];
    _addMoneyBtn.layer.cornerRadius = 5;
    [_addMoneyBtn addTarget:self action:@selector(addMoney) forControlEvents:UIControlEventTouchUpInside];
    [_tabelView addSubview:_addMoneyBtn];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tabelView.frame = self.view.bounds;
    CGRect rect = [_tabelView rectForFooterInSection:1];
    _addMoneyBtn.frame = CGRectMake(15, CGRectGetMaxY(rect) + 30, self.view.bounds.size.width - 15 * 2, 40);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
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
    if (indexPath.section == 0) {
        SAMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];

        cell.leftLabel.text = @"我的资金";
        cell.rightLabel.text = [NSString stringWithFormat:@"%@元",[SAUser shareUser].adAccountMoney] ;
        [cell.arrowImg setHidden:YES];
        return cell;

    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            SAFormInputCell *inputCell = [tableView dequeueReusableCellWithIdentifier:@"inputcellId" forIndexPath:indexPath];
            inputCell.selectionStyle = UITableViewCellSelectionStyleNone;
            inputCell.titleLabel.text = @"充值";
            inputCell.textField.placeholder = @"请输入充值金额";
            inputCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            self.textField = inputCell.textField;
            return inputCell;
        }
        
    }
    return nil;
}
- (void)addMoney {
    if ([self.textField.text floatValue] == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的金额"];
        return;
    }
    [NetworkInterface recharge:self.textField.text type:@"01" success:^(NSDictionary *response) {
        NSLog(@"");
    } failure:^(NSString *message, NSInteger errorCode) {
        NSLog(@"");
    }];
}
@end
