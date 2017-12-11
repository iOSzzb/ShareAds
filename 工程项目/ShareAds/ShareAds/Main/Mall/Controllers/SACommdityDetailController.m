//
//  SACommdityDetailController.m
//  ShareAds
//
//  Created by 张振波 on 2017/8/1.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SACommdityDetailController.h"
#import "SDCycleScrollView.h"
#import "SAUser.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SAExCommdityViewController.h"
@interface SACommdityDetailController ()<SDCycleScrollViewDelegate>
@property (strong, nonatomic) SDCycleScrollView *imgesContainer;
@property (strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UILabel *soldLabel;
@property (strong, nonatomic) UILabel *remainLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *exchangeBtn;
@property (nonatomic, strong) NSMutableArray <UIImageView *> *detailImageViews;
@end

@implementation SACommdityDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBackItem];
    self.title = @"商品详情";
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self setupImgesContainer];
    [self setupLabels];
    [self setupExchagneBtn];
    [self setupDetail];
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"---------%@",doc);
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
//    _scrollView.frame = self.view.bounds;
    _imgesContainer.frame = CGRectMake(0,  0 , self.view.bounds.size.width, self.view.bounds.size.width * 3 / 4);
//    CGFloat priceLabelMaxY = CGRectGetMaxY(_priceLabel.frame);
//    CGFloat maxHeight = priceLabelMaxY + 8 + 40 + 10;
//    if (maxHeight < self.view.bounds.size.height) {
//        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + 1000);
        _exchangeBtn.frame = CGRectMake(8, self.view.bounds.size.height - 10 - 40, self.view.bounds.size.width - 2*8, 40);
//    }
//    else {
//        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, maxHeight + 1000);
//        _exchangeBtn.frame = CGRectMake(8, CGRectGetMaxY(_priceLabel.frame) + 8, self.view.bounds.size.width - 2*8, 40);
//    }
    [self reframeImageViews];
}

- (void)setupImgesContainer {
    self.imgesContainer = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,  0 , self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16) delegate:self placeholderImage:[UIImage new]];
    _imgesContainer.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _imgesContainer.imageURLStringsGroup = _commdity.bannerUrlList;
    [_scrollView addSubview:_imgesContainer];
}
- (void)setupLabels {
    self.descLabel = [UILabel new];
    _descLabel.font = [UIFont systemFontOfSize:17];
    self.soldLabel = [UILabel new];
    _soldLabel.font = [UIFont systemFontOfSize:15];
    self.remainLabel = [UILabel new];
    _remainLabel.font = [UIFont systemFontOfSize:15];
    self.priceLabel = [UILabel new];
    _priceLabel.font = [UIFont systemFontOfSize:15];
    [self.scrollView addSubview:_descLabel];
    [self.scrollView addSubview:_soldLabel];
    [self.scrollView addSubview:_remainLabel];
    [self.scrollView addSubview:_priceLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgesContainer.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left).offset(8);
        make.right.equalTo(self.view.mas_right).offset(8);
    }];
    [_soldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLabel.mas_bottom).offset(8);
        make.left.equalTo(_scrollView.mas_left).offset(8);
    }];
    [_remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_soldLabel.mas_bottom).offset(8);
        make.left.equalTo(_scrollView.mas_left).offset(8);
    }];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_descLabel.mas_bottom).offset(8);
        make.left.equalTo(_scrollView.mas_left).offset(8);
    }];
    
    NSString *titleWithBrackets = [NSString stringWithFormat:@"【%@】",_commdity.typeDesc];
    NSString *title = [NSString stringWithFormat:@"%@%@",titleWithBrackets,_commdity.desc];
    NSMutableAttributedString *attrbutedTitle = [[NSMutableAttributedString alloc] initWithString:title];
    
    NSRange titleRange = [title rangeOfString:titleWithBrackets];
    [attrbutedTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor redColor]} range:titleRange];
    NSRange contentRange = [title rangeOfString:_commdity.desc];
    [attrbutedTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor blackColor]} range:contentRange];
    _descLabel.numberOfLines = 0;
    _descLabel.attributedText = attrbutedTitle;
    _soldLabel.text = [NSString stringWithFormat:@"已兑换:%ld件",(long)_commdity.sellNumber];
    _remainLabel.text = [NSString stringWithFormat:@"剩余:%ld件",(long)_commdity.currNumber];
    NSString *price = [NSString stringWithFormat:@"%.1f",_commdity.price];
    NSString *priceStr = [NSString stringWithFormat:@"价格:%@",price];
    NSMutableAttributedString *attrPrice = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrPrice addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[priceStr rangeOfString:price]];
    _priceLabel.attributedText = attrPrice;
}

- (void)setupExchagneBtn {
    self.exchangeBtn = [UIButton new];
    [_exchangeBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    [_exchangeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_exchangeBtn setBackgroundColor:APP_TIN_COLOR];
    _exchangeBtn.layer.cornerRadius = 5;
    [self.view addSubview:_exchangeBtn];
    [_exchangeBtn addTarget:self action:@selector(exchangBtnClicked) forControlEvents:UIControlEventTouchUpInside];

}
- (void)exchangBtnClicked {
    if ([[SAUser shareUser].level isEqualToString:@"A"] ) {
        [SVProgressHUD showErrorWithStatus:@"升级为高级推手才能兑换商品"];
        return;
    }
    if ([[SAUser shareUser].totalMoney floatValue] < _commdity.price) {
        [SVProgressHUD showErrorWithStatus:@"账户余额不足"];
        return;
    }
    SAExCommdityViewController *exvc = [SAExCommdityViewController new];
    exvc.commdityId = self.commdity.id;
    [self.navigationController pushViewController:exvc animated:YES];
}
- (void)setupDetail {
    self.detailImageViews = [NSMutableArray new];
    for (int i = 0; i < self.commdity.url.count; i ++) {
        NSString *url = self.commdity.url[i];
        UIImageView *imageView = [UIImageView new];
        [self.scrollView addSubview:imageView];
        __weak typeof(self) weakSelf = self;
        [self.detailImageViews addObject:imageView];

        [imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [weakSelf reframeImageViews];
        }];
    }
}
- (void)reframeImageViews {
    for (int i = 0; i < self.detailImageViews.count; i ++) {
        UIImageView *imageView = self.detailImageViews[i];
        CGFloat aspectRadio = 0;
        if (imageView.image.size.width != 0) {
            aspectRadio = imageView.image.size.height / imageView.image.size.width;
        }        
        CGFloat height = self.view.bounds.size.width * aspectRadio;
        CGFloat y = 0;
        if (i == 0) {
            y = CGRectGetMaxY(self.remainLabel.frame);
        } else {
            y = CGRectGetMaxY(self.detailImageViews[i-1].frame);
        }
        imageView.frame = CGRectMake(0, y, self.view.bounds.size.width, height);
        if (i == self.detailImageViews.count - 1) {
            self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(imageView.frame) + 60);
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
