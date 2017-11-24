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
    UITabBarItem *homeTabBarItem = [[UITabBarItem alloc] init];
//    NSString *homeTitle = @"首页";
    UIImage *homeImage = [UIImage imageNamed:@"home_tab_title"];
    homeTabBarItem.image = homeImage;
//    NSDictionary *attributesDic = @{NSFontAttributeName:[UIFont systemFontOfSize:20 weight:UIFontWeightRegular]};
//    [homeTabBarItem setTitleTextAttributes:attributesDic forState:UIControlStateNormal];
//    CGSize homeTitleSize = [homeTitle sizeWithAttributes:attributesDic];
//    homeTabBarItem.titlePositionAdjustment = UIOffsetMake(0, -(tabbarHeight-homeTitleSize.height)/2);
    homeTabBarItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);
    BaseNavigationController *homeNav = [[BaseNavigationController alloc] initWithRootViewController:[SAHomeViewController new]];
    homeNav.tabBarItem = homeTabBarItem;
    
    UITabBarItem *mallTabBarItem = [[UITabBarItem alloc] init];
//    NSString *mallTitle = @"兑换\n商城";
//    mallTabBarItem.title = mallTitle;
//    NSDictionary *attributesDic1 = @{NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular]};
//    [mallTabBarItem setTitleTextAttributes:attributesDic1 forState:UIControlStateNormal];
//    CGSize mallTitleSize = [mallTitle sizeWithAttributes:attributesDic1];
//    mallTabBarItem.titlePositionAdjustment = UIOffsetMake(0, -(tabbarHeight-mallTitleSize.height)/2);
    UIImage *mallImage = [UIImage imageNamed:@"mall_tab_title"];
    mallTabBarItem.image = mallImage;
    BaseNavigationController *mallNav = [[BaseNavigationController alloc] initWithRootViewController:[SAMallViewController new]];
    mallNav.tabBarItem = mallTabBarItem;
    mallTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    UITabBarItem *publishTabBarItem = [[UITabBarItem alloc] init];
    UIImage *publishImage = [UIImage imageNamed:@"publish_tab_title"];
    publishTabBarItem.image = publishImage;
    BaseNavigationController *publishNav = [[BaseNavigationController alloc] initWithRootViewController:[SAPublishViewController new]];
    publishNav.tabBarItem = publishTabBarItem;
    publishTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
//    me_tab_title@2x
    
    UITabBarItem *meTabBarItem = [[UITabBarItem alloc] init];
    UIImage *meImage = [UIImage imageNamed:@"me_tab_title"];
    meTabBarItem.image = meImage;
    meTabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
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
