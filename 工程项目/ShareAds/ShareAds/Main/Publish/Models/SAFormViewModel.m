//
//  SAFormViewModel.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/25.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAFormViewModel.h"
NSString * const SAFormViewModelFirstResponderNotification = @"SAFormViewModelFirstResponderNotification";
@implementation SAFormViewModel
- (instancetype)initWithStyle:(SAFormCellStyle)style ID:(SAFormID)ID{
    self = [self init];
    if (self) {
        _style = style;
        _ID = ID;
    }
    return self;
}
@end
