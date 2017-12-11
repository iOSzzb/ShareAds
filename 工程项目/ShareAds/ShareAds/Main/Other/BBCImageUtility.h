//
//  BBCImageUtility.h
//  BBC
//
//  Created by 张振波 on 16/8/20.
//  Copyright © 2016年 张振波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBCImageUtility : NSObject
/*! @brief 不改变图片的大小，只做数据压缩
 *
 * @param Image 原图
 * @param targetSize 期望大小单位为bytes
 * @return 如果以最大压缩比压缩都不能达到targetSize则返回nil
 */
+ (UIImage *)compressImage:(UIImage *)sourceImage targetSize:(NSInteger )size;

/*! @brief 不改变图片的大小，只做数据压缩
 *
 * @param Image 原图
 * @param targetSize 期望大小单位为bytes
 * @return 如果以最大压缩比压缩都不能达到targetSize则返回nil
 */
+ (NSData *)imageDataFromCompressImage:(UIImage *)sourceImage targetSize:(NSInteger )size;

/*! @brief 等比缩放图片，缩放后所占存储空间当然也会变小。并且占存储空间的大小为原来的scale倍
 *
 * @param Image 原图
 * @param scale 缩放比例，小于1
 * @return 缩放后的图片
 */
+ (UIImage *)scaleImage:(UIImage *)image scale:(CGFloat )scale;

/*! @brief 等比缩放图片，缩放后所占存储空间当然也会变小。并且占存储空间的大小为原来的scale倍
 *
 * @param Image 原图
 * @param scale 缩放比例，小于1
 * @return 缩放后的图片
 */
+ (NSData *)imageDataFromScaleImage:(UIImage *)image scale:(CGFloat )scale;

/*! @brief 压缩或者缩放图片，直到所占存储空间小于targetSize，优先压缩
 *
 * @param Image 原图
 * @param targetSize 期望大小，单位为bytes
 * @return 缩放后的图片
 */

+ (NSData *)imageDataFromScaleOrCompressImage:(UIImage *)image targetSize:(NSInteger )targetSize;
@end
