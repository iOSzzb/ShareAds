//
//  AdsWebViewController.m
//  ShareAds
//
//  Created by 张振波 on 2017/12/8.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "AdsWebViewController.h"
#import "ShareButton.h"
#import "WXApiManager.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "Location.h"
#import "SAUser.h"
#import "BBCImageUtility.h"
@interface AdsWebViewController ()<WXApiManagerDelegate,TencentSessionDelegate>
@property (nonatomic, strong) UIView *shareMenu;
@property (nonatomic, strong) NSArray<ShareButton *> *shareBtns;
@property (nonatomic, strong) TencentOAuth *oauth;
@end

@implementation AdsWebViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] init];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self addBackItem];
    [self setupShareMenu];
    [WXApiManager sharedManager].delegate = self;
    self.oauth = [[TencentOAuth alloc] initWithAppId:QQ_APP_ID andDelegate:self];
    // Do any additional setup after loading the view.
    self.title = self.ads.content;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"sandian"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemOnpress)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup menu
- (void)setupShareMenu {
    self.shareMenu = [UIView new];
    [self.view addSubview:self.shareMenu];
    self.shareMenu.backgroundColor = [UIColor whiteColor];
    if ([self.shareChannels isEqualToString:@"x"]) {
        self.shareChannels = @"a,b,c,d";
    }
    NSArray *channels = [self.shareChannels componentsSeparatedByString:@","];
    NSMutableArray *mutBtns = [NSMutableArray new];
    for (int i = 0; i < channels.count; i++) {
        NSString *channel = channels[i];
        ShareButton *button = [ShareButton new];
        if ([channel isEqualToString:@"a"]) {//QQ空间
            button.titleLabel.text = @"QQ空间";
            button.imageView.image = [UIImage imageNamed:@"yaoqinghaoyou_qqspace"];
            [button addTarget:self action:@selector(shareToQQZone:) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([channel isEqualToString:@"b"]) {//微信好友
            button.titleLabel.text = @"微信好友";
            button.imageView.image = [UIImage imageNamed:@"yaoqinghaoyou_weixin"];
            [button addTarget:self action:@selector(shareToWeChatFriend:) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([channel isEqualToString:@"c"]) {//微信朋友圈
            button.titleLabel.text = @"朋友圈";
            button.imageView.image = [UIImage imageNamed:@"yaoqinghaoyou_pengyouquan"];
            [button addTarget:self action:@selector(shareToWeChatTimeline:) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([channel isEqualToString:@"d"]) {//QQ好友
            button.titleLabel.text = @"QQ好友";
            button.imageView.image = [UIImage imageNamed:@"yaoqinghaoyou_qq"];
            [button addTarget:self action:@selector(shareToQQFriend:) forControlEvents:UIControlEventTouchUpInside];
        }
        button.frame = CGRectMake(0, 0, 48, 50);
        [self.shareMenu addSubview:button];
        [mutBtns addObject:button];
    }
    self.shareBtns = [mutBtns copy];
    [self.shareMenu setHidden:!self.showShareBtnWhenViewAppear];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.shareMenu.frame = CGRectMake(0, self.view.bounds.size.height - 60, self.view.bounds.size.width, 60);
    if (self.shareBtns.count > 0) {
        CGFloat width = self.view.bounds.size.width / self.shareBtns.count;
        for (int i = 0; i < self.shareBtns.count; i ++ ) {
            ShareButton *btn = self.shareBtns[i];
            btn.center = CGPointMake(width * (i+1) - width / 2, 60/2);
        }
    }
}
#pragma mark - UI event
- (void)rightBarItemOnpress {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.shareMenu setHidden:NO];
    }];
    UIAlertAction *report = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    if (self.shareMenu.isHidden) {
        [alert addAction:shareAction];
    }
    [alert addAction:report];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)shareToQQFriend:(ShareButton *)button {
    [self reqShareWithChannel:@"d" success:^{
        NSURL *previewURL = [NSURL URLWithString:self.ads.iconUrl];
        NSURL* url = [NSURL URLWithString:self.ads.url];
        
        QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:self.ads.title description:self.ads.content previewImageURL:previewURL];
        //    img.shareDestType = [self getShareType];
        SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        if (sent == EQQAPISENDSUCESS) {
            [self shareAdWithChannel:@"d" success:^{
                
            } failure:^{
                
            }];
        }
    } failure:^{
        
    }];
}

- (void)shareToQQZone:(ShareButton *)button {
    [self reqShareWithChannel:@"a" success:^{
        NSURL *previewURL = [NSURL URLWithString:self.ads.iconUrl];
        NSURL* url = [NSURL URLWithString:self.ads.url];
        
        QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:self.ads.title description:self.ads.content previewImageURL:previewURL];
        //    img.shareDestType = [self getShareType];
        SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
        [img setCflag:kQQAPICtrlFlagQZoneShareOnStart]; //不要忘记设置这个flag
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        if (sent == EQQAPISENDSUCESS) {
            [self shareAdWithChannel:@"a" success:^{
                NSLog(@"share success");
            } failure:^{
                 NSLog(@"share failure");
            }];
        }
    } failure:^{
        
    }];
}
- (void)shareToWeChatTimeline:(ShareButton *)button {
    [self reqShareWithChannel:@"c" success:^{
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = self.ads.url;
        WXMediaMessage *mediaMessage = [WXMediaMessage message];
        mediaMessage.mediaObject = webpageObject;
        mediaMessage.title = self.ads.content;
        mediaMessage.description = self.ads.content;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.ads.iconUrl]];
            if (data.length > 32 * 1000) {
                data = [BBCImageUtility imageDataFromScaleOrCompressImage:[UIImage imageWithData:data] targetSize:32 * 1000];
            }
        mediaMessage.thumbData = data;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = mediaMessage;
        req.scene = WXSceneTimeline;
        
        if ([WXApi sendReq:req]) {
            [self shareAdWithChannel:@"c" success:^{
                
            } failure:^{
                
            }];
        }
    } failure:^{
        
    }];
    
}
- (void)shareToWeChatFriend:(ShareButton *)button {
    [self reqShareWithChannel:@"b" success:^{
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = self.ads.url;
        WXMediaMessage *mediaMessage = [WXMediaMessage message];
        mediaMessage.mediaObject = webpageObject;
        mediaMessage.title = self.ads.title;
        mediaMessage.description = self.ads.content;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.ads.iconUrl]];
        if (data.length > 32 * 1000) {
            data = [BBCImageUtility imageDataFromScaleOrCompressImage:[UIImage imageWithData:data] targetSize:32 * 1000];
        }
        mediaMessage.thumbData = data;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = mediaMessage;
        req.scene = WXSceneSession;
        
        if ([WXApi sendReq:req]) {
            [self shareAdWithChannel:@"b" success:^{
                
            } failure:^{
                
            }];
        }
    } failure:^{
        
    }];
}
#pragma mark - wx delegate
- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    if (response.errCode == WXSuccess) {
        [SVProgressHUD showSuccessWithStatus:@"分享成功"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"分享失败"];
    }
}

#pragma mark - qq delegate
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin {
    
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork {
    
}
#pragma mark - request share

- (void)reqShareWithChannel:(NSString *)channel success:(void(^)(void))success failure:(void(^)(void))failure {
    Location *location = [Location objectForPrimaryKey:[SAUser shareUser].userId];
    NSMutableDictionary *mutDic = [NSMutableDictionary new];
    if (location.provId) {
        [mutDic setObject:location.provId forKey:@"provinceCode"];
    }
    if (location.cityId) {
        [mutDic setObject:location.cityId forKey:@"cityCode"];
    }
    if (location.areaId) {
        [mutDic setObject:location.areaId forKey:@"areaCode"];
    }
    NSDictionary *param = @{@"id":self.ads.id,
                            @"provinceCode":location.provId ,
                            @"cityCode":location.cityId,
                            @"areaCode":location.areaId,
                            @"channel":channel};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"reqShareAd" parameters:param sucess:^(NSDictionary *response) {
        success();
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure();
    }];
}

- (void)shareAdWithChannel:(NSString *)channel success:(void(^)(void))success failure:(void(^)(void))failure {
    Location *location = [Location objectForPrimaryKey:[SAUser shareUser].userId];
    NSMutableDictionary *mutDic = [NSMutableDictionary new];
    if (location.provId) {
        [mutDic setObject:location.provId forKey:@"provinceCode"];
    }
    if (location.cityId) {
        [mutDic setObject:location.cityId forKey:@"cityCode"];
    }
    if (location.areaId) {
        [mutDic setObject:location.areaId forKey:@"areaCode"];
    }
    NSDictionary *param = @{@"id":self.ads.id,
                            @"provinceCode":location.provId ,
                            @"cityCode":location.cityId,
                            @"areaCode":location.areaId,
                            @"channel":channel};
    [[NetworkManager shareManager] fetchDataWihtMethod:@"shareAd" parameters:param sucess:^(NSDictionary *response) {
        success();
    } failure:^(NSString *errorMessage, NSInteger errorCode) {
        failure();
    }];
}
@end
