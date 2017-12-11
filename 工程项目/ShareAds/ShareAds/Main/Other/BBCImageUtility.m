//
//  BBCImageUtility.m
//  BBC
//
//  Created by 张振波 on 16/8/20.
//  Copyright © 2016年 张振波. All rights reserved.
//

#import "BBCImageUtility.h"

@implementation BBCImageUtility
//不改变图片的大小，只做数据压缩
/*! @brief 不改变图片的大小，只做数据压缩
 *
 * @param Image 原图
 * @param targetSize 期望大小单位为bytes
 * @return 如果以最大压缩比压缩都不能达到targetSize则返回nil
 */
+ (UIImage *)compressImage:(UIImage *)sourceImage targetSize:(NSInteger )size {
//    CGFloat compressionQuality = 1.0;
    UIImage *compressedImage = nil;
    for (CGFloat compressionQuality = 0.99; compressionQuality >= 0.0; compressionQuality = compressionQuality-0.01) {
        NSData *imageData = UIImageJPEGRepresentation(sourceImage, compressionQuality);
        if (imageData.length < size) {
            compressedImage = [UIImage imageWithData:imageData];
            break;
        }
    }
    return compressedImage;
    
}
//不改变图片的大小，只做数据压缩
/*! @brief 不改变图片的大小，只做数据压缩
 *
 * @param Image 原图
 * @param targetSize 期望大小单位为bytes
 * @return 如果以最大压缩比压缩都不能达到targetSize则返回nil
 */
+ (NSData *)imageDataFromCompressImage:(UIImage *)sourceImage targetSize:(NSInteger )size {
    //    CGFloat compressionQuality = 1.0;
    NSData *compressedImageData = nil;
    NSData *zeroImageData = UIImageJPEGRepresentation(sourceImage, 0);
    if (zeroImageData.length > size) {
        return nil;
    }
    for (CGFloat compressionQuality = 0.9; compressionQuality >= 0.0; compressionQuality = compressionQuality-0.1) {
        NSData *imageData = UIImageJPEGRepresentation(sourceImage, compressionQuality);
        if (imageData.length < size) {
            compressedImageData = imageData;
            break;
//            break;
        }
    }
    return compressedImageData;
    
}

/*! @brief 等比缩放图片，缩放后所占存储空间当然也会变小。
 *
 * @param Image 原图
 * @param scale 缩放比例，小于1
 * @return 缩放后的图片
 */
+ (UIImage *)scaleImage:(UIImage *)image scale:(CGFloat )scale

{
    NSData *sourceData = UIImageJPEGRepresentation(image, 1.0);
    NSLog(@"原图大小:%lu",(unsigned long)sourceData.length);
    UIImage *newimage;
    CGSize sourceSize = image.size;
    CGSize asize = CGSizeMake(ceilf(sourceSize.width * scale), ceilf(sourceSize.height*scale));
    if (nil == image) {
        
        newimage = nil;
        
    }
    
    else{
        
        UIGraphicsBeginImageContext(asize);
        
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    NSData *targetData = UIImageJPEGRepresentation(newimage, 1.0);
    NSLog(@"压缩后大小:%lu",(unsigned long)targetData.length);
    
    return newimage;
    
}

/*! @brief 等比缩放图片，缩放后所占存储空间当然也会变小。并且占存储空间的大小为原来的scale倍
 *
 * @param Image 原图
 * @param scale 缩放比例，小于1
 * @return 缩放后的图片
 */
+ (NSData *)imageDataFromScaleImage:(UIImage *)image scale:(CGFloat )scale

{
    NSData *sourceData = UIImageJPEGRepresentation(image, 1.0);
    NSLog(@"原图大小:%lu",(unsigned long)sourceData.length);
    UIImage *newimage;
    CGSize sourceSize = image.size;
    CGSize asize = CGSizeMake(ceilf(sourceSize.width * scale), ceilf(sourceSize.height*scale));
    if (nil == image) {
        
        newimage = nil;
        
    }
    
    else{
        
        UIGraphicsBeginImageContext(asize);
        
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    NSData *targetData = UIImageJPEGRepresentation(newimage, 1.0);
    NSLog(@"压缩后大小:%lu",(unsigned long)targetData.length);
    
    return targetData;
    
}
/*! @brief 压缩或者缩放图片，直到所占存储空间小于targetSize，优先压缩
 *
 * @param Image 原图
 * @param targetSize 期望大小，单位为bytes
 * @return 缩放后的图片
 */

+ (NSData *)imageDataFromScaleOrCompressImage:(UIImage *)image targetSize:(NSInteger )targetSize {
//    NSData *data = [BBCImageUtility imageDataFromCompressImage:image targetSize:targetSize];
    NSData *compressedImageData = [BBCImageUtility imageDataFromCompressImage:image targetSize:targetSize];
    if (compressedImageData == nil) {
//        NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
//        CGFloat scale = sqrt((float)targetSize/(float)imgData.length );
        for (CGFloat scale = 0.9; scale > 0; scale = scale - 0.1) {
            compressedImageData = [BBCImageUtility imageDataFromScaleImage:image scale:scale];
            if (compressedImageData.length < targetSize) {
                break;
            }
        }
    
    }
    return compressedImageData;
}


@end
