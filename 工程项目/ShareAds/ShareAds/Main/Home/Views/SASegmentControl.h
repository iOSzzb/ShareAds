//
//  SASegmentControl.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/10.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  SASegmentControl;
@protocol SASegmentControlDelegate<NSObject>
- (void)segmentControl:(SASegmentControl *)segmentControl didSelectAtIndex:(NSInteger)index;
@end
@interface SASegmentControl : UIView
@property (nonatomic, weak) id<SASegmentControlDelegate> delegate;
@property (nonatomic, copy) NSArray<NSString *> *items;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, assign) NSInteger defaultIndex;
@property (nonatomic, readonly) NSInteger currentIndex;
@end
