//
//  BaseNavigationController.m
//  PartyBuilding
//
//  Created by 张振波 on 2017/4/18.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *bacgroundImage = [self creatBackgroundImag];
    [self.navigationBar setBackgroundImage:bacgroundImage forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    NSDictionary *titleAttrDic = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationBar setTitleTextAttributes:titleAttrDic];
    self.navigationBar.tintColor = [UIColor whiteColor];
    //支持边缘侧滑返回
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self.interactivePopGestureRecognizer setEnabled:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIImage *)creatBackgroundImag {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef color = NAVIGATION_BAR_COLOR.CGColor;
    CGContextSetFillColorWithColor(context, color);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
