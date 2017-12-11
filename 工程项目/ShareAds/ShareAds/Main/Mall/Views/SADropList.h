//
//  SADropList.h
//  ShareAds
//
//  Created by 张振波 on 2017/12/10.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SADropList;
typedef NS_ENUM(NSInteger,SADropListSource) {
    SADropListSourceTypeCommidy,
    SADropListSourceTypeSort
};
@protocol SADropListDelegate <NSObject>

- (void)dropList:(SADropList *)list didSelectAtIndex:(NSUInteger )index result:(NSString *)result;

@end
@interface SADropList : UIView
@property (nonatomic, assign) SADropListSource sourceType;
@property (nonatomic, weak) id<SADropListDelegate> delegate;
@end
