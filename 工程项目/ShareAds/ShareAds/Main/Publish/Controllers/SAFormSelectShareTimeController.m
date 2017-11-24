//
//  PBChangeSexViewController.m
//  PartyBuilding
//
//  Created by 张振波 on 2017/7/19.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAFormSelectShareTimeController.h"

@interface SAFormSelectShareTimeController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@end

@implementation SAFormSelectShareTimeController

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
    return 3;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"%ld,%ld",(long)row,(long)component);
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {
        return @"无限制";
    }
    else if(row == 2){
        return @"周末";
    }
    else {
        return @"工作日";
    }
}
- (IBAction)btnClicked:(UIButton *)sender {
    if (sender == self.cancleBtn) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    if (sender == self.confirmBtn) {
        if ([self.delegate respondsToSelector:@selector(selectShareTimeController:didSelectTime:)]) {
            
            NSString *time = @"01";
            switch ([self.pickerView selectedRowInComponent:0]) {
                case 0:
                    time = @"01";
                    break;
                case 1:
                    time = @"02";
                    break;
                case 2:
                    time = @"03";
                    break;
                default:
                    break;
            };
            [self.delegate selectShareTimeController:self didSelectTime:time];
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
@end
