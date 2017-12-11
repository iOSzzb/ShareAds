//
//  AdsWebViewController.h
//  ShareAds
//
//  Created by 张振波 on 2017/12/8.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "Advertisement.h"
#import "BaseViewController.h"
@interface AdsWebViewController : BaseViewController
@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) NSString *shareChannels;
@property (nonatomic, assign) BOOL showShareBtnWhenViewAppear;
@property (nonatomic, strong) Advertisement *ads;
@end
