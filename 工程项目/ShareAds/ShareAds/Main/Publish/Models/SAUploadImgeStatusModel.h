//
//  SAUploadImgeStatusModel.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/31.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,SAUploadImgeStatus) {
    SAUploadImgeStatusReady=0,//准备上传
    SAUploadImgeStatusUploading,//正在上传
    SAUploadImgeStatusSuccess,//上传成功
    SAUploadImgeStatusFailure//上传失败
};
@interface SAUploadImgeStatusModel : NSObject

/**
 上传的图片
 */
@property (nonatomic, readonly) UIImage *image;

/**
 上传状态
 */
@property (nonatomic, assign) SAUploadImgeStatus status;

/**
 上传成功后得到的文件id
 */
@property (nonatomic, copy) NSString *fileId;

/**
 上传进度
 */
@property (nonatomic, assign) float progress;
- (instancetype)initWithImage:(UIImage *)image ;
@end
