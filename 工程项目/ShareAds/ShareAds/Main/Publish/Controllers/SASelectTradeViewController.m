//
//  PBChangeSexViewController.m
//  PartyBuilding
//
//  Created by 张振波 on 2017/7/19.
//  Copyright © 2017年 张振波. All rights reserved.
//
#import <Realm/Realm.h>
#import "SASelectTradeViewController.h"
@interface SASelectTradeViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (nonatomic, strong) RLMResults *dataSource;
@property (nonatomic, strong) Trade *selectTrade;
@end

@implementation SASelectTradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    // Do any additional setup after loading the view from its nib.
//    self.pickerView.frame = CGRectMake(0, CGRectGetMaxY(self.view.bounds), self.view.bounds.size.width, 80);
//    [UIView animateWithDuration:0.3 animations:^{
//        self.pickerView.frame = CGRectMake(0, CGRectGetMaxY(self.view.bounds)-80-self.tabBarController.tabBar.frame.size.height, self.view.bounds.size.width, 80);
//    }];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.backgroundColor = LIGHT_GRAY_BACKGROUND_COLOR;
    self.dataSource = [Trade allObjects];
    self.selectTrade = _dataSource[0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _dataSource.count;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"%ld,%ld",(long)row,(long)component);
    self.selectTrade = _dataSource[row];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Trade *trade = _dataSource[row];
    return trade.desc;
}
- (IBAction)btnClicked:(UIButton *)sender {
    if (sender == self.cancleBtn) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    if (sender == self.confirmBtn) {
        if ([self.delegate respondsToSelector:@selector(selectTradeViewController:didSelectTrade:)]) {
            [self.delegate selectTradeViewController:self didSelectTrade:_selectTrade];
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
@end
