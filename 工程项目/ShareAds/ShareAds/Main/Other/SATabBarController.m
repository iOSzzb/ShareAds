//
//  SATabBarController.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/5.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SATabBarController.h"
#import "BaseNavigationController.h"
#import "SAHomeViewController.h"
#import "SAMallViewController.h"
#import "SAPublishViewController.h"
#import "SAMeViewController.h"
@interface SATabBarController ()

@end

@implementation SATabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    CGFloat tabbarHeight = self.tabBar.bounds.size.height;
    self.tabBar.tintColor = [UIColor colorWithRed:250.0/255.0 green:192.0/255.0 blue:0 alpha:1];
    UITabBarItem *homeTabBarItem = [[UITabBarItem alloc] init];
    NSString *homeTitle = @"首页";
    UIImage *homeImage = [[UIImage imageNamed:@"home_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeTabBarItem.image = homeImage;
    homeTabBarItem.selectedImage = [[UIImage imageNamed:@"home_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeTabBarItem.title = homeTitle;
//    NSDictionary *attributesDic = @{NSFontAttributeName:[UIFont systemFontOfSize:20 weight:UIFontWeightRegular]};
//    [homeTabBarItem setTitleTextAttributes:attributesDic forState:UIControlStateNormal];
//    CGSize homeTitleSize = [homeTitle sizeWithAttributes:attributesDic];
//    homeTabBarItem.titlePositionAdjustment = UIOffsetMake(0, -(tabbarHeight-homeTitleSize.height)/2);
//    homeTabBarItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);
    BaseNavigationController *homeNav = [[BaseNavigationController alloc] initWithRootViewController:[SAHomeViewController new]];
    homeNav.tabBarItem = homeTabBarItem;
    
    UITabBarItem *mallTabBarItem = [[UITabBarItem alloc] init];
    NSString *mallTitle = @"商城";
    mallTabBarItem.title = mallTitle;
//    mallTabBarItem.title = mallTitle;
//    NSDictionary *attributesDic1 = @{NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular]};
//    [mallTabBarItem setTitleTextAttributes:attributesDic1 forState:UIControlStateNormal];
//    CGSize mallTitleSize = [mallTitle sizeWithAttributes:attributesDic1];
//    mallTabBarItem.titlePositionAdjustment = UIOffsetMake(0, -(tabbarHeight-mallTitleSize.height)/2);
    UIImage *mallImage = [[UIImage imageNamed:@"shop_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mallTabBarItem.image = mallImage;
    mallTabBarItem.selectedImage = [[UIImage imageNamed:@"shop_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    BaseNavigationController *mallNav = [[BaseNavigationController alloc] initWithRootViewController:[SAMallViewController new]];
    mallNav.tabBarItem = mallTabBarItem;
    
    
    
    UITabBarItem *publishTabBarItem = [[UITabBarItem alloc] init];
    NSString *publishTitle = @"发布";
    UIImage *publishImage = [[UIImage imageNamed:@"advert_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    publishTabBarItem.image = publishImage;
    publishTabBarItem.selectedImage = [[UIImage imageNamed:@"advert_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    publishTabBarItem.title = publishTitle;
    
    BaseNavigationController *publishNav = [[BaseNavigationController alloc] initWithRootViewController:[SAPublishViewController new]];
    publishNav.tabBarItem = publishTabBarItem;
    
    
    
    
    UITabBarItem *meTabBarItem = [[UITabBarItem alloc] init];
    NSString *meTitle = @"我的";
    UIImage *meImage = [[UIImage imageNamed:@"my_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    meTabBarItem.image = meImage;
    meTabBarItem.selectedImage = [[UIImage imageNamed:@"my_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    meTabBarItem.title = meTitle;
    BaseNavigationController *meNav = [[BaseNavigationController alloc] initWithRootViewController:[SAMeViewController new]];
    meNav.tabBarItem = meTabBarItem;
    
    
    self.viewControllers = @[homeNav,mallNav,publishNav,meNav];
//    NSDictionary *dict1 = @{
////                            CYLTabBarItemTitle : @"首页",
//                            CYLTabBarItemImage : @"home_tab_title",
////                            CYLTabBarItemSelectedImage : @"home_highlight",
//                            };
//    NSDictionary *dict2 = @{
////                            CYLTabBarItemTitle : @"同城\nhh",
//                            CYLTabBarItemImage : @"mall_tab_title",
////                            CYLTabBarItemSelectedImage : @"mycity_highlight",
//                            };
//    NSArray *tabBarItemsAttributes = @[ dict1, dict2 ];
//    self.tabBarItemsAttributes = tabBarItemsAttributes;
//    
//    [self setViewControllers:@[homeNav,mallNav]];
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
