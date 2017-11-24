//
//  PBChangeSexViewController.m
//  PartyBuilding
//
//  Created by 张振波 on 2017/7/19.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SASelectAreaController.h"
#import <Realm/Realm.h>

@interface SASelectAreaController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (nonatomic, strong) RLMResults *provinces;
@property (nonatomic, strong) RLMResults *citys;
@property (nonatomic, strong) RLMResults *districts;
@property (nonatomic, strong) Province *selectProvince;
@property (nonatomic, strong) City *selectCity;
@property (nonatomic, strong) District *selectDistrict;

@end

@implementation SASelectAreaController

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
    self.provinces = [Province allObjects];
    Province *province = _provinces.firstObject;
    self.citys = [City objectsWhere:@"provId = %@",province.provId];
    City *city = _citys.firstObject;
    self.districts = [District objectsWhere:@"provId = %@ AND cityId = %@",province.provId,city.cityId];
    self.selectProvince = province;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 20;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _provinces.count;
    }
    if (component == 1) {
        return _citys.count + 1;
    }
    if (component == 2) {
        return _districts.count + 1;
    }
    return 0;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"%ld,%ld",(long)row,(long)component);
    if (component == 0) {
        Province *province = _provinces[row];
        if ([province.provId isEqualToString:self.selectProvince.provId]) {
            return;
        }
        self.citys = [City objectsWhere:@"provId = %@",province.provId];
        City *city = _citys.firstObject;
        self.districts = [District objectsWhere:@"provId = %@ AND cityId = %@",province.provId,city.cityId];
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }
    if (component == 1) {
        if (row == 0) {
            self.districts = nil;
            [pickerView reloadComponent:2];
        }
        else {
            Province *province = _selectProvince;
            City *city = _citys[row-1];
            if ([city.cityId isEqualToString:self.selectCity.cityId]) {
                return;
            }
            self.districts = [District objectsWhere:@"provId = %@ AND cityId = %@",province.provId,city.cityId];
            [pickerView reloadComponent:2];
        }
        
    }
    if (component == 2) {
//        if (row == 0) {
//            _selectDistrict = nil;
//        }
//        _selectDistrict = _districts[row-1];
    }
    NSInteger selectProvinceIndex = [pickerView selectedRowInComponent:0];
    _selectProvince = _provinces[selectProvinceIndex];
    NSInteger selectCityIndex = [pickerView selectedRowInComponent:1];
    if (selectCityIndex == 0) {
        _selectCity = nil;
    }
    else {
        _selectCity = _citys[selectCityIndex - 1];
    }
    NSInteger selectDistrictIndex = [pickerView selectedRowInComponent:2];
    if (selectDistrictIndex == 0) {
        _selectDistrict = nil;
    }
    else {
        _selectDistrict = _districts[selectDistrictIndex - 1];
    }
    NSLog(@"%@%@%@",_selectProvince.desc,_selectCity.desc,_selectDistrict.desc);
}
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if (component == 0) {
//        Province *province = _provinces[row];
//        return province.desc;
//    }
//    if (component == 1) {
//        if (row == 0) {
//            return @"全部";
//        }
//        City *city = _citys[row - 1];
//        return city.desc;
//    }
//    if (component == 2) {
//        if (row == 0) {
//            return @"全部";
//        }
//        District *district = _districts[row - 1];
//        return district.desc;
//    }
//    return @"";
//}
//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSString *str = @"";
//    if (component == 0) {
//        Province *province = _provinces[row];
//        str = province.desc;
//    }
//    if (component == 1) {
//        if (row == 0) {
//            str = @"全部";
//        }
//        else {
//            City *city = _citys[row - 1];
//            str =  city.desc;
//        }
//    }
//    if (component == 2) {
//        if (row == 0) {
//            str =  @"全部";
//        }
//        else {
//            District *district = _districts[row - 1];
//            str =  district.desc;
//        }
//        
//    }
//    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
//    return attrStr;
//}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *str = @"";
    if (component == 0) {
        Province *province = _provinces[row];
        str = province.desc;
    }
    if (component == 1) {
        if (row == 0) {
            str = @"全部";
        }
        else {
            City *city = _citys[row - 1];
            str =  city.desc;
        }
    }
    if (component == 2) {
        if (row == 0) {
            str =  @"全部";
        }
        else {
            District *district = _districts[row - 1];
            str =  district.desc;
        }
        
    }
//    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    UILabel *label = [UILabel new];
    label.text = str;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    return label;
}
- (IBAction)btnClicked:(UIButton *)sender {
    if (sender == self.cancleBtn) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    if (sender == self.confirmBtn) {
        if ([self.delegate respondsToSelector:@selector(selectAreaController:didSelectProvince:city:district:)]) {
            
            NSInteger selectProvinceIndex = [self.pickerView selectedRowInComponent:0];
            _selectProvince = _provinces[selectProvinceIndex];
            NSInteger selectCityIndex = [self.pickerView selectedRowInComponent:1];
            if (selectCityIndex == 0) {
                _selectCity = nil;
            }
            else {
                _selectCity = _citys[selectCityIndex - 1];
            }
            NSInteger selectDistrictIndex = [self.pickerView selectedRowInComponent:2];
            if (selectDistrictIndex == 0) {
                _selectDistrict = nil;
            }
            else {
                _selectDistrict = _districts[selectDistrictIndex - 1];
            }
            NSLog(@"%@%@%@",_selectProvince.desc,_selectCity.desc,_selectDistrict.desc);
            [self.delegate selectAreaController:self didSelectProvince:_selectProvince city:_selectCity district:_selectDistrict];
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
@end
