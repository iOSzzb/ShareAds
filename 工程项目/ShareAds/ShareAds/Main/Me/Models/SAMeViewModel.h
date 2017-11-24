//
//  SAMeViewModel.h
//  ShareAds
//
//  Created by 张振波 on 2017/7/14.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAMeViewModel : NSObject
@property (nonatomic, copy) NSString *rightText;
@property (nonatomic, copy) NSString *leftText;
@property (nonatomic, copy) NSString *littleSubtext;
+ (NSArray<SAMeViewModel *> *)prepareForMeTableView;
@end
