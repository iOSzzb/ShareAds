//
//  CommonWebViewController.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/24.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface CommonWebViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, copy) NSString *urlStr;
@end
