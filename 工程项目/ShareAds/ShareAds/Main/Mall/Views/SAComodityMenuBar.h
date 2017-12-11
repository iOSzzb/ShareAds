//
//  SAComodityMenuBar.h
//  ShareAds
//
//  Created by 张振波 on 2017/12/10.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SAComodityMenuBar;
@protocol SAComodityMenuBarDelegate<NSObject>
- (void)menuBar:(SAComodityMenuBar *)bar didSelectedAtIndex:(NSUInteger)index;
@end
@interface SAComodityMenuBar : UIView
@property (nonatomic,  weak) id<SAComodityMenuBarDelegate> delegate;
- (instancetype)initWithTitles:(NSArray<NSString *> *)titles;
@end
