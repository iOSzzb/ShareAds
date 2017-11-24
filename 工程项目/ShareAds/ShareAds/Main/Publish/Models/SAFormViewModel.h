//
//  SAFormViewModel.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/25.
//  Copyright © 2017年 张振波. All rights reserved.
//


#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,SAFormCellStyle) {
    SAFormCellStyleJump,
    SAFormCellStyleSwitch,
    SAFormCellStyleInput,
    SAFormCellStyleChoseImg,
    SAFormCellStyleTextView,
    SAFormCellStyleMultiPhotos,
    SAFormCellStyleMultiSelectArea,
    SAFormCellStyleMultiSelectShareChannel
};
typedef NS_ENUM(NSInteger,SAFormID) {
    SAFormIDIndusty,// tradeId	String	是	行业
    SAFormIDCompany,// userCompany	String	否	用户公司
    SAFormIDAdsTitle,//title	String	是	广告标题
    SAFormIDAdsIcon,//iconImage	String	是	广告图标文件ID
    SAFormIDPrice,// price	float	是	单价
    SAFormIDAmount,//amount	float	是	总价
    SAFormIDIsHaveUrl,//isHaveUrl	String	是	是否已有广告链接。Y/N
    SAFormIDImgList,//imgList	String	否	图片文件ID列表
    SAFormIDContent,//content	String	否	内容
    SAFormIDLinkUrl,//url	String	否	广告链接
    SAFormIDAllowShareCount,//allowShareCount String	是	每天允许分享最大次数
    SAFormIDAllowShareTime,//allowShareTime	String	是	允许分享的时间段。01：无限制；02：周末；03：工作日
    SAFormIDAllowShareArea,//allowShareArea	json数组	是
    SAFormIDAllowShareChannel,//allowShareChannel	String	是	允许分享的渠道
    SAFormIDneedInvoice,//needInvoice	String	是	是否需要发票。
    SAFormIDRecommender//recommender	String	是	推荐人
};
@interface SAFormViewModel : NSObject
@property (nonatomic,readonly) SAFormID ID;
@property (nonatomic,readonly) SAFormCellStyle style;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *placeHolder;
@property (nonatomic,assign) BOOL switchStatus;
@property (nonatomic,copy) NSString *inputText;
@property (nonatomic,strong) UIImage *selectedImg;
@property (nonatomic,assign) UIKeyboardType keyboardType;
@property (nonatomic,strong) NSArray<UIImage *> *selectedImgs;
@property (nonatomic,strong) id commitObj;
extern NSString * const SAFormViewModelFirstResponderNotification;
- (instancetype)initWithStyle:(SAFormCellStyle)style ID:(SAFormID)ID;
@end
